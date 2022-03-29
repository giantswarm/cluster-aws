{{- define "clusterresourceset" }}
---
apiVersion: addons.cluster.x-k8s.io/v1beta1
kind: ClusterResourceSet
metadata:
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels.common" $ | nindent 4 }}
spec:
  clusterSelector:
    matchLabels:
      {{- include "labels.common" $ | nindent 6 }}
  resources:
  - kind: ConfigMap
    name: {{ include "resource.default.name" $ }}-psps
  - kind: ConfigMap
    name: {{ include "resource.default.name" $ }}-coredns
{{- end -}}
