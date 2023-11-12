{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    {{- with .Values.global.metadata.description }}
    cluster.giantswarm.io/description: "{{ . }}"
    {{- end }}
    network-topology.giantswarm.io/mode: "{{ .Values.global.connectivity.topology.mode }}"
    {{- if .Values.global.connectivity.topology.transitGatewayId }}
    network-topology.giantswarm.io/transit-gateway: "{{ .Values.global.connectivity.topology.transitGatewayId }}"
    {{- end }}
    {{- if .Values.global.connectivity.topology.prefixListId }}
    network-topology.giantswarm.io/prefix-list: "{{ .Values.global.connectivity.topology.prefixListId }}"
    {{- end }}
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- if .Values.global.metadata.servicePriority }}
    giantswarm.io/service-priority: {{ .Values.global.metadata.servicePriority }}
    {{- end }}
    {{- include "labels.common" $ | nindent 4 }}
    {{- include "preventDeletionLabel" $ | nindent 4 -}}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
      {{- toYaml .Values.global.connectivity.network.services.cidrBlocks | nindent 8 }}
    pods:
      cidrBlocks:
      {{- toYaml .Values.global.connectivity.network.pods.cidrBlocks | nindent 8 }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AWSCluster
    name: {{ include "resource.default.name" $ }}
  {{- if (eq .Values.global.connectivity.vpcMode "private") }}
  paused: true
  {{- end -}}
{{- end -}}
