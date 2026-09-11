#!/usr/bin/env bash
#
# Use the local instance-store NVMe disks of the instance as the filesystem for /var/lib/kubelet.
#
# The cluster-aws chart runs this script as a pre-kubeadm command on the worker nodes of node pools that
# set `localNvme.enabled: true` (see the `awsWorkersPreKubeadmCommands` template). It must run before
# `kubeadm join`, which writes the kubelet configuration into /var/lib/kubelet and starts the kubelet.
#
# - Instances without instance-store disks keep /var/lib/kubelet on the EBS lib volume. Nothing else changes.
# - Several instance-store disks are combined into one RAID 0 array.
# - The filesystem is mounted through a systemd mount unit ordered after var-lib.mount, the EBS lib volume
#   from the Ignition config. A kubelet.service drop-in requires that mount, so the kubelet does not start
#   against an empty EBS directory when the filesystem is missing.
# - The kubelet eviction thresholds `nodefs.available` and `nodefs.inodesFree` are set through a kubeadm patch.
#   Today nodefs and imagefs share the lib volume, so the `imagefs.available` threshold covers both and the
#   `cluster` chart sets no nodefs thresholds. With the instance store mounted at /var/lib/kubelet they are
#   separate filesystems and nodefs needs its own thresholds. Keep `nodefs.available` in sync with
#   `_karpenter_machine_pools.tpl`, which tells Karpenter the same value.
# - The script can run more than once. The kubeadm bootstrap re-runs its pre-kubeadm commands on every start of
#   kubeadm.service until `kubeadm join` succeeds, including after a reboot. A later run either finds the
#   filesystem mounted and only makes sure the kubelet patch exists, or removes what an earlier run left on the
#   disks and starts over. Before the node joins, the instance store holds nothing worth keeping.
# - An instance stop/start wipes the instance store. The kubelet configuration lives on it, so the kubelet does
#   not start on such a node and the node stays NotReady until it is deleted (Machine or NodeClaim).
set -euo pipefail

err_report() {
  echo "ERROR: ${0} failed on line ${1}"
}
trap 'err_report ${LINENO}' ERR

MOUNT_PATH="/var/lib/kubelet"
FS_LABEL="kubelet-nvme"
RAID_DEVICE="/dev/md/instancestore"
MOUNT_UNIT="/etc/systemd/system/var-lib-kubelet.mount"
KUBELET_DROPIN_DIR="/etc/systemd/system/kubelet.service.d"
KUBELET_DROPIN="${KUBELET_DROPIN_DIR}/20-var-lib-kubelet-mount.conf"
PATCH_DIR="/etc/kubernetes/patches"
# Use a unique suffix so this can't accidentally use the same patch filenames as the `cluster` chart
# or kubelet-aws-config.sh. kubeadm applies the patches in alphanumerical order of their file names.
PATCH_FILE="kubeletconfiguration2awsnvme+merge.yaml"
NODEFS_AVAILABLE="10%"
NODEFS_INODES_FREE="5%"

# Tell the kubelet to evict pods when the instance-store filesystem runs low on space or inodes. This is a JSON
# merge patch (RFC 7386), so it adds the nodefs thresholds next to the evictionHard thresholds set by the
# `cluster` chart. A configured evictionHard map replaces the kubelet defaults, so nodefs.inodesFree (kubelet
# default 5%) has to be set here as well.
write_kubelet_patch() {
  mkdir -p "${PATCH_DIR}"
  cat > "/tmp/${PATCH_FILE}" <<PATCH
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
evictionHard:
  nodefs.available: "${NODEFS_AVAILABLE}"
  nodefs.inodesFree: "${NODEFS_INODES_FREE}"
PATCH
  mv "/tmp/${PATCH_FILE}" "${PATCH_DIR}/${PATCH_FILE}"
  echo "Wrote ${PATCH_DIR}/${PATCH_FILE} with evictionHard nodefs.available=${NODEFS_AVAILABLE} nodefs.inodesFree=${NODEFS_INODES_FREE}"
}

# Unmount every mount of the given block device.
unmount_device() {
  local target
  while read -r target; do
    [ -n "${target}" ] || continue
    echo "Unmounting ${target}"
    umount "${target}"
  done < <(findmnt -rn -o TARGET -S "${1}" || true)
}

if mountpoint -q "${MOUNT_PATH}"; then
  echo "${MOUNT_PATH} is already a mount point"
  write_kubelet_patch
  exit 0
fi

