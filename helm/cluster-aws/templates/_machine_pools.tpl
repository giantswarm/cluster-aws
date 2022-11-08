{{- define "machine-pools" }}
{{ range .Values.machinePools }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    machine-pool.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ .name }}
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .minSize }}
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfig
          name: {{ include "resource.default.name" $ }}-{{ .name }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachinePool
        name: {{ include "resource.default.name" $ }}-{{ .name }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  availabilityZones: {{ include "aws-availability-zones" . | nindent 2 }}
  subnets:
  - filters:
    - name: tag:sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}
      values:
      - owned
    - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
      values:
      - private
    - name: availabilityZone
      values: {{ include "aws-availability-zones" . | nindent 6 }}
  awsLaunchTemplate:
    {{- include "ami" $ | nindent 4 }}
    iamInstanceProfile: nodes-{{ .name }}-{{ include "resource.default.name" $ }}
    instanceType: {{ .instanceType }}
    rootVolume:
      size: {{ .rootVolumeSizeGB }}
      type: gp3
    sshKeyName: ""
  minSize: {{ .minSize }}
  maxSize: {{ .maxSize }}
  mixedInstancesPolicy:
    instancesDistribution:
      onDemandAllocationStrategy: prioritized
      onDemandBaseCapacity: 0
      onDemandPercentageAboveBaseCapacity: 100
      spotAllocationStrategy: lowest-price
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  joinConfiguration:
    discovery: {}
    nodeRegistration:
      kubeletExtraArgs:
        cloud-provider: aws
        healthz-bind-address: 0.0.0.0
        image-pull-progress-deadline: 1m
        node-ip: '{{ `{{ ds.meta_data.local_ipv4 }}` }}'
        node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ .name }},{{- join "," .customNodeLabels }}
        v: "2"
      name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
  preKubeadmCommands:
    {{- include "sshPreKubeadmCommands" . | nindent 4 }}
    {{- if $.Values.proxy.enabled }}{{- include "proxyCommand" $ | nindent 4 }}{{- end }}
  users:
  {{- include "sshUsers" . | nindent 2 }}
  files:
  {{- include "sshFiles" $ | nindent 2 }}
  {{- if $.Values.proxy.enabled }}{{- include "proxyFiles" $ | nindent 2 }}{{- end }}
---
{{ end }}
{{- end -}}
