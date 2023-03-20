{{- define "validation" }}
{{/*
No rendered templates live in here.
Instead this is used to perform some validation checks on values that dont make sense elsewhere.
*/}}

{{/* Ensure that vpcMode and apiMode values are compatible with each other */}}
{{ if and (eq .Values.network.vpcMode "private") (eq .Values.controlPlane.apiMode "public") }}
{{- fail "`.Values.controlPlane.apiMode` cannot be 'public' if `.Values.network.vpcMode` is set to 'private'" }}
{{ end }}

{{- end -}}
