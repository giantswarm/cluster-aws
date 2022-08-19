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
  - blocker
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
        name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" .Values.bastion "global" .) }}
      version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion-{{ include "hash" (dict "data" .Values.bastion "global" .) }}
  namespace: {{ .Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      instanceType: {{ .Values.bastion.instanceType }}
      additionalSecurityGroups:
      - filters:
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
          values:
          - bastion
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}
          values:
          - owned
      cloudInit:
        insecureSkipSecretsManager: true
      imageLookupFormat: Flatcar-stable-*
      imageLookupOrg: "{{ .Values.flatcarAWSAccount }}"
      publicIP: true
      sshKeyName: ""
      subnet:
        filters:
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
          values:
          - public
      uncompressedUserData: true
{{- end -}}
