{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    {{- with .Values.metadata.description }}
    cluster.giantswarm.io/description: "{{ . }}"
    {{- end }}
    network-topology.giantswarm.io/mode: "{{ .Values.network.topologyMode }}"
    {{- if .Values.network.transitGatewayID }}
    network-topology.giantswarm.io/transit-gateway: "{{ .Values.network.transitGatewayID }}"
    {{- end }}
    {{- if .Values.network.prefixListID }}
    network-topology.giantswarm.io/prefix-list: "{{ .Values.network.prefixListID }}"
    {{- end }}
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
       - {{ .Values.connectivity.network.serviceCidr }}
    pods:
      cidrBlocks:
      - {{ .Values.network.podCIDR }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AWSCluster
    name: {{ include "resource.default.name" $ }}
  {{- if (eq .Values.network.vpcMode "private") }}
  paused: true
  {{- end -}}
{{- end -}}
