#!/bin/sh
# check for NVME disks
if [ "`lsblk | grep nvme | wc -l`" -ge 4 ]; then
	ETCD_DISK="/dev/nvme1n1"
	CONTAINERD_DISK="/dev/nvme2n1"
	KUBELET_DISK="/dev/nvme3n1"
	echo found nvme DISKs
else
	ETCD_DISK="/dev/xvdc"
        CONTAINERD_DISK="/dev/xvdd"
        KUBELET_DISK="/dev/xvde"
fi

# init etcd disk
mkfs.xfs $ETCD_DISK
mkdir -p /var/lib/etcd
mount $ETCD_DISK /var/lib/etcd

# init kubelet disk
mkfs.xfs $KUBELET_DISK
mkdir -p /var/lib/kubelet
mount $KUBELET_DISK /var/lib/kubelet

# init containerd disk
mkfs.xfs $CONTAINERD_DISK
systemctl stop containerd
rm -rf /var/lib/containerd
mkdir -p /var/lib/containerd
mount $CONTAINERD_DISK /var/lib/containerd
systemctl start containerd
