#!/bin/bash

# Replace Kubeadm Cloudfront placeholder
CLOUDFRONT_DOMAIN="https://$(cat /etc/kubernetes/irsa/cloudfront-domain)"

# We need to store cloudfront domain in kubeadmconfig config map, because kubeadm join can't inject cloudfront domain 
kubectl --kubeconfig /etc/kubernetes/admin.conf -n kube-system get cm kubeadm-config -o yaml > /tmp/kubeadmconfig.yaml
sed -i "s|PLACEHOLDER_CLOUDFRONT_DOMAIN|$CLOUDFRONT_DOMAIN|g" /tmp/kubeadmconfig.yaml
kubectl --kubeconfig /etc/kubernetes/admin.conf replace -f /tmp/kubeadmconfig.yaml
