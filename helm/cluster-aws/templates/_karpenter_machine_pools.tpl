{{- define "karpenter-machine-pools" }}
{{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- if eq $value.type "karpenter" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha1
kind: KarpenterMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    {{- if (required "global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers is required" $.Values.global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers) }}
    alpha.aws.giantswarm.io/reduced-instance-permissions-workers: "true"
    {{- end }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  ec2NodeClass:
    amiSelectorTerms:
      - name: flatcar-stable-{{ include "cluster.os.version" $ }}-kube-{{ include "cluster.component.kubernetes.version" $ }}-tooling-{{ include "cluster.os.tooling.version" $ }}-gs
        owner: {{ if hasPrefix "cn-" (include "aws-region" $) }}"306934455918"{{else}}"706635527432"{{end}}
    blockDeviceMappings:
    - deviceName: /dev/xvda
      rootVolume: true
      ebs:
        volumeSize: {{ $value.rootVolumeSizeGB | default 8 }}Gi
        volumeType: gp3
        deleteOnTermination: true
    - deviceName: /dev/xvdd
      ebs:
        encrypted: true
        volumeSize: {{ $value.libVolumeSizeGB | default 120 }}Gi
        volumeType: gp3
        deleteOnTermination: true
    - deviceName: /dev/xvde
      ebs:
        encrypted: true
        volumeSize: {{ $value.logVolumeSizeGB | default 30}}Gi
        volumeType: gp3
        deleteOnTermination: true
    instanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }}
    metadataOptions:
      {{- if eq (required "global.connectivity.cilium.ipamMode is required" $.Values.global.connectivity.cilium.ipamMode) "eni" }}
      httpPutResponseHopLimit: 2
      {{- else }}
      httpPutResponseHopLimit: 3
      {{- end }}
      httpTokens: {{ $.Values.global.providerSpecific.instanceMetadataOptions.httpTokens | quote }}
    securityGroupSelectorTerms:
    - tags:
        sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}: owned
        sigs.k8s.io/cluster-api-provider-aws/role: node
    {{- if $value.additionalSecurityGroups }}
    {{- range $value.additionalSecurityGroups }}
    - id: {{ .id | quote }}
    {{- end }}
    {{- end }}
    subnetSelectorTerms:
    - tags:
        sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}: owned
        giantswarm.io/role: "nodes"
        {{- if $value.subnetTags }}
        {{- range $value.subnetTags }}
        {{- range $key, $val := . }}
        {{ $key | quote }}: {{ $val | quote }}
        {{- end }}
        {{- end }}
        {{- end }}
  nodePool:
    disruption:
      consolidateAfter: {{ $value.consolidateAfter | default "3m" }}
      {{- with $value.consolidationPolicy }}
      consolidationPolicy: {{ . }}
      {{- end }}
      {{- with $value.consolidationBudgets }}
      budgets:
      {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- $limits := default (dict "cpu" "1000" "memory" "1000Gi") $value.limits }}
    limits:
      cpu: {{ $limits.cpu }}
      memory: {{ $limits.memory }}
    template:
      metadata:
        labels:
          giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
          {{- with $value.customNodeLabels }}
          {{- range . }}
          {{- $parts := splitList "=" . }}
          {{- if eq (len $parts) 2 }}
          {{ index $parts 0 | quote }}: {{ index $parts 1 | quote }}
          {{- end }}
          {{- end }}
          {{- end }}
      spec:
        {{- with $value.expireAfter }}
        expireAfter: {{ . }}
        {{- end }}
        requirements:
        {{- range $value.requirements }}
        - key: {{ .key }}
          operator: {{ .operator }}
          values:
            {{- range .values }}
            - "{{ . }}"
            {{- end }}
        {{- else }}
        - key: karpenter.k8s.aws/instance-family
          operator: NotIn
          values:
          - t3
          - t3a
          - t2
        - key: karpenter.sh/capacity-type
          operator: In
          values:
          - spot
          - on-demand
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values:
          - "4"
          - "8"
          - "16"
          - "32"
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values:
          - nitro
        - key: kubernetes.io/arch
          operator: In
          values:
          - amd64
        - key: kubernetes.io/os
          operator: In
          values:
          - linux
        {{- end }}
        startupTaints:
        - effect: NoExecute
          key: node.cilium.io/agent-not-ready
          value: "true"
        {{- with $value.customNodeTaints }}
        taints:
        {{- range . }}
        - key: {{ .key | quote }}
          effect: {{ .effect | quote }}
          {{- if .value }}
          value: {{ .value | quote }}
          {{- end }}
        {{- end }}
        {{- end }}
---
{{ end }}
{{ end }}
{{- end -}}
