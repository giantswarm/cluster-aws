{{/*
AWSMachineTemplates .Spec are immutable and cannot change.
This function is used for both the `.Spec` value and as the data for the hash function.
Any changes to this will trigger the resource to be recreated rather than attempting to update in-place.
*/}}
{{- define "controlplane-awsmachinetemplate-spec" -}}
template:
  metadata:
    labels:
      cluster.x-k8s.io/role: control-plane
      {{- include "labels.common" $ | nindent 6 }}
  spec:
    {{- include "ami" $ | nindent 4 }}
    cloudInit: {}
    instanceType: {{ .Values.controlPlane.instanceType }}
    nonRootVolumes:
    - deviceName: /dev/xvdc
      encrypted: true
      size: {{ .Values.controlPlane.etcdVolumeSizeGB }}
      type: gp3
    - deviceName: /dev/xvdd
      encrypted: true
      size: {{ .Values.controlPlane.containerdVolumeSizeGB }}
      type: gp3
    - deviceName: /dev/xvde
      encrypted: true
      size: {{ .Values.controlPlane.kubeletVolumeSizeGB }}
      type: gp3
    rootVolume:
      size: {{ .Values.controlPlane.rootVolumeSizeGB }}
      type: gp3
    iamInstanceProfile: giantswarm-{{ include "resource.default.name" $ }}-control-plane
    sshKeyName: ""
{{- end }}

{{- define "control-plane" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  machineTemplate:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    infrastructureRef:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AWSMachineTemplate
      name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
  kubeadmConfigSpec:
    clusterConfiguration:
      apiServer:
        timeoutForControlPlane: 20m
        certSANs:
          - "api.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
          - 127.0.0.1
        extraArgs:
          cloud-provider: aws
          service-account-issuer: PLACEHOLDER_CLOUDFRONT_DOMAIN
          {{- if .Values.oidc.issuerUrl }}
          {{- with .Values.oidc }}
          oidc-issuer-url: {{ .issuerUrl }}
          oidc-client-id: {{ .clientId }}
          oidc-username-claim: {{ .usernameClaim }}
          oidc-groups-claim: {{ .groupsClaim }}
          {{- if .caFile }}
          oidc-ca-file: {{ .caFile }}
          {{- end }}
          {{- end }}
          {{- end }}
          audit-log-maxage: "30"
          audit-log-maxbackup: "30"
          audit-log-maxsize: "100"
          audit-log-path: /var/log/apiserver/audit.log
          audit-policy-file: /etc/kubernetes/policies/audit-policy.yaml
          api-audiences: "sts.amazonaws.com{{ if hasPrefix "cn-" .Values.aws.region }}.cn{{ end }}"
          encryption-provider-config: /etc/kubernetes/encryption/config.yaml
          enable-admission-plugins: NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,DefaultStorageClass,PersistentVolumeClaimResize,Priority,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,PodSecurityPolicy
          feature-gates: TTLAfterFinished=true
          kubelet-preferred-address-types: InternalIP
          profiling: "false"
          runtime-config: api/all=true,scheduling.k8s.io/v1alpha1=true
          service-account-lookup: "true"
          tls-cipher-suites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
          service-cluster-ip-range: {{ .Values.network.serviceCIDR }}
        extraVolumes:
        - name: auditlog
          hostPath: /var/log/apiserver
          mountPath: /var/log/apiserver
          readOnly: false
          pathType: DirectoryOrCreate
        - name: policies
          hostPath: /etc/kubernetes/policies
          mountPath: /etc/kubernetes/policies
          readOnly: false
          pathType: DirectoryOrCreate
        - name: encryption
          hostPath: /etc/kubernetes/encryption
          mountPath: /etc/kubernetes/encryption
          readOnly: false
          pathType: DirectoryOrCreate
      controllerManager:
        extraArgs:
          bind-address: 0.0.0.0
          cloud-provider: aws
          allocate-node-cidrs: "true"
          cluster-cidr: {{ .Values.network.podCIDR }}
      scheduler:
        extraArgs:
          bind-address: 0.0.0.0
      etcd:
        local:
          extraArgs:
            quota-backend-bytes: "8589934592"
      networking:
        serviceSubnet: {{ .Values.network.serviceCIDR }}
    files:
    {{- include "sshFiles" . | nindent 4 }}
    {{- include "diskFiles" . | nindent 4 }}
    {{- include "irsaFiles" . | nindent 4 }}
    {{- if .Values.proxy.enabled }}{{- include "proxyFiles" . | nindent 4 }}{{- end }}
    {{- include "kubernetesFiles" . | nindent 4 }}
    initConfiguration:
      skipPhases:
      - addon/kube-proxy
      localAPIEndpoint:
        advertiseAddress: ""
        bindPort: 0
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: aws
          healthz-bind-address: 0.0.0.0
          image-pull-progress-deadline: 1m
          node-ip: '{{ `{{ ds.meta_data.local_ipv4 }}` }}'
          v: "2"
        name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
    joinConfiguration:
      discovery: {}
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: aws
        name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
    preKubeadmCommands:
    {{- include "diskPreKubeadmCommands" . | nindent 4 }}
    {{- include "irsaPreKubeadmCommands" . | nindent 4 }}
    postKubeadmCommands:
    {{- include "sshPostKubeadmCommands" . | nindent 4 }}
    users:
    {{- include "sshUsers" . | nindent 4 }}
  replicas: {{ .Values.controlPlane.replicas | default "3" }}
  version: v{{ trimPrefix "v" .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "bastion-awsmachinetemplate-spec" $) "global" .) }}
  namespace: {{ $.Release.Namespace }}
spec: {{ include "controlplane-awsmachinetemplate-spec" $ | nindent 2 }}
{{- end -}}
