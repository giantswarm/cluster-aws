{{/*
    The cluster name is prepended to this, either by `resource.default.name` below or by the
    `prependClusterNameAsPrefix` field of the referencing `contentFrom.secret`.

    You MUST bump the numeric name suffix here and in `values.schema.json` every time one of these files
    changes its content. Automatically appending a hash of the content here doesn't work
    since we'd need to edit `values.schema.json` as well, but that file is created by humans.
*/}}
{{- define "provider-specific-files-secret-name" -}}
provider-specific-files-6
{{- end }}

{{- define "provider-specific-files" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "resource.default.name" $ }}-{{ include "provider-specific-files-secret-name" $ }}
  namespace: {{ $.Release.Namespace | quote }}
data:
  kubelet-aws-config.service: {{ tpl ($.Files.Get "files/etc/systemd/system/kubelet-aws-config.service") $ | b64enc | quote }}
  kubelet-aws-config.sh: {{ tpl ($.Files.Get "files/opt/bin/kubelet-aws-config.sh") $ | b64enc | quote }}
  99-unmanaged-devices.network: {{ tpl ($.Files.Get "files/etc/systemd/network/99-unmanaged-devices.network") $ | b64enc | quote }}
  wait-elb-dns.sh: {{ tpl ($.Files.Get "files/opt/bin/wait-elb-dns.sh") $ | b64enc | quote }}
  setup-instance-store.sh: {{ tpl ($.Files.Get "files/opt/bin/setup-instance-store.sh") $ | b64enc | quote }}
  instance-store-setup.service: {{ tpl ($.Files.Get "files/etc/systemd/system/instance-store-setup.service") $ | b64enc | quote }}
  var-lib-kubelet.mount: {{ tpl ($.Files.Get "files/etc/systemd/system/var-lib-kubelet.mount") $ | b64enc | quote }}
  20-var-lib-kubelet-mount.conf: {{ tpl ($.Files.Get "files/etc/systemd/system/kubelet.service.d/20-var-lib-kubelet-mount.conf") $ | b64enc | quote }}
type: Opaque
{{ end }}
