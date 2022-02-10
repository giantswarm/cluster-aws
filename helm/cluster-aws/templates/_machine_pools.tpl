{{- define "machine-pools" }}
{{ range .Values.machinePools }}
apiVersion: exp.cluster.x-k8s.io/v1alpha3
kind: MachinePool
metadata:
  annotations:
    machine-pool.giantswarm.io/name: {{ .name }}
  labels:
    giantswarm.io/machine-pool: {{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .minSize }}
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1alpha3
          kind: KubeadmConfig
          name: {{ .name }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1alpha3
        kind: AWSMachinePool
        name: {{ .name }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha3
kind: AWSMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  availabilityZones: {{ .availabilityZones }}
  awsLaunchTemplate:
    ami: {}
    iamInstanceProfile: nodes-{{ .name }}-{{ include "resource.default.name" $ }}
    instanceType: {{ .instanceType }}
    rootVolume:
      size: {{ .rootVolumeSizeGB }}
      type: gp3
    sshKeyName: ""
  maxSize: {{ .minSize }}
  minSize: {{ .maxSize }}
  mixedInstancesPolicy:
    instancesDistribution:
      onDemandAllocationStrategy: prioritized
      onDemandBaseCapacity: 0
      onDemandPercentageAboveBaseCapacity: 100
      spotAllocationStrategy: lowest-price
---
apiVersion: bootstrap.cluster.x-k8s.io/v1alpha3
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  files:
    joinConfiguration:
    discovery: {}
    nodeRegistration:
      kubeletExtraArgs:
        cloud-provider: aws
        healthz-bind-address: 0.0.0.0
        image-pull-progress-deadline: 1m
        node-ip: '{{ `{{ ds.meta_data.local_ipv4 }}` }}'
        node-labels: role=worker,giantswarm.io/machine-pool={{ .name }},{{- join "," .customNodeLabels }}
        v: "2"
      name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
  postKubeadmCommands:
  {{- include "sshPostKubeadmCommands" . | nindent 4 }}
  users:
  {{- include "sshUsers" . | nindent 4 }}
---
{{ end }}
{{- end -}}
