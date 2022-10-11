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
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
cluster.x-k8s.io/watch-filter: capi
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ .Values.organization | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
release.giantswarm.io/version: {{ .Values.releaseVersion | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Values.clusterName | default (.Release.Name | replace "." "-" | trunc 47 | trimSuffix "-") -}}
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

{{- define "diskFiles" -}}
- path: /opt/init-disks.sh
  permissions: "0700"
  encoding: base64
  content: {{ $.Files.Get "files/opt/init-disks.sh" | b64enc }}
{{- end -}}
{{- define "proxyFiles" -}}
- path: /etc/systemd/system/containerd.service.d/http-proxy.conf
  permissions: "0644"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/systemd/system/containerd.service.d/http-proxy.conf") $ | b64enc }}
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


{{- define "sshPostKubeadmCommands" -}}
- systemctl restart sshd
{{- end -}}

{{- define "diskPreKubeadmCommands" -}}
- /bin/sh /opt/init-disks.sh
{{- end -}}

{{- define "irsaPreKubeadmCommands" -}}
- /bin/sh /opt/irsa-cloudfront.sh
{{- end -}}

{{- define "sshUsers" -}}
- name: giantswarm
  groups: sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
{{- end -}}

{{- define "bastionIgnition" }}
{{- tpl ($.Files.Get "files/bastion.iqn") . | b64enc}}
{{- end -}}

{{- define "ami" }}
{{- if .Values.ami }}
ami:
  id: {{ .Values.ami }}
{{- else -}}
ami: {}
imageLookupBaseOS: "ubuntu-20.04"
imageLookupFormat: {{ "capa-ami-{{.BaseOS}}-{{.K8sVersion}}-00-gs" }}
imageLookupOrg: "706635527432"
{{- end }}
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
{{- if .global.Values.hashSalt }}{{ $salt = .global.Values.hashSalt}}{{end}}
{{- (printf "%s%s" $data $salt) | quote | sha1sum | trunc 8 }}
{{- end -}}
