{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    {{- with .Values.metadata.description }}
    cluster.giantswarm.io/description: "{{ . }}"
    {{- end }}
    network-topology.giantswarm.io/mode: "{{ .Values.connectivity.topology.mode }}"
    {{- if .Values.connectivity.topology.transitGatewayId }}
    network-topology.giantswarm.io/transit-gateway: "{{ .Values.connectivity.topology.transitGatewayId }}"
    {{- end }}
    {{- if .Values.connectivity.topology.prefixListId }}
    network-topology.giantswarm.io/prefix-list: "{{ .Values.connectivity.topology.prefixListId }}"
    {{- end }}
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- if .Values.metadata.servicePriority }}
    giantswarm.io/service-priority: {{ .Values.metadata.servicePriority }}
    {{- end }}
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
      {{- toYaml .Values.connectivity.network.services.cidrBlocks | nindent 8 }}
    pods:
      cidrBlocks:
      {{- toYaml .Values.connectivity.network.pods.cidrBlocks | nindent 8 }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AWSCluster
    name: {{ include "resource.default.name" $ }}
  {{- if (eq .Values.connectivity.vpcMode "private") }}
  paused: true
  {{- end -}}
{{- end -}}
