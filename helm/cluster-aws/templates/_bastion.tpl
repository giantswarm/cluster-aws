{{/*
AWSMachineTemplates .Spec are immutable and cannot change.
This function is used for both the `.Spec` value and as the data for the hash function.
Any changes to this will trigger the resource to be recreated rather than attempting to update in-place.
*/}}
{{- define "bastion-awsmachinetemplate-spec" -}}
template:
  metadata:
    labels:
      cluster.x-k8s.io/role: bastion
      {{- include "labels.common" $ | nindent 6 }}
  spec:
    instanceType: {{ .Values.connectivity.bastion.instanceType }}
    cloudInit: {}
    imageLookupBaseOS: flatcar-stable
    imageLookupFormat: {{ "capa-ami-{{.BaseOS}}-v{{.K8sVersion}}-gs" }}
    imageLookupOrg: "{{ .Values.providerSpecific.flatcarAwsAccount }}"
    iamInstanceProfile: {{ include "resource.default.name" $ }}-bastion
    publicIP: {{ if eq .Values.connectivity.vpcMode "private" }}false{{else}}true{{end}}
    sshKeyName: ""
    subnet:
      filters:
        - name: tag:{{ if eq .Values.connectivity.vpcMode "private" }}github.com/giantswarm/aws-vpc-operator/role{{else}}sigs.k8s.io/cluster-api-provider-aws/role{{end}}
          values:
          - {{ if eq .Values.connectivity.vpcMode "private" }}private{{else}}public{{end}}
        - name: tag:{{ if eq .Values.connectivity.vpcMode "private" }}github.com/giantswarm/aws-vpc-operator/{{else}}sigs.k8s.io/cluster-api-provider-aws/cluster/{{end}}{{ include "resource.default.name" $ }}
          values:
          - owned
          - shared
        {{- range $i, $tags :=  .Values.connectivity.bastion.subnetTags }}
        - name: tag:{{ keys $tags | first }}
          values:
          - {{ index $tags (keys $tags | first) | quote }}
        {{- end }}
{{- end }}

{{- define "bastion-kubeadmconfigtemplate-spec" -}}
format: ignition
ignition:
  containerLinuxConfig:
    additionalConfig: |
      systemd:
        units:
        {{- include "flatcarSystemdUnits" $ | nindent 8 }}
preKubeadmCommands:
{{ include "flatcarKubeadmPreCommands" $  }}
- systemctl restart sshd
- sleep infinity
files:
{{ include "sshFilesBastion" $ }}
users:
{{ include "sshUsers" . }}
{{- end }}

{{- define "bastion" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  annotations:
    "helm.sh/resource-policy": keep
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .Values.connectivity.bastion.replicas }}
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
      cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-kubeadmconfigtemplate-spec" $ ) "global" $) }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachineTemplate
        name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
      version: {{ .Values.internal.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
  namespace: {{ .Release.Namespace }}
spec: {{ include "bastion-awsmachinetemplate-spec" $ | nindent 2 }}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-kubeadmconfigtemplate-spec" $ ) "global" $) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec: {{ include "bastion-kubeadmconfigtemplate-spec" $ | nindent 6 }}
{{- end -}}
