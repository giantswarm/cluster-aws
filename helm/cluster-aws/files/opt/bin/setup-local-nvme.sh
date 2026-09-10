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
#   from the Ignition config.
# - The kubelet eviction threshold `nodefs.available` is set through a kubeadm patch. Today nodefs and imagefs
#   share the lib volume, so the `imagefs.available` threshold covers both and `nodefs.available` is not set.
#   With the instance store mounted at /var/lib/kubelet they are separate filesystems and nodefs needs its own
#   threshold. Keep the value in sync with `_karpenter_machine_pools.tpl`, which tells Karpenter the same value.
# - An instance stop/start wipes the instance store. The kubelet configuration lives on it, so such a node does
#   not come back and must be replaced. Pre-kubeadm commands run only on the first boot.
set -euo pipefail

err_report() {
  echo "ERROR: ${0} failed on line ${1}"
}
trap 'err_report ${LINENO}' ERR

MOUNT_PATH="/var/lib/kubelet"
FS_LABEL="kubelet-nvme"
RAID_DEVICE="/dev/md/instancestore"
MOUNT_UNIT="/etc/systemd/system/var-lib-kubelet.mount"
PATCH_DIR="/etc/kubernetes/patches"
# Use a unique suffix so this can't accidentally use the same patch filenames as the `cluster` chart
# or kubelet-aws-config.sh. kubeadm applies the patches in alphanumerical order of their file names.
PATCH_FILE="kubeletconfiguration2awsnvme+merge.yaml"
NODEFS_AVAILABLE="10%"

if mountpoint -q "${MOUNT_PATH}"; then
  echo "${MOUNT_PATH} is already a mount point, nothing to do"
  exit 0
fi

# Collect the instance-store NVMe disks. EBS volumes report the model "Amazon Elastic Block Store",
# instance-store disks report "Amazon EC2 NVMe Instance Storage". /sys/block lists whole disks only.
disks=()
for block_device in /sys/block/nvme*n*; do
  [ -e "${block_device}" ] || continue
  model="$(cat "${block_device}/device/model" 2>/dev/null || true)"
  if [[ "${model}" == *"Amazon EC2 NVMe Instance Storage"* ]]; then
    disks+=("/dev/$(basename "${block_device}")")
  fi
done

if [ "${#disks[@]}" -eq 0 ]; then
  echo "No instance-store NVMe disks found, keeping ${MOUNT_PATH} on the EBS lib volume"
  exit 0
fi
echo "Found ${#disks[@]} instance-store NVMe disk(s): ${disks[*]}"

if [ "${#disks[@]}" -eq 1 ]; then
  device="${disks[0]}"
else
  echo "Creating RAID 0 array ${RAID_DEVICE} from ${#disks[@]} disks"
  mdadm --create "${RAID_DEVICE}" --run --force --level=0 --raid-devices="${#disks[@]}" "${disks[@]}"
  mdadm --detail --scan >> /etc/mdadm.conf
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
systemctl daemon-reload
systemctl enable --now var-lib-kubelet.mount
if ! mountpoint -q "${MOUNT_PATH}"; then
  echo "ERROR: ${MOUNT_PATH} is not mounted after starting var-lib-kubelet.mount" >&2
  exit 1
fi
echo "${MOUNT_PATH} is now on ${device}"

# Tell the kubelet to evict pods when the instance-store filesystem runs low on space. This is a JSON merge
# patch (RFC 7386), so it adds nodefs.available next to the evictionHard thresholds set by the `cluster` chart.
mkdir -p "${PATCH_DIR}"
cat > "/tmp/${PATCH_FILE}" <<PATCH
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
evictionHard:
  nodefs.available: "${NODEFS_AVAILABLE}"
PATCH
mv "/tmp/${PATCH_FILE}" "${PATCH_DIR}/${PATCH_FILE}"
echo "Wrote ${PATCH_DIR}/${PATCH_FILE} with evictionHard.nodefs.available=${NODEFS_AVAILABLE}"
