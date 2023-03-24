{{- define "machine-pools" }}
{{- range $name, $value := .Values.nodePools | default .Values.defaultMachinePools }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    machine-pool.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ $name }}
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
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
          name: {{ include "resource.default.name" $ }}-{{ $name }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachinePool
        name: {{ include "resource.default.name" $ }}-{{ $name }}
      version: {{ $.Values.internal.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  availabilityZones: {{ include "aws-availability-zones" $value | nindent 2 }}
  subnets:
  - filters:
    - name: tag:kubernetes.io/cluster/{{ include "resource.default.name" $ }}
      values:
      - shared
      - owned
    {{ if eq $.Values.connectivity.vpcMode "public" }}
    - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
      values:
      - private
    {{end}}
    {{- range $i, $tags := .subnetTags }}
    - name: tag:{{ keys $tags | first }}
      values:
      - {{ index $tags (keys $tags | first) | quote }}
    {{- end }}
  awsLaunchTemplate:
    {{- include "ami" $ | nindent 4 }}
    iamInstanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }}
    instanceType: {{ $value.instanceType | default "m5.xlarge" }}
    rootVolume:
      size: {{ $value.rootVolumeSizeGB | default 300 }}
      type: gp3
    sshKeyName: ""
  minSize: {{ $value.minSize | default 1 }}
  maxSize: {{ $value.maxSize | default 3 }}
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
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
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
        node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ $name }},{{- join "," $value.customNodeLabels }}
        v: "2"
      name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
      {{- if $value.customNodeTaints }}
      {{- if (gt (len $value.customNodeTaints) 0) }}
      taints:
      {{- range $value.customNodeTaints }}
      - key: {{ .key | quote }}
        value: {{ .value | quote }}
        effect: {{ .effect | quote }}
      {{- end }}
      {{- end }}
      {{- end }}
  preKubeadmCommands:
    {{- include "prepare-varLibKubelet-Dir" . | nindent 4 }}
    {{- include "sshPreKubeadmCommands" . | nindent 4 }}
    {{- if $.Values.connectivity.proxy.enabled }}{{- include "proxyCommand" $ | nindent 4 }}{{- end }}
  postKubeadmCommands:
    {{- include "awsNtpPostKubeadmCommands" . | nindent 4 }}
  users:
  {{- include "sshUsers" . | nindent 2 }}
  files:
  {{- include "sshFiles" $ | nindent 2 }}
  {{- if $.Values.connectivity.proxy.enabled }}{{- include "proxyFiles" $ | nindent 2 }}{{- end }}
  {{- include "registryFiles" $ | nindent 2 }}
  {{- include "awsNtpFiles" $ | nindent 2 }}
---
{{ end }}
{{- end -}}
