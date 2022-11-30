#!/bin/bash

# Replace Kubeadm Cloudfront placeholder
CLOUDFRONT_DOMAIN="https://$(cat /etc/kubernetes/irsa/cloudfront-domain)"

sed -i "s|PLACEHOLDER_CLOUDFRONT_DOMAIN|$CLOUDFRONT_DOMAIN|g" /run/kubeadm/kubeadm.yaml
