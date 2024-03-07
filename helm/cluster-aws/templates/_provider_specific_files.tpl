{{- define "provider-specific-files" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "resource.default.name" $ }}-provider-specific-files
  namespace: {{ $.Release.Namespace | quote }}
data:
  99-unmanaged-devices.network: {{ tpl ($.Files.Get "files/etc/systemd/network/99-unmanaged-devices.network") $ | b64enc | quote }}
type: Opaque
{{ end }}
