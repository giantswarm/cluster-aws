{{/*
AWSMachineTemplates .Spec are immutable and cannot change.
This function is used for both the `.Spec` value and as the data for the hash function.
Any changes to this will trigger the resource to be recreated rather than attempting to update in-place.
*/}}
{{- define "controlplane-awsmachinetemplate-spec" -}}
{{- include "ami" $ }}
cloudInit: {}
instanceType: {{ .Values.global.controlPlane.instanceType }}
nonRootVolumes:
- deviceName: /dev/xvdc
  encrypted: true
  size: {{ .Values.global.controlPlane.etcdVolumeSizeGB }}
  type: gp3
- deviceName: /dev/xvdd
  encrypted: true
  size: {{ .Values.global.controlPlane.containerdVolumeSizeGB }}
  type: gp3
- deviceName: /dev/xvde
  encrypted: true
  size: {{ .Values.global.controlPlane.kubeletVolumeSizeGB }}
  type: gp3
rootVolume:
  size: {{ .Values.global.controlPlane.rootVolumeSizeGB }}
  type: gp3
iamInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
{{- if .Values.global.controlPlane.additionalSecurityGroups }}
additionalSecurityGroups:
{{- toYaml .Values.global.controlPlane.additionalSecurityGroups | nindent 2 }}
{{- end }}
sshKeyName: ""
subnet:
  filters:
    - name: tag:kubernetes.io/cluster/{{ include "resource.default.name" $ }}
      values:
      - shared
      - owned
    {{ if eq $.Values.global.connectivity.vpcMode "public" }}
    - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
      values:
      - private
    {{end}}
    {{- range $i, $tags :=  .Values.global.controlPlane.subnetTags }}
    - name: tag:{{ keys $tags | first }}
      values:
      - {{ index $tags (keys $tags | first) | quote }}
    {{- end }}
{{- end }}