# Collect the instance-store NVMe disks. EBS volumes report the model "Amazon Elastic Block Store",
# instance-store disks report "Amazon EC2 NVMe Instance Storage". /sys/block lists whole disks only. With NVMe
# multipath it also lists hidden per-path entries (for example nvme1c1n1) that have no device node; skip those.
disks=()
for block_device in /sys/block/nvme*n*; do
  [ -e "${block_device}" ] || continue
  disk="/dev/$(basename "${block_device}")"
  [ -b "${disk}" ] || continue
  model="$(cat "${block_device}/device/model" 2>/dev/null || true)"
  if [[ "${model}" == *"Amazon EC2 NVMe Instance Storage"* ]]; then
    disks+=("${disk}")
  fi
done

if [ "${#disks[@]}" -eq 0 ]; then
  echo "No instance-store NVMe disks found, keeping ${MOUNT_PATH} on the EBS lib volume"
  exit 0
fi
echo "Found ${#disks[@]} instance-store NVMe disk(s): ${disks[*]}"

# Remove what an earlier run of this script may have left on the disks: stop RAID arrays that use them (Flatcar
# assembles RAID members again at boot and `mdadm --create` refuses busy members), unmount them and wipe their
# signatures.
for disk in "${disks[@]}"; do
  for holder in "/sys/block/$(basename "${disk}")"/holders/md*; do
    [ -e "${holder}" ] || continue
    md_device="/dev/$(basename "${holder}")"
    echo "Stopping RAID array ${md_device} left over from an earlier run"
    unmount_device "${md_device}"
    mdadm --stop "${md_device}"
  done
  unmount_device "${disk}"
  wipefs --all --quiet "${disk}"
done
udevadm settle

if [ "${#disks[@]}" -eq 1 ]; then
  device="${disks[0]}"
else
  echo "Creating RAID 0 array ${RAID_DEVICE} from ${#disks[@]} disks"
  # No /etc/mdadm.conf entry is needed: udev assembles the array at boot from the member superblocks, and the
  # mount unit refers to the filesystem label, not to the array device.
  mdadm --create "${RAID_DEVICE}" --run --force --level=0 --raid-devices="${#disks[@]}" "${disks[@]}"
  device="${RAID_DEVICE}"
fi

echo "Creating XFS filesystem with label ${FS_LABEL} on ${device}"
mkfs.xfs -f -L "${FS_LABEL}" "${device}"
# Wait for udev to create /dev/disk/by-label/${FS_LABEL} before the mount unit refers to it.
udevadm settle

# kubelet.service is enabled in the image and restarts every 10 seconds until kubeadm writes its configuration
# into ${MOUNT_PATH}. It fails before it opens anything there, so the directory is normally still empty. Stop
# the service anyway so that no process holds files in the old directory while it moves to the new filesystem.
# The kubelet-start phase of `kubeadm join` starts the kubelet again after it has written the configuration.
systemctl stop kubelet.service

# Preserve anything that already exists in the kubelet directory.
mkdir -p "${MOUNT_PATH}"
if [ -n "$(ls -A "${MOUNT_PATH}")" ]; then
  echo "Copying existing content of ${MOUNT_PATH} to the new filesystem"
  tmp_mount="$(mktemp -d)"
  mount -t xfs "${device}" "${tmp_mount}"
  cp -a "${MOUNT_PATH}/." "${tmp_mount}/"
  umount "${tmp_mount}"
  rmdir "${tmp_mount}"
fi

echo "Writing ${MOUNT_UNIT}"
cat > "${MOUNT_UNIT}" <<UNIT
[Unit]
Description=Instance-store NVMe filesystem for ${MOUNT_PATH}
After=var-lib.mount
RequiresMountsFor=/var/lib

[Mount]
What=/dev/disk/by-label/${FS_LABEL}
Where=${MOUNT_PATH}
Type=xfs
Options=defaults,noatime

[Install]
WantedBy=local-fs.target
UNIT

# Make kubelet.service depend on the mount. Without the filesystem (instance stop/start, array not assembled)
# the kubelet then fails with a dependency error instead of running on an empty EBS directory.
echo "Writing ${KUBELET_DROPIN}"
mkdir -p "${KUBELET_DROPIN_DIR}"
cat > "${KUBELET_DROPIN}" <<DROPIN
[Unit]
RequiresMountsFor=${MOUNT_PATH}
DROPIN

# Write the patch before the mount starts: a later run of this script exits as soon as the mount exists.
write_kubelet_patch

systemctl daemon-reload
systemctl enable --now var-lib-kubelet.mount
if ! mountpoint -q "${MOUNT_PATH}"; then
  echo "ERROR: ${MOUNT_PATH} is not mounted after starting var-lib-kubelet.mount" >&2
  exit 1
fi

# The root of the new filesystem has the mode and SELinux label from mkfs, not those of the directory it
# replaces (0750, relabelled by the `cluster` chart before this script runs).
chmod 0750 "${MOUNT_PATH}"
restorecon -R "${MOUNT_PATH}"
echo "${MOUNT_PATH} is now on ${device}"
