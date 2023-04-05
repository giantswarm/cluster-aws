#!/bin/bash

sed -i "s|shutdownGracePeriod: .*|shutdownGracePeriod: 5m|g" "/var/lib/kubelet/config.yaml"
sed -i "s|shutdownGracePeriodCriticalPods: .*|shutdownGracePeriodCriticalPods: 1m|g" "/var/lib/kubelet/config.yaml"
systemctl restart kubelet
