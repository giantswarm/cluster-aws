#!/bin/sh
# Replace Kubeadm Cloudfront placeholder

CLOUDFRONT_DOMAIN=$(cat /etc/kubernetes/irsa/cloudfront-domain)

kubeadm_file="/etc/kubeadm.yml"
if [[ ! -f ${kubeadm_file} ]]; then
    kubeadm_file="/run/kubeadm/kubeadm.yaml"
fi

sed -i "s/PLACEHOLDER_CLOUDFRONT_DOMAIN/$CLOUDFRONT_DOMAIN/g" $kubeadm_file
