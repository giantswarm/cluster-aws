{{/*
The secret `-teleport-join-token` is created by the teleport-operator in cluster namespace
and is used to join the node to the teleport cluster.
*/}}

{{- define "teleportNodeRoleContent" -}}
#!/bin/bash
if systemctl is-active -q kubelet.service; then
    if [ -e "/etc/kubernetes/manifests/kube-apiserver.yaml" ]; then
        echo "control-plane"
    else
        echo "worker"
    fi
else
    echo ""
fi
{{- end -}}

{{- define "teleportYamlContent" -}}
version: v3
teleport:
  data_dir: /var/lib/teleport
  join_params:
    token_name: /etc/teleport-join-token
    method: token
  proxy_server: {{ .Values.internal.teleport.proxyAddr }}
  log:
    output: stderr
auth_service:
  enabled: "no"
ssh_service:
  enabled: "yes"
  commands:
  - name: node
    command: [hostname]
    period: 24h0m0s
  - name: arch
    command: [uname, -m]
    period: 24h0m0s
  - name: role
    command: [/opt/teleport-node-role.sh]
    period: 1m0s
  labels:
    mc: {{ .Values.managementCluster }}
    {{- $clusterName := include "resource.default.name" $ }}
    {{- if ne .Values.managementCluster $clusterName }}
    cluster: {{ include "resource.default.name" $ }}
    {{- end }}
    baseDomain: {{ .Values.baseDomain }}
proxy_service:
  enabled: "no"
{{- end -}}

{{- define "teleportFiles" -}}
- path: /opt/teleport-node-role.sh
  permissions: "0755"
  encoding: base64
  content: {{ include "teleportNodeRoleContent" . | b64enc }}
- path: /etc/teleport-join-token
  permissions: "0644"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-teleport-join-token
      key: joinToken
- path: /etc/teleport.yaml
  permissions: "0644"
  encoding: base64
  content: {{ include "teleportYamlContent" $ | b64enc }}
{{- end -}}

{{- define "teleportSystemdUnits" -}}
- name: teleport.service
  enabled: true
  contents: |
    [Unit]
    Description=Teleport Service
    After=network.target

    [Service]
    Type=simple
    Restart=on-failure
    ExecStart=/opt/bin/teleport start --roles=node --config=/etc/teleport.yaml --pid-file=/run/teleport.pid
    ExecReload=/bin/kill -HUP $MAINPID
    PIDFile=/run/teleport.pid
    LimitNOFILE=524288

    [Install]
    WantedBy=multi-user.target
{{- end -}}
