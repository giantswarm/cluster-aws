{{/*
AWSMachineTemplates .Spec are immutable and cannot change.
This function is used for both the `.Spec` value and as the data for the hash function.
Any changes to this will trigger the resource to be recreated rather than attempting to update in-place.
*/}}
{{- define "controlplane-awsmachinetemplate-spec" -}}
{{- with (.Values.global.providerSpecific.controlPlaneAmi | default .Values.global.providerSpecific.ami) }}
ami:
  id: {{ . | quote }}
{{- else }}
{{- include "imageLookupParameters" $ }}
{{- end }}
cloudInit: {}
instanceType: {{ .Values.global.controlPlane.instanceType }}
nonRootVolumes:
- deviceName: /dev/xvdc
  encrypted: true
  size: {{ .Values.global.controlPlane.etcdVolumeSizeGB }}
  type: gp3
- deviceName: /dev/xvdd
  encrypted: true
  size: {{ .Values.global.controlPlane.libVolumeSizeGB }}
  type: gp3
- deviceName: /dev/xvde
  encrypted: true
  size: {{ .Values.global.controlPlane.logVolumeSizeGB }}
  type: gp3
rootVolume:
  size: {{ .Values.global.controlPlane.rootVolumeSizeGB }}
  type: gp3
iamInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
{{- if .Values.global.controlPlane.additionalSecurityGroups }}
additionalSecurityGroups:
{{- toYaml .Values.global.controlPlane.additionalSecurityGroups | nindent 2 }}
{{- end }}
instanceMetadataOptions:
  httpPutResponseHopLimit: 3
  httpTokens: {{ .Values.global.providerSpecific.instanceMetadataOptions.httpTokens | quote }}
sshKeyName: ""
subnet:
  filters:
    - name: tag:kubernetes.io/cluster/{{ include "resource.default.name" $ }}
      values:
      - shared
      - owned
    {{ if eq $.Values.global.connectivity.vpcMode "public" }}
    - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
      values:
      - private
    {{end}}
    {{- range $i, $tags :=  .Values.global.controlPlane.subnetTags }}
    - name: tag:{{ keys $tags | first }}
      values:
      - {{ index $tags (keys $tags | first) | quote }}
    {{- end }}
{{- end }}

{{- define "service-account-issuers-comma-separated" }}
{{- range $serviceAccountIssuerIndex, $serviceAccountIssuer := .Values.cluster.providerIntegration.controlPlane.kubeadmConfig.clusterConfiguration.apiServer.serviceAccountIssuers }}
{{- if gt $serviceAccountIssuerIndex 0 }},{{- end -}}
{{ regexReplaceAll "^(http://|https://)" (include "cluster.internal.controlPlane.kubeadm.clusterConfiguration.apiServer.serviceAccountIssuer" (dict "Values" $.Values "Release" $.Release "serviceAccountIssuer" $serviceAccountIssuer)) "" }}
{{- end -}}
{{- end -}}

{{- define "control-plane" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-awsmachinetemplate-spec" $) "global" .) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: control-plane
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- include "controlplane-awsmachinetemplate-spec" $ | nindent 6 }}
{{- end -}}
