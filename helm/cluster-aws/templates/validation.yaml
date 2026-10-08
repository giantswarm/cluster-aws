{{- define "validation" }}
{{/*
No rendered templates live in here.
Instead this is used to perform some validation checks on values that dont make sense elsewhere.
*/}}

{{/* Ensure that vpcMode and apiMode values are compatible with each other */}}
{{ if and (eq .Values.global.connectivity.vpcMode "private") (eq .Values.global.controlPlane.apiMode "public") }}
{{- fail "`.Values.global.controlPlane.apiMode` cannot be 'public' if `.Values.global.connectivity.vpcMode` is set to 'private'" }}
{{ end }}

{{/* Ensure that delegationIdentityName is set when hostedZoneName is specified */}}
{{ if and .Values.global.connectivity.dns.hostedZoneName (not .Values.global.connectivity.dns.delegationIdentityName) }}
{{- fail "`.Values.global.connectivity.dns.delegationIdentityName` is required when `.Values.global.connectivity.dns.hostedZoneName` is set" }}
{{ end }}

{{/* Ensure that hostedZoneName is a subdomain of baseDomain */}}
{{ if and .Values.global.connectivity.dns.hostedZoneName (ne .Values.global.connectivity.dns.hostedZoneName .Values.global.connectivity.baseDomain) (not (hasSuffix (printf ".%s" .Values.global.connectivity.baseDomain) .Values.global.connectivity.dns.hostedZoneName)) }}
{{- fail (printf "`.Values.global.connectivity.dns.hostedZoneName` (%s) must be a subdomain of `.Values.global.connectivity.baseDomain` (%s)" .Values.global.connectivity.dns.hostedZoneName .Values.global.connectivity.baseDomain) }}
{{ end }}

{{- end -}}
