{{- define "machine-pools" }}
{{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachinePool
metadata:
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
    - name: availability-zone
      values:
      {{- include "aws-availability-zones" $value | nindent 6 }}
    {{ if eq $.Values.global.connectivity.vpcMode "public" }}
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
    {{- if and ($value.instanceTypeOverrides) (gt (len $value.instanceTypeOverrides) 0) }}
    overrides:
    {{- range $instanceType := $value.instanceTypeOverrides }}
    - instanceType: {{ $instanceType }}
    {{- end }}
    {{- end }}
  {{- end }}
  refreshPreferences:
    instanceWarmup: 300
---
{{ end }}
{{- end -}}
