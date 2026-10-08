{{/*
Constructs the AWS OIDC domain without the https:// prefix.
For Chinese regions: s3.{region}.amazonaws.com.cn/{account}-g8s-{cluster}-oidc-pod-identity-v3
For other regions:   irsa.{cluster}.{baseDomain}
*/}}
{{- define "aws-oidc-domain" -}}
{{- if hasPrefix "cn-" (include "aws-region" .) -}}
s3.{{ include "aws-region" . }}.amazonaws.com.cn/{{ include "aws-account-id" . }}-g8s-{{ include "resource.default.name" $ }}-oidc-pod-identity-v3
{{- else -}}
irsa.{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}
{{- end -}}
{{- end -}}
