#!/usr/bin/env bash
set -euxo pipefail

# Extract the ELB host from kubeadm.yml
ELB_HOST=$(awk '/^controlPlaneEndpoint:/ {print $2}' /etc/kubeadm.yml | cut -d":" -f1 || true)

if [ -n "${ELB_HOST:-}" ]; then
    echo "Waiting for ELB DNS to be resolvable - ${ELB_HOST}"
    for i in $(seq 1 60); do
        if getent hosts "$ELB_HOST" >/dev/null 2>&1; then
            echo "DNS resolved for ${ELB_HOST} - proceeding with kubeadm"
            break
        fi
        if [ $i -eq 60 ]; then
            echo "ERROR - ELB DNS not resolvable after 5 minutes - ${ELB_HOST}" >&2
            exit 1
        fi
        echo "DNS not yet resolvable (${i}/60), sleeping 5s..."
        sleep 5
    done
else
    echo "No controlPlaneEndpoint found; likely a join node. Skipping DNS wait."
fi
