{{- /*
Extracts the AWS account ID from an ARN string.
Example usage: {{ include "extractAWSAccountID" "arn:aws:iam::1234567890:role/example-role" }}

Input: An ARN string
Output: The AWS account ID
*/ -}}
{{- define "extractAWSAccountID" -}}
{{- $parts := (split ":" .)  -}}
{{- if ge (len $parts) 5 -}}{{- $parts._4 -}}{{- end -}}
{{- end -}}

{{- define "aws-account-id" -}}
{{- $roleName:= .Values.global.providerSpecific.awsClusterRoleIdentityName -}}
{{- $accountID := .Values.global.providerSpecific.awsAccountId -}}
{{- $role :=  (lookup "infrastructure.cluster.x-k8s.io/v1beta2" "AWSClusterRoleIdentity" "" $roleName ) -}}
{{- if $role -}}
{{- $accountID = (include "extractAWSAccountID" $role.spec.roleARN) -}}
{{- end -}}
{{- if eq $accountID "" -}}
{{- fail "failed to extract AWS Account ID from AWSClusterRoleIdentity" -}}
{{- else -}}
{{- $accountID -}}
{{- end -}}
{{- end -}}
