{{- define "provider-specific-files" }}
apiVersion: v1
kind: Secret
metadata:
  {{/*
      You MUST bump the name suffix here and in `values.schema.json` every time one of these files
      changes its content. Automatically appending a hash of the content here doesn't work
      since we'd need to edit `values.schema.json` as well, but that file is created by humans.
  */}}
  name: {{ include "resource.default.name" $ }}-provider-specific-files-5
  namespace: {{ $.Release.Namespace | quote }}
data:
  kubelet-aws-config.service: {{ tpl ($.Files.Get "files/etc/systemd/system/kubelet-aws-config.service") $ | b64enc | quote }}
  kubelet-aws-config.sh: {{ tpl ($.Files.Get "files/opt/bin/kubelet-aws-config.sh") $ | b64enc | quote }}
  99-unmanaged-devices.network: {{ tpl ($.Files.Get "files/etc/systemd/network/99-unmanaged-devices.network") $ | b64enc | quote }}
  wait-elb-dns.sh: {{ tpl ($.Files.Get "files/opt/bin/wait-elb-dns.sh") $ | b64enc | quote }}
type: Opaque
{{ end }}
