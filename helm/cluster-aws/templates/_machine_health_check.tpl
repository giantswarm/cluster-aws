{{- define "machine-health-check" }}
{{- if .Values.controlPlane.machineHealthCheck.enabled }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" . }}-control-plane
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  maxUnhealthy: {{ .Values.controlPlane.machineHealthCheck.maxUnhealthy }}
  nodeStartupTimeout: {{ .Values.controlPlane.machineHealthCheck.nodeStartupTimeout }}
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
      cluster.x-k8s.io/control-plane: ""
  unhealthyConditions:
  - type: Ready
    status: Unknown
    timeout: {{ .Values.controlPlane.machineHealthCheck.unhealthyUnknownTimeout }}
  - type: Ready
    status: "False"
    timeout: {{ .Values.controlPlane.machineHealthCheck.unhealthyNotReadyTimeout }}
{{- end -}}
{{- end -}}
