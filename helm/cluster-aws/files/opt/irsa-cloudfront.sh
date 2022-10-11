#!/bin/sh
# Replace Kubeadm Cloudfront placeholder

CLOUDFRONT_DOMAIN=$(cat /etc/kubernetes/irsa/cloudfront-domain)
sed -i "s/PLACEHOLDER_CLOUDFRONT_DOMAIN/$CLOUDFRONT_DOMAIN/g" /tmp/kubeadm.yaml
