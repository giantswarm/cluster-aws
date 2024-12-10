{{- /*
Extracts the AWS partition from an ARN string.
Example usage: {{ include "extractAWSPartition" "arn:aws:iam::1234567890:role/example-role" }}

Input: An ARN string
Output: The AWS partition (e.g., "aws", "aws-cn")
*/ -}}
{{- define "extractAWSPartition" -}}
{{- $parts := (split ":" .) -}}
{{- if ge (len $parts) 5 -}}{{- $parts._1 -}}{{- end -}}
{{- end -}}

{{- define "aws-partition" -}}
{{- $roleName := .Values.global.providerSpecific.awsClusterRoleIdentityName -}}
{{- $partition := .Values.internal.awsPartition -}}
{{- $role := (lookup "infrastructure.cluster.x-k8s.io/v1beta2" "AWSClusterRoleIdentity" "" $roleName) -}}
{{- if $role -}}
{{- $partition = (include "extractAWSPartition" $role.spec.roleARN) -}}
{{- end -}}
{{- if eq $partition "" -}}
{{- fail "failed to extract AWS Partition from AWSClusterRoleIdentity" -}}
{{- else -}}
{{- $partition -}}
{{- end -}}
{{- end -}}
