{{- define "machine-pools" }}
{{- range $name, $value := .Values.nodePools | default .Values.internal.nodePools }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    "helm.sh/resource-policy": keep
    machine-pool.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ $name }}
    cluster.x-k8s.io/replicas-managed-by: "external-autoscaler"
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
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
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachinePool
metadata:
  annotations:
    "helm.sh/resource-policy": keep
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  additionalTags:
    k8s.io/cluster-autoscaler/enabled: "true"
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
    instanceType: {{ $value.instanceType | default "r6i.xlarge" }}
    rootVolume:
      size: {{ $value.rootVolumeSizeGB | default 300 }}
      type: gp3
    sshKeyName: ""
    {{- if $value.additionalSecurityGroups }}
    additionalSecurityGroups:
    {{- toYaml $value.additionalSecurityGroups | nindent 4 }}
    {{- end }}
    {{- if and $value.spotInstances $value.spotInstances.enabled }}
    spotMarketOptions:
      maxPrice: {{ $value.spotInstances.maxPrice | quote }}
    {{- end }}
  minSize: {{ $value.minSize | default 1 }}
  maxSize: {{ $value.maxSize | default 3 }}
  {{- if or (not $value.spotInstances) (not $value.spotInstances.enabled) }}
  mixedInstancesPolicy:
    instancesDistribution:
      onDemandAllocationStrategy: prioritized
      onDemandBaseCapacity: 0
      onDemandPercentageAboveBaseCapacity: 100
      spotAllocationStrategy: lowest-price
  {{- end }}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  format: ignition
  ignition:
    containerLinuxConfig:
      additionalConfig: |
        systemd:
          units:
          {{- include "flatcarSystemdUnits" $ | nindent 12 }}
          {{- if $.Values.internal.teleport.enabled }}
          {{- include "teleportSystemdUnits" $ | nindent 12 }}
          {{- end }}
        storage:
          directories:
          {{- include "nodeDirectories" $ | nindent 12 }}
  joinConfiguration:
    discovery: {}
    nodeRegistration:
      kubeletExtraArgs:
        cloud-provider: external
        {{- if $.Values.providerSpecific.cgroupv1 }}
        cgroup-driver: cgroupfs
        {{- end }}
        feature-gates: CronJobTimeZone=true
        healthz-bind-address: 0.0.0.0
        node-ip: ${COREOS_EC2_IPV4_LOCAL}
        node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ $name }},{{- join "," $value.customNodeLabels }}
        v: "2"
      name: ${COREOS_EC2_HOSTNAME}
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
    {{- include "flatcarKubeadmPreCommands" . | nindent 4 }}
    {{- include "sshPreKubeadmCommands" . | nindent 4 }}
    {{- if $.Values.connectivity.proxy.enabled }}{{- include "proxyCommand" $ | nindent 4 }}{{- end }}
  postKubeadmCommands:
    {{- include "kubeletConfigPostKubeadmCommands" . | nindent 4 }}
  users:
  {{- include "sshUsers" . | nindent 2 }}
  files:
  {{- include "sshFiles" $ | nindent 2 }}
  {{- include "kubeletConfigFiles" $ | nindent 2 }}
  {{- if $.Values.connectivity.proxy.enabled }}{{- include "proxyFiles" $ | nindent 2 }}{{- end }}
  {{- include "containerdConfigFiles" $ | nindent 2 }}
  {{- if $.Values.internal.teleport.enabled }}
  {{- include "teleportFiles" $ | nindent 2 }}
  {{- end }}
  {{- if $.Values.providerSpecific.cgroupv1 }}
  {{- include "cgroupv1Files" $ | nindent 2 }}
  {{- end }}
  {{- include "nodeConfigFiles" $ | nindent 2 }}
---
{{ end }}
{{- end -}}
