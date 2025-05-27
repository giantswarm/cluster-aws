{{- define "machine-pools" }}
{{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- if or (not $value.type) (eq $value.type "machinepool") }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    {{- if (required "global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers is required" $.Values.global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers) }}
    alpha.aws.giantswarm.io/reduced-instance-permissions-workers: "true"
    {{- end }}
    {{- if eq (required "global.connectivity.cilium.ipamMode is required" $.Values.global.connectivity.cilium.ipamMode) "eni" }}
    alpha.aws.giantswarm.io/ipam-mode: "eni"
    {{- end }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  additionalTags:
    k8s.io/cluster-autoscaler/enabled: "true"
    giantswarm.io/machinepool: {{ $name }}
    {{- if $.Values.global.providerSpecific.additionalNodeTags }}
    {{- toYaml $.Values.global.providerSpecific.additionalNodeTags | nindent 4 }}
    {{- end}}
  availabilityZones: {{ include "aws-availability-zones" (dict "mp" $value "Values" $.Values "Files" $.Files) | nindent 2 }}
  subnets:
  - filters:
    - name: tag:kubernetes.io/cluster/{{ include "resource.default.name" $ }}
      values:
      - shared
      - owned
    - name: availability-zone
      values:
      {{- include "aws-availability-zones" (dict "mp" $value "Values" $.Values "Files" $.Files) | nindent 6 }}
    {{- if eq $.Values.global.connectivity.vpcMode "public" }}
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
    {{- with ($.Values.global.providerSpecific.nodePoolAmi | default $.Values.global.providerSpecific.ami) }}
    ami:
      id: {{ . | quote }}
    {{- else }}
    {{- include "imageLookupParameters" $ | nindent 4 }}
    {{- end }}
    iamInstanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }}
    instanceType: {{ $value.instanceType | default "r6i.xlarge" }}
    rootVolume:
      size: {{ $value.rootVolumeSizeGB | default 8 }}
      type: gp3
    nonRootVolumes:
    - deviceName: /dev/xvdd
      encrypted: true
      size: {{ $value.libVolumeSizeGB | default 120 }}
      type: gp3
    - deviceName: /dev/xvde
      encrypted: true
      size: {{ $value.logVolumeSizeGB | default 30}}
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
    instanceMetadataOptions:
      httpPutResponseHopLimit: 3
      httpTokens: {{ $.Values.global.providerSpecific.instanceMetadataOptions.httpTokens | quote }}
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
    instanceWarmup: {{ $value.instanceWarmup | default 600 }}
    minHealthyPercentage: {{ $value.minHealthyPercentage | default 90 }}
    maxHealthyPercentage: {{ $value.maxHealthyPercentage }}
  ignition:
    storageType: ClusterObjectStore # store user data in S3 bucket
    version: "3.4"
  {{- if $.Values.global.providerSpecific.nodeTerminationHandlerEnabled }}
  lifecycleHooks:
  - defaultResult: CONTINUE

    {{/*
        The default is a high enough heartbeat timeout because aws-node-termination-handler (shortened to "NTH" here)
        doesn't send heartbeats (https://github.com/aws/aws-node-termination-handler/issues/493),
        but low enough so that if the controller is down, instances can still terminate within
        a reasonable time.
    */}}
    heartbeatTimeout: "{{ ($value.awsNodeTerminationHandler).heartbeatTimeoutSeconds | default 1800 }}s"

    lifecycleTransition: autoscaling:EC2_INSTANCE_TERMINATING
    name: aws-node-termination-handler
    notificationTargetARN: arn:{{ include "aws-partition" $}}:sqs:{{ include "aws-region" $ }}:{{ include "aws-account-id" $}}:{{ include "resource.default.name" $ }}-nth
    roleARN: arn:{{ include "aws-partition" $}}:iam::{{ include "aws-account-id" $}}:role/{{ include "resource.default.name" $ }}-nth-notification
  {{- end }}
---
{{- end }}
{{ end }}
{{- end -}}
