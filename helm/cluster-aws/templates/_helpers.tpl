{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
{{- include "labels.selector" $ }}
helm.sh/chart: {{ include "chart" . | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ required "You must provide an existing organization name in .metadata.organization" .Values.metadata.organization | quote }}
cluster.x-k8s.io/watch-filter: capi
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Values.metadata.name | default (.Release.Name | replace "." "-" | trunc 47 | trimSuffix "-") -}}
{{- end -}}

{{- define "oidcFiles" -}}
{{- if .Values.controlPlane.oidc.caPem }}
- path: /etc/ssl/certs/oidc.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssl/certs/oidc.pem") . | b64enc }}
{{- end }}
{{- end -}}

{{- define "sshFiles" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssh/trusted-user-ca-keys.pem") . | b64enc }}
- path: /etc/ssh/sshd_config
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/ssh/sshd_config" | b64enc }}
{{- end -}}

{{- define "sshFilesBastion" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssh/trusted-user-ca-keys.pem") . | b64enc }}
- path: /etc/ssh/sshd_config
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/ssh/sshd_config_bastion" | b64enc }}
{{- end -}}

{{- define "proxyFiles" -}}
- path: /etc/systemd/system/containerd.service.d/http-proxy.conf
  permissions: "0644"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/http-proxy.conf") $ | b64enc }}
- path: /etc/systemd/system/kubelet.service.d/http-proxy.conf
  permissions: "0644"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/http-proxy.conf") $ | b64enc }}
{{- end -}}
{{- define "proxyCommand" -}}
- export HTTP_PROXY={{ $.Values.connectivity.proxy.httpProxy }}
- export HTTPS_PROXY={{ $.Values.connectivity.proxy.httpsProxy }}
- export NO_PROXY=127.0.0.1,localhost,svc,local,169.254.169.254,{{ $.Values.connectivity.network.vpcCidr }},{{ join "," $.Values.connectivity.network.services.cidrBlocks }},{{ join "," $.Values.connectivity.network.pods.cidrBlocks }},{{ include "resource.default.name" $ }}.{{ $.Values.baseDomain }},elb.amazonaws.com,{{ $.Values.connectivity.proxy.noProxy }}
- export http_proxy={{ $.Values.connectivity.proxy.httpProxy }}
- export https_proxy={{ $.Values.connectivity.proxy.httpsProxy }}
- export no_proxy=127.0.0.1,localhost,svc,local,169.254.169.254,{{ $.Values.connectivity.network.vpcCidr }},{{ join "," $.Values.connectivity.network.services.cidrBlocks }},{{ join "," $.Values.connectivity.network.pods.cidrBlocks }},{{ include "resource.default.name" $ }}.{{ $.Values.baseDomain }},elb.amazonaws.com,{{ $.Values.connectivity.proxy.noProxy }}
{{- end -}}

{{- define "registryFiles" -}}
- path: /etc/containerd/config.toml
  permissions: "0644"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-registry-configuration
      key: registry-config.toml
{{- end -}}
{{- define "irsaFiles" -}}
- path: /opt/irsa-cloudfront.sh
  permissions: "0700"
  encoding: base64
  content: {{ $.Files.Get "files/opt/irsa-cloudfront.sh" | b64enc }}
{{- end -}}
{{- define "kubeletConfigFiles" -}}
- path: /opt/kubelet-config.sh
  permissions: "0700"
  encoding: base64
  content: {{ $.Files.Get "files/opt/kubelet-config.sh" | b64enc }}
- path: /etc/systemd/logind.conf.d/zzz-kubelet-graceful-shutdown.conf
  permissions: "0700"
  encoding: base64
  content: {{ $.Files.Get "files/etc/systemd/logind.conf.d/zzz-kubelet-graceful-shutdown.conf" | b64enc }}
{{- end -}}

{{- define "kubernetesFiles" -}}
- path: /etc/kubernetes/policies/audit-policy.yaml
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/kubernetes/policies/audit-policy.yaml" | b64enc }}
- path: /etc/kubernetes/encryption/config.yaml
  permissions: "0600"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-encryption-provider-config
      key: encryption
- path: /etc/kubernetes/irsa/cloudfront-domain
  permissions: "0600"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-irsa-cloudfront
      key: domain
{{- end -}}

{{- define "nodeConfigFiles" -}}
- path: /etc/systemd/timesyncd.conf
  permissions: "0644"
  encoding: base64
  content: {{ $.Files.Get "files/etc/systemd/timesyncd.conf" | b64enc }}
- path: /etc/sysctl.d/hardening.conf
  permissions: "0644"
  encoding: base64
  content: {{ $.Files.Get "files/etc/sysctl.d/hardening.conf" | b64enc }}
{{- end -}}

{{- define "teleportFiles" -}}
- path: /opt/teleport-join-token
  permissions: "0644"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-teleport-join-token
      key: joinToken
- path: /opt/install-teleport.sh
  permissions: "0644"
  encoding: base64
  content: {{ $.Files.Get "files/opt/install-teleport.sh" | b64enc }}
- path: /etc/teleport.yaml
  permissions: "0644"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/teleport.yaml") . | b64enc }}  
{{- end -}}

{{- define "filesConfig" -}}
- path: "/opt/test-teleport-v13.1.5-linux-amd64-bin.tar.gz"
  contents:
    remote:
      url: "https://cdn.teleport.dev/teleport-v13.1.5-linux-amd64-bin.tar.gz"
      verification:
        hash:
          function: "sha256"
          sum: "21aab317ada257dea9d31ece2545082e477887a7a974c4bacc92ede34069506c"
{{- end -}}

{{- define "diskStorageConfig" -}}
- name: etcd
  mount:
    device: /dev/xvdc
    wipeFilesystem: true
    label: etcd
    format: xfs
- name: containerd
  mount:
    device: /dev/xvdd
    wipeFilesystem: true
    label: containerd
    format: xfs
- name: kubelet
  mount:
    device: /dev/xvde
    wipeFilesystem: true
    label: kubelet
    format: xfs
{{- end -}}

{{- define "diskStorageSystemdUnits" -}}
- name: var-lib-etcd.mount
  enabled: true
  contents: |
    [Unit] 
    Description=etcd volume
    DefaultDependencies=no
    [Mount]
    What=/dev/disk/by-label/etcd
    Where=/var/lib/etcd
    Type=xfs
    [Install]
    WantedBy=local-fs-pre.target
- name: var-lib-kubelet.mount
  enabled: true
  contents: |
    [Unit]
    Description=kubelet volume
    DefaultDependencies=no
    [Mount]
    What=/dev/disk/by-label/kubelet
    Where=/var/lib/kubelet
    Type=xfs
    [Install]
    WantedBy=local-fs-pre.target
- name: var-lib-containerd.mount
  enabled: true
  contents: |
    [Unit]
    Description=containerd volume
    DefaultDependencies=no
    [Mount]
    What=/dev/disk/by-label/containerd
    Where=/var/lib/containerd
    Type=xfs
    [Install]
    WantedBy=local-fs-pre.target
{{- end -}}


{{- define "teleportSystemdUnits" -}}
- name: teleport.service
  enabled: true
  contents: |
    [Unit]
    Description=Teleport Service
    After=network.target

    [Service]
    Type=simple
    Restart=on-failure
    ExecStartPre=/bin/bash /opt/install-teleport.sh
    ExecStart=/opt/bin/teleport start --roles=node --config=/etc/teleport.yaml --pid-file=/run/teleport.pid
    ExecReload=/bin/kill -HUP $MAINPID
    PIDFile=/run/teleport.pid
    LimitNOFILE=524288

    [Install]
    WantedBy=multi-user.target
{{- end -}}

{{- define "sshPreKubeadmCommands" -}}
- systemctl restart sshd
{{- end -}}

{{- define "irsaPostKubeadmCommands" -}}
- /bin/sh /opt/irsa-cloudfront.sh /etc/kubernetes/manifests/kube-apiserver.yaml
{{- end -}}

{{- define "kubeletConfigPostKubeadmCommands" -}}
- /bin/sh /opt/kubelet-config.sh
{{- end -}}

{{- define "sshUsers" -}}
- name: giantswarm
  groups: sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
{{- end -}}

{{- define "ami" }}
{{- with .Values.providerSpecific.ami }}
ami:
  id: {{ . | quote }}
{{- else -}}
ami: {}
imageLookupBaseOS: "flatcar-stable"
imageLookupFormat: {{ "capa-ami-{{.BaseOS}}-v{{.K8sVersion}}-gs" }}
imageLookupOrg: "706635527432"
{{- end }}
{{- end -}}

{{- define "nodeDirectories" -}}
- path: /var/lib/kubelet
  mode: 0750
{{- end -}}

{{- define "flatcarSystemdUnits" -}}
- name: kubereserved.slice
  path: /etc/systemd/system/kubereserved.slice
  content: |
    [Unit]
    Description=Limited resources slice for Kubernetes services
    Documentation=man:systemd.special(7)
    DefaultDependencies=no
    Before=slices.target
    Requires=-.slice
    After=-.slice
- name: kubeadm.service
  dropins:
  - name: 10-flatcar.conf
    contents: |
      [Unit]
      # kubeadm must run after coreos-metadata populated /run/metadata directory.
      Requires=coreos-metadata.service
      After=coreos-metadata.service
      [Service]
      # Ensure kubeadm service has access to kubeadm binary in /opt/bin on Flatcar.
      Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/bin
      # To make metadata environment variables available for pre-kubeadm commands.
      EnvironmentFile=/run/metadata/*
- name: containerd.service
  enabled: true
  contents: |
  dropins:
    - name: 10-change-cgroup.conf
      contents: |
        [Service]
        CPUAccounting=true
        MemoryAccounting=true
        Slice=kubereserved.slice
- name: os-hardening.service
  enabled: true
  contents: |
    [Unit]
    Description=Apply os hardening
    [Service]
    Type=oneshot
    ExecStartPre=-/bin/bash -c "gpasswd -d core rkt; gpasswd -d core docker; gpasswd -d core wheel"
    ExecStartPre=/bin/bash -c "until [ -f '/etc/sysctl.d/hardening.conf' ]; do echo Waiting for sysctl file; sleep 1s;done;"
    ExecStart=/usr/sbin/sysctl -p /etc/sysctl.d/hardening.conf
    [Install]
    WantedBy=multi-user.target
- name: audit-rules.service
  enabled: true
  dropins:
  - name: 10-wait-for-containerd.conf
    contents: |
      [Service]
      ExecStartPre=/bin/bash -c "while [ ! -f /etc/audit/rules.d/containerd.rules ]; do echo 'Waiting for /etc/audit/rules.d/containerd.rules to be written' && sleep 1; done"
- name: update-engine.service
  enabled: false
  mask: true
- name: locksmithd.service
  enabled: false
  mask: true
{{- end -}}

{{- define "flatcarKubeadmPreCommands" -}}
- envsubst < /etc/kubeadm.yml > /etc/kubeadm.yml.tmp
- mv /etc/kubeadm.yml.tmp /etc/kubeadm.yml
{{- end -}}

{{/*
Hash function based on data provided
Expects two arguments (as a `dict`) E.g.
  {{ include "hash" (dict "data" . "global" $global) }}
Where `data` is the data to has on and `global` is the top level scope.
*/}}
{{- define "hash" -}}
{{- $data := mustToJson .data | toString  }}
{{- $salt := "" }}
{{- if .global.Values.internal.hashSalt }}{{ $salt = .global.Values.internal.hashSalt}}{{end}}
{{- (printf "%s%s" $data $salt) | quote | sha1sum | trunc 8 }}
{{- end -}}

{{- define "securityContext.runAsUser" -}}
1000
{{- end -}}
{{- define "securityContext.runAsGroup" -}}
1000
{{- end -}}
