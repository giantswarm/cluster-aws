{{- define "karpenter-machine-pools" }}
{{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- if eq $value.nodepoolType "karpenter" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha1
kind: KarpenterMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ $name }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ $.Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-{{ $name }}
  namespace: {{ $.Release.Namespace }}
  iamInstanceProfile: nodes-{{ $name }}-{{ include "resource.default.name" $ }} 
spec:
  clusterName: {{ include "resource.default.name" $ }}
  # TODO: Version lo tenemos en machinepool, lo necesitamos aqui tambien?
  version: v1.29.13
---
{{ end }}
{{ end }}
{{- end -}}
