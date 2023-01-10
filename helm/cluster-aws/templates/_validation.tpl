{{- define "validation" }}
{{/*
No rendered templates live in here.
Instead this is used to perform some validation checks on values that dont make sense elsewhere.
*/}}

{{/* Ensure that vpcMode and apiMode values are compatible with each other */}}
{{ if and (eq .Values.network.vpcMode "private") (eq .Values.network.apiMode "public") }}
{{- fail "`.Values.network.apiMode` cannot be 'public' if `.Values.network.vpcMode` is set to 'private'" }}
{{ end }}

{{- range $i, $subnet := .Values.network.subnets }}
{{ if neq (len $subnet.cidrBlocks) .Values.network.availabilityZoneUsageLimit }}
{{- fail "`cidrBlocks` must contain the same number of entries as specified by `.network.availabilityZoneUsageLimit`" }}
{{ end }}
{{- end }}


{{- end -}}
