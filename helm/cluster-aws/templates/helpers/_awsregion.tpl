{{- /*
If no region is provided in the values we'll attempt to look it up based on the region used by the management cluster
*/}}
{{- define "aws-region" }}
{{- $region := .Values.global.providerSpecific.region }}
{{- if not $region }}
{{- $nodes :=  (lookup "v1" "Node" "" "" ).items }}
{{- if $nodes }}
{{- if (gt (len $nodes) 0) }}
{{- $node := (first $nodes) }}
{{- $region = (get $node.metadata.labels "topology.kubernetes.io/region") }}
{{- end }}
{{- end }}
{{- end }}
{{- required "Unable to default the region. Please set .global.providerSpecific.region" $region }}
{{- end }}
