{{- /*
Renders the Amazon ECR statements of the control plane and worker node IAM role policies.

Read permissions are restricted to the repositories listed in `global.providerSpecific.iam.ecr.allowedRepositories`,
or to all repositories if that is empty.
*/ -}}
{{- define "cluster-aws.ecrRolePolicyStatements" -}}
{{- $ecr := .Values.global.providerSpecific.iam.ecr -}}
{{- if $ecr.permissionsEnabled -}}
{{- $resources := list -}}
{{- if $ecr.allowedRepositories -}}
{{- range $repository := (keys $ecr.allowedRepositories | sortAlpha) -}}
{{- if (get $ecr.allowedRepositories $repository).enabled -}}
{{- if hasPrefix "arn:" $repository -}}
{{- $resources = append $resources $repository -}}
{{- else -}}
{{- $resources = append $resources (printf "arn:%s:ecr:%s:%s:repository/%s" (include "aws-partition" $) (include "aws-region" $) (include "aws-account-id" $) $repository) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- else -}}
{{- $resources = list "*" -}}
{{- end -}}
{{- if $resources }},
          {
            "Action": [
              "ecr:GetAuthorizationToken"
            ],
            "Resource": "*",
            "Effect": "Allow"
          },
          {
            "Action": [
              "ecr:BatchCheckLayerAvailability",
              "ecr:BatchGetImage",
              "ecr:DescribeRepositories",
              "ecr:GetDownloadUrlForLayer",
              "ecr:GetRepositoryPolicy",
              "ecr:ListImages"
            ],
            "Resource": {{ toJson (uniq $resources) }},
            "Effect": "Allow"
          }
{{- end -}}
{{- end -}}
{{- end -}}
