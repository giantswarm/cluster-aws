#!/usr/bin/env bash
#
# Create one filesystem from the instance-store disk(s) (RAID0 if multiple disks)
# and label it, so that `var-lib-kubelet.mount` can mount it on `/var/lib/kubelet`.
#
# Only used for node pools with the setting `kubeletVolume: instanceStore`.
set -euo pipefail

err_report() {
  echo "ERROR: ${0} failed on line ${1}"
}
trap 'err_report ${LINENO}' ERR

FS_LABEL="lib-kubelet" # mind 12-char maximum of XFS labels
RAID_DEVICE="/dev/md/instancestore"

# Look up NVMe instance store disks (adapted from https://github.com/awslabs/amazon-eks-ami/blob/main/templates/al2023/runtime/bin/setup-local-disks).

# The symlinks only appear once udev has processed the devices
udevadm settle

# udev creates several `by-id` symlinks per disk, one of them suffixed with the namespace ID, so
# resolve them to device nodes and deduplicate
readarray -t disks < <(find -L /dev/disk/by-id/ -xtype l \
  -name 'nvme-Amazon_EC2_NVMe_Instance_Storage_*' ! -name '*-part*' \
  -exec realpath {} + | sort -u)

if [ "${#disks[@]}" -eq 0 ]; then
  echo "ERROR: the instance has no instance-store disks, so /var/lib/kubelet cannot be placed on them" >&2
  exit 1
fi
echo "Found ${#disks[@]} instance-store disk(s): ${disks[*]}"

if [ "${#disks[@]}" -eq 1 ]; then
  device="${disks[0]}"
else
  echo "Creating RAID0 array ${RAID_DEVICE} from ${#disks[@]} disks"
  # `--homehost=any` keeps the array assemblable after a reboot even if the host name changed. Without
  # it a failed assembly would leave the label missing, and this script would reformat the disks.
  mdadm --create "${RAID_DEVICE}" --run --force --homehost=any --level=0 --raid-devices="${#disks[@]}" "${disks[@]}"
  device="${RAID_DEVICE}"
fi

echo "Creating XFS filesystem with label ${FS_LABEL} on ${device}"
mkfs.xfs -f -L "${FS_LABEL}" "${device}"
# Wait for udev to create `/dev/disk/by-label/${FS_LABEL}`, which `var-lib-kubelet.mount` refers to
udevadm settle
