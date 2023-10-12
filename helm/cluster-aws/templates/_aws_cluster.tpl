{{- define "aws-cluster" }}
{{- if and (regexMatch "\\.internal$" (required "baseDomain is required" .Values.baseDomain)) (eq (required "connectivity.dns.mode required" .Values.connectivity.dns.mode) "public") }}
{{- fail "connectivity.dns.mode=public cannot be combined with a '*.internal' baseDomain since reserved-as-private TLDs are not propagated to public DNS servers and therefore crucial DNS records such as api.<baseDomain> cannot be looked up" }}
{{- end }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSCluster
metadata:
  annotations:
    "helm.sh/resource-policy": keep
    aws.giantswarm.io/vpc-mode: "{{ .Values.connectivity.vpcMode }}"
    aws.giantswarm.io/dns-mode: "public"
    {{- if .Values.connectivity.dns.resolverRulesOwnerAccount }}
    aws.giantswarm.io/resolver-rules-owner-account: "{{ .Values.connectivity.dns.resolverRulesOwnerAccount }}"
    {{- end}}
    {{- if (eq .Values.connectivity.vpcMode "private") }}
    cluster.x-k8s.io/paused: "true"
    {{end}}
    aws.cluster.x-k8s.io/external-resource-gc: "true"
    aws.giantswarm.io/vpc-endpoint-mode: "{{ .Values.connectivity.vpcEndpointMode }}"
  labels:
    {{- include "labels.common" $ | nindent 4 }}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  bastion:
    enabled: false
  identityRef:
    kind: AWSClusterRoleIdentity
    {{- with .Values.providerSpecific.awsClusterRoleIdentityName }}
    name: {{ . | quote }}
    {{- end }}
  controlPlaneLoadBalancer:
    scheme: {{ if (eq .Values.controlPlane.apiMode "public") }}internet-facing{{ else }}internal{{ end }}
    {{- if .Values.controlPlane.loadBalancerIngressAllowCidrBlocks }}
    ingressRules:
    - description: "Kubernetes API"
      protocol: tcp
      fromPort: 6443
      toPort: 6443
      cidrBlocks:
      # Giant Swarm VPN IPs (internal link: https://github.com/giantswarm/vpn/tree/master/hosts_inventory, https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/tc_api_whitelisting/)
      - 185.102.95.187/32
      - 95.179.153.65/32

      {{- toYaml .Values.controlPlane.loadBalancerIngressAllowCidrBlocks | nindent 6 }}
    {{- end }}
  network:
    cni:
      cniIngressRules:
      - description: allow AWS CNI traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
    vpc:
      availabilityZoneUsageLimit: {{ .Values.connectivity.availabilityZoneUsageLimit }}
      {{- if .Values.connectivity.network.vpcId }}
      id: {{ .Values.connectivity.network.vpcId }}
      {{- else }}
      cidrBlock: {{ .Values.connectivity.network.vpcCidr }}
      {{- end }}
      {{- if .Values.connectivity.network.internetGatewayId }}
      internetGatewayId: {{ .Values.connectivity.network.internetGatewayId }}
      {{- end }}
    subnets:
    {{- range $j, $subnet := .Values.connectivity.subnets }}
    {{- if $subnet.id }}
    - id: {{ $subnet.id }}
      isPublic: {{ $subnet.isPublic }}
      routeTableId: {{ $subnet.routeTableId }}
      {{- if $subnet.natGatewayId }}
      natGatewayId: {{ $subnet.natGatewayId }}
      {{- end }}
    {{- else }}
    {{- range $i, $cidr := $subnet.cidrBlocks }}
    - cidrBlock: "{{ $cidr.cidr }}"
      {{- if eq (len $cidr.availabilityZone) 1 }}
      availabilityZone: "{{ include "aws-region" $ }}{{ $cidr.availabilityZone }}"
      {{- else }}
      availabilityZone: "{{ $cidr.availabilityZone }}"
      {{- end }}
      isPublic: {{ $subnet.isPublic | default false }}
      tags:
        {{- toYaml $subnet.tags | nindent 8 }}
        {{- if $cidr.tags }}
        {{- toYaml $cidr.tags | nindent 8 }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
  sshKeyName: ssh-key
  s3Bucket:
    controlPlaneIAMInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
    name: {{ include "aws-region" . }}-capa-{{ include "resource.default.name" $ }}
    nodesIAMInstanceProfiles:
    {{- range $name, $value := .Values.nodePools | default .Values.internal.nodePools }}
    - nodes-{{ $name }}-{{ include "resource.default.name" $ }}
    {{- end }}
  region: {{ include "aws-region" . }}
{{ end }}
