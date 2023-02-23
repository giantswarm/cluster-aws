{{- define "machine-health-check" }}
{{- if .Values.machineHealthCheck.enabled }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: {{ include "resource.default.name" . }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  maxUnhealthy: {{ .Values.machineHealthCheck.maxUnhealthy }}
  nodeStartupTimeout: {{ .Values.machineHealthCheck.nodeStartupTimeout }}
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
  unhealthyConditions:
  - type: Ready
    status: Unknown
    timeout: {{ .Values.machineHealthCheck.unhealthyUnknownTimeout }}
  - type: Ready
    status: "False"
    timeout: {{ .Values.machineHealthCheck.unhealthyNotReadyTimeout }}
{{- end -}}
{{- end -}}
