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
      name: {{ include "resource.default.name" $ }}-control-plane
  kubeadmConfigSpec:
    format: ignition
    ignition:
      containerLinuxConfig:
        additionalConfig: |
          storage:
            links:
            # For some reason enabling services via systemd.units doesn't work on Flatcar CAPI AMIs.
            - path: /etc/systemd/system/multi-user.target.wants/coreos-metadata.service
              target: /usr/lib/systemd/system/coreos-metadata.service
            - path: /etc/systemd/system/multi-user.target.wants/kubeadm.service
              target: /etc/systemd/system/kubeadm.service
          systemd:
            units:
            - name: kubeadm.service
              dropins:
              - name: 10-flatcar.conf
                contents: |
                  [Unit]
                  # kubeadm must run after coreos-metadata populated /run/metadata directory.
                  Requires=coreos-metadata.service
                  After=coreos-metadata.service
                  [Service]
                  # Ensure kubeadm service has access to kubeadm binary in /opt/bin on Flatcar.
                  Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/bin
                  # To make metadata environment variables available for pre-kubeadm commands.
                  EnvironmentFile=/run/metadata/*
    clusterConfiguration:
      apiServer:
        extraArgs:
          cloud-provider: aws
          audit-log-maxage: "30"
          audit-log-maxbackup: "30"
          audit-log-maxsize: "100"
          audit-log-path: /var/log/apiserver/audit.log
          audit-policy-file: /etc/kubernetes/policies/audit-policy.yaml
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
    {{- include "kubernetesFiles" . | nindent 4 }}
    initConfiguration:
      localAPIEndpoint:
        advertiseAddress: ""
        bindPort: 0
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: aws
          healthz-bind-address: 0.0.0.0
          image-pull-progress-deadline: 1m
          v: "2"
        name: ${COREOS_EC2_HOSTNAME}
    joinConfiguration:
      discovery: {}
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: aws
        name: ${COREOS_EC2_HOSTNAME}
    preKubeadmCommands:
    - envsubst < /etc/kubeadm.yml > /etc/kubeadm.yml.tmp
    - mv /etc/kubeadm.yml.tmp /etc/kubeadm.yml
    - 'files="/etc/ssh/trusted-user-ca-keys.pem /etc/ssh/sshd_config /etc/kubernetes/policies/audit-policy.yaml"; for f in $files; do tmpFile=$(mktemp); cat "${f}" | base64 -d > ${tmpFile}; if [ "$?" -eq 0 ]; then mv ${tmpFile} ${f};fi;  done;'
    - systemctl restart sshd
    users:
    {{- include "sshUsers" . | nindent 4 }}
    - name: calvix
      groups: sudo
      sudo: ALL=(ALL) NOPASSWD:ALL
      sshAuthorizedKeys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKLSRVtP/b9bcMPYOa49/rj+09bb9TP8L3kCyh4miDkr calvix@ethernal"
  replicas: {{ .Values.controlPlane.replicas }}
  version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: control-plane
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      ami: {}
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
      iamInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
      sshKeyName: ""
      imageLookupBaseOS: flatcar-stable
      imageLookupOrg: "{{ .Values.flatcarAWSAccount }}"
{{- end -}}
