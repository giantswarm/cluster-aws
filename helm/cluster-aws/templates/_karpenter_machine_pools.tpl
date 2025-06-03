{{- define "karpenter-machine-pools" }}
{{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- if eq $value.type "karpenter" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha1
kind: KarpenterMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
spec:
  iamInstanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }}
---
{{ end }}
{{ end }}
{{- end -}}
