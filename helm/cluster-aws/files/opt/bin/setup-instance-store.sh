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

FS_LABEL="kubelet-instance-store"
RAID_DEVICE="/dev/md/instancestore"
if [ "${#disks[@]}" -eq 0 ]; then
  echo "ERROR: the instance has no instance-store disks, so /var/lib/kubelet cannot be placed on them" >&2
  exit 1
fi
echo "Found ${#disks[@]} instance-store disk(s): ${disks[*]}"

if [ "${#disks[@]}" -eq 1 ]; then
  device="${disks[0]}"
else
  echo "Creating RAID0 array ${RAID_DEVICE} from ${#disks[@]} disks"
  mdadm --create "${RAID_DEVICE}" --run --force --level=0 --raid-devices="${#disks[@]}" "${disks[@]}"
  device="${RAID_DEVICE}"
fi

echo "Creating XFS filesystem with label ${FS_LABEL} on ${device}"
mkfs.xfs -f -L "${FS_LABEL}" "${device}"
# Wait for udev to create `/dev/disk/by-label/${FS_LABEL}`, which `var-lib-kubelet.mount` refers to
udevadm settle
