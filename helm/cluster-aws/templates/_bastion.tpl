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
    instanceType: {{ .Values.bastion.instanceType }}
    cloudInit:
      insecureSkipSecretsManager: true
    imageLookupFormat: Flatcar-stable-*
    imageLookupOrg: "{{ .Values.flatcarAWSAccount }}"
    publicIP: {{ if eq .Values.network.vpcMode "private" }}false{{else}}true{{end}}
    sshKeyName: ""
    uncompressedUserData: true
    subnet:
      filters:
        - name: tag:{{ if eq .Values.network.vpcMode "private" }}github.com/giantswarm/aws-vpc-operator/role{{else}}sigs.k8s.io/cluster-api-provider-aws/role{{end}}
          values:
          - {{ if eq .Values.network.vpcMode "private" }}private{{else}}public{{end}}
        - name: tag:{{ if eq .Values.network.vpcMode "private" }}github.com/giantswarm/aws-vpc-operator/{{else}}sigs.k8s.io/cluster-api-provider-aws/cluster/{{end}}{{ include "resource.default.name" $ }}
          values:
          - owned
          - shared
        {{- range $i, $tags :=  .Values.bastion.subnetTags }}
        - name: tag:{{ keys $tags | first }}
          values:
          - {{ index $tags (keys $tags | first) }}
        {{- end }}
{{- end }}

{{- define "bastion" }}
apiVersion: v1
kind: Secret
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion-ignition
  namespace: {{ .Release.Namespace }}
  finalizers:
  - bastion.finalizers.giantswarm.io/secret-blocker
type: cluster.x-k8s.io/secret
data:
  value: {{ include "bastionIgnition" . }}
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .Values.bastion.replicas }}
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
        cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
        cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        dataSecretName: {{ include "resource.default.name" $ }}-bastion-ignition
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachineTemplate
        name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
      version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
  namespace: {{ .Release.Namespace }}
spec: {{ include "bastion-awsmachinetemplate-spec" $ | nindent 2 }}
{{- end -}}
