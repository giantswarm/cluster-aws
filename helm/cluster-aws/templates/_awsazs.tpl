{{- /*
If no availability zones are provided in the values we'll attempt to look it up based on the AZs used by the management cluster
*/}}
{{- define "aws-availability-zones" }}
{{- $azs := list }}
{{- $nodes :=  (lookup "v1" "Node" "" "" ).items }}
{{- range $nodes }}
{{- $azs = append $azs (get .metadata.labels "topology.kubernetes.io/zone") }}
{{- end }}
{{- $azs | uniq | toJson }}
{{- end }}
