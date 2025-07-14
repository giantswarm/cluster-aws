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
  iamInstanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }}
  ec2NodeClass:
    amiName: flatcar-stable-{{ include "cluster.os.version" $ }}-kube-{{ include "cluster.component.kubernetes.version" $ }}-tooling-{{ include "cluster.os.tooling.version" $ }}-gs
    amiOwner: {{ if hasPrefix "cn-" (include "aws-region" $) }}306934455918{{else}}706635527432{{end}}
    securityGroups:
      sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}: owned
      sigs.k8s.io/cluster-api-provider-aws/role: node
    subnets:
      sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}: owned
      giantswarm.io/role: nodes
  nodePool:
    limits:
      {{- if $value.limits }}
      cpu: {{ $value.limits.cpu | default "1000" }}
      memory: {{ $value.limits.memory | default "1000Gi" }}
      {{- else }}
      cpu: "1000"
      memory: "1000Gi"
      {{- end }}
    template:
      metadata:
        labels:
          giantswarm.io/machine-pool: {{ $.Values.clusterName }}-{{ $name }}
      spec:
        expireAfter: {{ $value.expireAfter | default "720h" }}
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
          - 4
          - 8
          - 16
          - 32
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
        - effect: NoExecute
          key: node.cluster.x-k8s.io/uninitialized
          value: "true"
---
{{ end }}
{{ end }}
{{- end -}}
