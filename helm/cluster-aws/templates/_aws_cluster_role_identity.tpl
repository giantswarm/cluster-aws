{{- define "aws-cluster-role-identity" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha3
kind: AWSClusterRoleIdentity
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
spec:
  allowedNamespaces:
    list:
    - {{ $.Release.Namespace }}
    selector: {}
  roleARN: "{{ .Values.aws.roleARN }}"
{{- end -}}
