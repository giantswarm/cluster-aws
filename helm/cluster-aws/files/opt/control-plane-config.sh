#!/bin/sh
set -eu

error() {
	>&2 echo "ERROR: " "${@}"
	exit 1
}

[ -e /etc/kubernetes/manifests/kube-apiserver.yaml ] || error "API server static pod manifest missing"
[ -s /etc/kubernetes/manifests/kube-apiserver.yaml ] || error "API server static pod manifest empty"

# Fix for breaking change when upgrading to v0.38.4+: `--service-account-issuer` value changes to have
# prefix `https://`, and that means existing tokens issued with the old URI are not allowed access
# to the Kubernetes API anymore, breaking operators and other software. Currently, we cannot provide both
# the old and new allowed issuer URL in `KubeadmControlPlane.spec.kubeadmConfigSpec.clusterConfiguration.apiServer.extraArgs`
# because it's a map (https://github.com/kubernetes/kubeadm/issues/1601). Therefore, we overwrite the static pod
# manifest directly. Restarting the kubelet process ensures updating the pod.
# The new issuer URL (`https://[...]`) is the first `--service-account-issuer` argument, while the old
# one is the second so that it's still allowed but not used to issue new JWT tokens.
#
# This can be removed once all management/workload clusters based on cluster-aws are on a newer version. The following
# script is idempotent.
if [ "$(grep -c -- '--service-account-issuer' /etc/kubernetes/manifests/kube-apiserver.yaml)" = 1 ]; then
	awk '
		/--service-account-issuer/ {
			new=$0
			gsub(/issuer=(https:\/\/)?/, "issuer=https://", new)

			old=$0
			gsub(/issuer=(https:\/\/)?/, "issuer=", old)

			print new
			print old
			next
		}
		{
			print
		}
	' /etc/kubernetes/manifests/kube-apiserver.yaml > /tmp/kube-apiserver.yaml.patched
	mv -v /tmp/kube-apiserver.yaml.patched /etc/kubernetes/manifests/kube-apiserver.yaml

	echo "API server manifest patched with service account issuer URLs"

	systemctl restart kubelet
else
	echo "API server manifest already has two \`--service-account-issuer\` entries, skipping fix"
fi
