{{- define "bastion" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .Values.bastion.replicas }}
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
      cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
        cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-bastion
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachineTemplate
        name: {{ include "resource.default.name" $ }}-bastion
      version: v0.0.0
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      instanceType: {{ .Values.bastion.instanceType }}
      additionalSecurityGroups:
      - filters:
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
          values:
          - bastion
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/cluster/{{ include "resource.default.name" $ }}
          values:
          - owned
      cloudInit: {}
      imageLookupBaseOS: flatcar-stable
      imageLookupOrg: "{{ .Values.flatcarAWSAccount }}"
      publicIP: true
      sshKeyName: ""
      subnet:
        filters:
        - name: tag:sigs.k8s.io/cluster-api-provider-aws/role
          values:
          - public
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
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
      preKubeadmCommands:
      - envsubst < /etc/kubeadm.yml > /etc/kubeadm.yml.tmp
      - mv /etc/kubeadm.yml.tmp /etc/kubeadm.yml
      {{- include "ignitionDecodeBase64SSH" . | nindent 6 -}}
      files:
      {{- include "sshFilesBastion" $ | nindent 6 }}
      users:
      {{- include "sshUsers" . | nindent 6 }}
      - name: calvix
        groups: sudo
        sudo: ALL=(ALL) NOPASSWD:ALL
        sshAuthorizedKeys:
        - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKLSRVtP/b9bcMPYOa49/rj+09bb9TP8L3kCyh4miDkr calvix@ethernal"
{{- end -}}
