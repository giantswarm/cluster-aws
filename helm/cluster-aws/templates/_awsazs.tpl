{{- /*
If no availability zones are provided in the values we'll attempt to look it up based on the AZs used by the management cluster
*/}}
{{- define "aws-availability-zones" }}
{{- $azs := [] }}
{{- range $nodes }}
{{- $az = (get .metadata.labels "topology.kubernetes.io/zone") }}
{{- $azs = append $azs $az}}
{{- end }}
{{- $azs | unique }}
{{- end }}
