#!/bin/bash

sed -i "s|shutdownGracePeriod: .*|shutdownGracePeriod: 30s|g" "/var/lib/kubelet/config.yaml"
systemctl restart kubelet