{{- define "control-plane" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  annotations:
    "helm.sh/resource-policy": keep
  labels:
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  machineTemplate:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
        app.kubernetes.io/version: {{ .Chart.Version | quote }}
    infrastructureRef:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AWSMachineTemplate
      name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-awsmachinetemplate-spec" $) "global" .) }}
  kubeadmConfigSpec:
    format: ignition
    ignition:
      containerLinuxConfig:
        additionalConfig: |
          systemd:
            units:
            {{- include "flatcarSystemdUnits" $ | nindent 14 }}
            {{- include "diskStorageSystemdUnits" $ | nindent 14 }}
            {{- if .Values.internal.teleport.enabled }}
            {{- include "teleportSystemdUnits" $ | nindent 14 }}
            {{- end }}
          storage:
            filesystems:
            {{- include "diskStorageConfig" $ | nindent 14 }}
            directories:
            {{- include "nodeDirectories" $ | nindent 14 }}
    clusterConfiguration:
      # Avoid accessibility issues (e.g. on private clusters) and potential future rate limits for the default `registry.k8s.io`
      imageRepository: docker.io/giantswarm

      apiServer:
        timeoutForControlPlane: 20m
        certSANs:
          - "api.{{ include "resource.default.name" $ }}.{{ required "The baseDomain value is required" .Values.global.connectivity.baseDomain }}"
          - 127.0.0.1
          {{- if .Values.global.controlPlane.apiExtraCertSANs -}}
          {{- toYaml .Values.global.controlPlane.apiExtraCertSANs | nindent 10 }}
          {{- end }}
        extraArgs:
          cloud-provider: external
          service-account-issuer: "https://irsa.{{ include "resource.default.name" $ }}.{{ required "The baseDomain value is required" .Values.global.connectivity.baseDomain }}"
          {{- if .Values.global.controlPlane.oidc.issuerUrl }}
          {{- with .Values.global.controlPlane.oidc }}
          oidc-issuer-url: {{ .issuerUrl }}
          oidc-client-id: {{ .clientId }}
          oidc-username-claim: {{ .usernameClaim }}
          oidc-groups-claim: {{ .groupsClaim }}
          {{- if .caPem }}
          oidc-ca-file: /etc/ssl/certs/oidc.pem
          {{- end }}
          {{- end }}
          {{- end }}
          audit-log-maxage: "30"
          audit-log-maxbackup: "30"
          audit-log-maxsize: "100"
          audit-log-path: /var/log/apiserver/audit.log
          audit-policy-file: /etc/kubernetes/policies/audit-policy.yaml
          api-audiences: "sts.amazonaws.com{{ if hasPrefix "cn-" (include "aws-region" .) }}.cn{{ end }}"
          encryption-provider-config: /etc/kubernetes/encryption/config.yaml
          enable-admission-plugins: NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,DefaultStorageClass,PersistentVolumeClaimResize,Priority,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,PodSecurityPolicy
          feature-gates: CronJobTimeZone=true
          kubelet-preferred-address-types: InternalIP
          profiling: "false"
          runtime-config: api/all=true,scheduling.k8s.io/v1alpha1=true
          service-account-lookup: "true"
          tls-cipher-suites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
          service-cluster-ip-range: {{ .Values.global.connectivity.network.services.cidrBlocks | first }}
          {{- if .Values.global.controlPlane.apiExtraArgs -}}
          {{- toYaml .Values.global.controlPlane.apiExtraArgs | nindent 10 }}
          {{- end }}
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
          authorization-always-allow-paths: "/healthz,/readyz,/livez,/metrics"
          bind-address: 0.0.0.0
          cloud-provider: external
          terminated-pod-gc-threshold: "125"
          allocate-node-cidrs: "true"
          cluster-cidr: {{ .Values.global.connectivity.network.pods.cidrBlocks | first }}
          feature-gates: CronJobTimeZone=true
      scheduler:
        extraArgs:
          authorization-always-allow-paths: "/healthz,/readyz,/livez,/metrics"
          bind-address: 0.0.0.0
          feature-gates: CronJobTimeZone=true
      etcd:
        local:
          extraArgs:
            listen-metrics-urls: "http://0.0.0.0:2381"
            quota-backend-bytes: "8589934592"
            {{- if .Values.internal.migration.etcdExtraArgs -}}
            {{- toYaml .Values.internal.migration.etcdExtraArgs | nindent 12 }}
            {{- end }}
      networking:
        serviceSubnet: {{ join "," .Values.global.connectivity.network.services.cidrBlocks }}
    files:
    {{- include "controlPlaneFiles" . | nindent 4 }}
    {{- include "sshFiles" . | nindent 4 }}
    {{- include "kubeletConfigFiles" . | nindent 4 }}
    {{- include "nodeConfigFiles" . | nindent 4 }}
    {{- if .Values.global.connectivity.proxy.enabled }}{{- include "proxyFiles" . | nindent 4 }}{{- end }}
    {{- include "kubernetesFiles" . | nindent 4 }}
    {{- include "registryFiles" . | nindent 4 }}
    {{- if .Values.internal.teleport.enabled }}
    {{- include "teleportFiles" . | nindent 4 }}
    {{- end }}
    {{- if .Values.internal.migration.controlPlaneExtraFiles }}
    {{- toYaml .Values.internal.migration.controlPlaneExtraFiles | nindent 4}}
    {{- end }}
    initConfiguration:
      skipPhases:
      - addon/kube-proxy
      - addon/coredns
      localAPIEndpoint:
        advertiseAddress: ""
        bindPort: {{ .Values.internal.migration.apiBindPort }}
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: external
          feature-gates: CronJobTimeZone=true
          healthz-bind-address: 0.0.0.0
          node-ip: ${COREOS_EC2_IPV4_LOCAL}
          v: "2"
        name: ${COREOS_EC2_HOSTNAME}
        {{- if .Values.global.controlPlane.customNodeTaints }}
        {{- if (gt (len .Values.global.controlPlane.customNodeTaints) 0) }}
        taints:
        {{- range .Values.global.controlPlane.customNodeTaints }}
        - key: {{ .key | quote }}
          value: {{ .value | quote }}
          effect: {{ .effect | quote }}
        {{- end }}
        {{- end }}
        {{- end }}
    joinConfiguration:
      discovery: {}
      controlPlane:
        localAPIEndpoint:
          bindPort: {{ .Values.internal.migration.apiBindPort }}
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: external
          feature-gates: CronJobTimeZone=true
        name: ${COREOS_EC2_HOSTNAME}
        {{- if .Values.global.controlPlane.customNodeTaints }}
        {{- if (gt (len .Values.global.controlPlane.customNodeTaints) 0) }}
        taints:
        {{- range .Values.global.controlPlane.customNodeTaints }}
        - key: {{ .key | quote }}
          value: {{ .value | quote }}
          effect: {{ .effect | quote }}
        {{- end }}
        {{- end }}
        {{- end }}
    preKubeadmCommands:
    {{- include "sshPreKubeadmCommands" . | nindent 4 }}
    {{- if .Values.internal.migration.controlPlanePreKubeadmCommands -}}
    {{- toYaml .Values.internal.migration.controlPlanePreKubeadmCommands | nindent 4 }}
    {{- end }}
    {{- include "flatcarKubeadmPreCommands" . | nindent 4 }}
    {{- if .Values.global.connectivity.proxy.enabled }}{{- include "proxyCommand" $ | nindent 4 }}{{- end }}
    postKubeadmCommands:
    {{- include "kubeletConfigPostKubeadmCommands" . | nindent 4 }}
    {{- include "controlPlanePostKubeadmCommands" . | nindent 4 }}
    {{- if .Values.internal.migration.controlPlanePostKubeadmCommands -}}
    {{- toYaml .Values.internal.migration.controlPlanePostKubeadmCommands | nindent 4 }}
    {{- end }}
    users:
    {{- include "sshUsers" . | nindent 4 }}
  replicas: 3
  version: v{{ trimPrefix "v" .Values.internal.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-awsmachinetemplate-spec" $) "global" .) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: control-plane
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- include "controlplane-awsmachinetemplate-spec" $ | nindent 6 }}
{{- end -}}
