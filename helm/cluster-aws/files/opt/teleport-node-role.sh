#!/bin/bash

if systemctl is-active -q kubelet.service; then
    if [ -e "/etc/kubernetes/manifests/kube-apiserver.yaml" ]; then
        echo "control-plane"
    else
        echo "worker"
    fi
else
    echo ""
fi
