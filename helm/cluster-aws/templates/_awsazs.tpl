{{- /*
If no availability zones are provided in the values we'll attempt to look it up based on the region specified in AWSCluster if its missing as well, AZs of the management cluster are used
*/}}
{{- define "aws-availability-zones" }}
{{- if .mp.availabilityZones }}
{{- .mp.availabilityZones | toYaml }}
{{- else }}
{{- $region := include "aws-region" . }}
{{- include "azs-in-region" (dict "region" $region  "Files" .Files ) }}
{{- end }}
{{- end }}

{{- /*
This helper returns a yaml encoded list of availability zones for a region.
It looks up such zones in a file `files/azs-in-region.yaml`.
If the region is missing from the file, it defaults to '<region>a', '<region>b' and '<region>c'.
*/}}
{{- define "azs-in-region" -}}
{{- $region := required "'azs-in-region' function requires a dict with a 'region' key" .region }}
{{- $azsInRegion := .Files.Get "files/azs-in-region.yaml" | fromYaml }}
{{- $azs := list -}}
{{- if hasKey $azsInRegion $region -}}
{{- range (index $azsInRegion $region) -}}
{{- $azs =  append $azs (printf "%s%s" $region .) -}}
{{- end -}}
{{- else -}}
{{- /* Use 'a', 'b', and 'c' as default if the region is not in the azs-in-region.yaml file */ -}}
{{- $azs =  append $azs (printf "%sa" $region) -}}
{{- $azs =  append $azs (printf "%sb" $region) -}}
{{- $azs =  append $azs (printf "%sc" $region) -}}
{{- end -}}
{{- toYaml $azs }}
{{- end -}}
