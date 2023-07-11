#!/bin/bash

# This script is executed by Teleport dynamic label configuration to assign the K8s role 
# for the node (control-plane or worker)


if pgrep "kubelet" > /dev/null; then
    if pgrep "kube-apiserver" > /dev/null; then
        echo "control-plane"
    else
        echo "worker"
    fi
else
    echo ""
fi
