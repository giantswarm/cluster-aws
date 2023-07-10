#!/bin/bash

# This script is executed by Teleport dynamic label configuration to assign the K8s role 
# for the node (control-plane or worker)

if [ -f "/etc/kubernetes/manifests/kube-apiserver.yaml" ]; then
    echo "control-plane"
else
    echo "worker"
fi
