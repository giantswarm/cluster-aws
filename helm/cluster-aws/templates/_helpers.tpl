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
release.giantswarm.io/version: {{ .Values.global.release.version | trimPrefix "v" | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ .Values.global.metadata.organization | quote }}
cluster.x-k8s.io/watch-filter: capi
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Values.global.metadata.name | default (.Release.Name | replace "." "-" | trunc 47 | trimSuffix "-") -}}
{{- end -}}

{{- define "preventDeletionLabel" -}}
{{- if $.Values.global.metadata.preventDeletion -}}
giantswarm.io/prevent-deletion: "true"
{{ end -}}
{{- end -}}

{{- define "noProxyList" -}}
127.0.0.1,localhost,svc,local,169.254.169.254,{{ $.Values.global.connectivity.network.vpcCidr }},{{ join "," $.Values.global.connectivity.network.services.cidrBlocks }},{{ join "," $.Values.global.connectivity.network.pods.cidrBlocks }},{{ include "resource.default.name" $ }}.{{ $.Values.global.connectivity.baseDomain }},elb.amazonaws.com,{{ $.Values.global.connectivity.proxy.noProxy }}
{{- end -}}

{{- define "controlPlanePostKubeadmCommands" -}}
- /opt/control-plane-config.sh
{{- end -}}

{{- /*
    "imageLookupParameters" named template renders YAML manifest that is used in AWSMachineTemplate and in AWSMachinePool resources.

    This template is using "cluster.os.*" named templates that are defined in the cluster chart. For more details about
    how these templates work see cluster chart docs at https://github.com/giantswarm/cluster/tree/main/helm/cluster.
*/}}
{{- define "imageLookupParameters" }}
{{- /* Get OS version. */}}
imageLookupBaseOS: "{{ include "cluster.os.version" $ }}"
{{- /* Get OS name, release channel and tooling version, which we use in the OS image name. */}}
{{- $osName := include "cluster.os.name" $ }}
{{- $osReleaseChannel := include "cluster.os.releaseChannel" $ }}
{{- $osVersion := include "cluster.os.version" $ }}
{{- $osToolingVersion := include "cluster.os.tooling.version" $ }}
{{- $k8sVersion := include "cluster.component.kubernetes.version" $ }}
{{- /* Build the OS image name. The OS images are built automatically by the CI. */}}
{{- /* Example result: `flatcar-stable-4230.2.0-kube-1.33.2-tooling-1.26.1-gs` */}}
imageLookupFormat: {{ $osName }}-{{$osReleaseChannel }}-{{$osVersion}}-kube-{{$k8sVersion}}-tooling-{{ $osToolingVersion }}-gs
imageLookupOrg: "{{ if hasPrefix "cn-" (include "aws-region" .) }}306934455918{{else}}706635527432{{end}}"
{{- end }}

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

{{- define "awsConnectivityLabels" }}
network-topology.giantswarm.io/mode: "{{ .Values.global.connectivity.topology.mode }}"
{{- if .Values.global.connectivity.topology.transitGatewayId }}
network-topology.giantswarm.io/transit-gateway: "{{ .Values.global.connectivity.topology.transitGatewayId }}"
{{- end }}
{{- if .Values.global.connectivity.topology.prefixListId }}
network-topology.giantswarm.io/prefix-list: "{{ .Values.global.connectivity.topology.prefixListId }}"
{{- end }}
{{- end }}

{{- define "awsApiServerApiAudiences" }}
sts.amazonaws.com{{ if hasPrefix "cn-" (include "aws-region" .) }}.cn{{ end }}
{{- end }}

{{- define "awsIrsaServiceAccountIssuer" }}
{{- if hasPrefix "cn-" (include "aws-region" .) -}}
https://s3.{{include "aws-region" .}}.amazonaws.com.cn/{{ include "aws-account-id" .}}-g8s-{{include "resource.default.name" $}}-oidc-pod-identity-v3
{{- else -}}
https://irsa.{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}
{{- end }}
{{- end }}

{{- define "awsContainerImageRegistry" -}}
gsoci.azurecr.io
{{- end }}

{{- define "awsNoProxyList" }}
- {{ $.Values.global.connectivity.network.vpcCidr }}
{{- end }}

{{- define "resource.default.additionalTags" -}}
{{- if .Values.global.providerSpecific.additionalResourceTags }}
{{ toYaml .Values.global.providerSpecific.additionalResourceTags }}
{{- end }}
giantswarm.io/cluster: {{ include "resource.default.name" $ }}
{{- end -}}

{{- define "hasKarpenterNodePool" -}}
{{- range $name, $value := .Values.global.nodePools }}
  {{- if eq $value.type "karpenter" }}
    {{- print "true" -}}
    {{- break -}}
  {{- end }}
{{- end }}
{{- end }}

{{- define "hasAWSMachinePools" -}}
{{- range $name, $value := .Values.global.nodePools }}
  {{- if ne $value.type "karpenter" }}
    {{- print "true" -}}
    {{- break -}}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Calculate the absolute maximum number of pods per node based on podCidr and nodeMaskSize.
This is the maximum allowed by IP address space, capped at 110 pods.
Formula: min(110, 2^(32 - nodeCidrMaskSize) - 2)
*/}}
{{- define "maxPodsAbsolute" -}}
{{- $nodeCidrMaskSize := .Values.global.connectivity.network.pods.nodeCidrMaskSize | int }}
{{- $exponent := sub 32 $nodeCidrMaskSize | int }}
{{- $result := 1 }}
{{- range $i := until $exponent }}
  {{- $result = mul $result 2 }}
{{- end }}
{{- $availableIps := sub $result 2 | int }}
{{- $maxPods := 110 }}
{{- if lt $availableIps $maxPods }}
  {{- $maxPods = $availableIps }}
{{- end }}
{{- $maxPods }}

{{- define "useCertManagerDnsChallenges" -}}
{{ if or (eq .Values.global.connectivity.vpcMode "private") (.Values.global.connectivity.certManager.useDnsChallenges) }}
{{- print "true" }}
{{- else }}
{{- print "false" }}
{{- end }}
{{- end }}
