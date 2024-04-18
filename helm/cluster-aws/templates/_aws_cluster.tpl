{{- define "aws-cluster" }}
{{- if and (regexMatch "\\.internal$" (required "global.connectivity.baseDomain is required" .Values.global.connectivity.baseDomain)) (eq (required "global.connectivity.dns.mode required" .Values.global.connectivity.dns.mode) "public") }}
{{- fail "global.connectivity.dns.mode=public cannot be combined with a '*.internal' baseDomain since reserved-as-private TLDs are not propagated to public DNS servers and therefore crucial DNS records such as api.<baseDomain> cannot be looked up" }}
{{- end }}
{{- $region := include "aws-region" . }}
{{/* $azs is a list of availability zones that are available for the region. Used for defaulting. */}}
{{- $azs := include "azs-in-region" (dict "region" $region  "Files" .Files ) | fromYamlArray -}}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSCluster
metadata:
  annotations:
    "helm.sh/resource-policy": keep
    aws.giantswarm.io/vpc-mode: "{{ .Values.global.connectivity.vpcMode }}"
    aws.giantswarm.io/dns-mode: "public"
    {{- if .Values.global.connectivity.dns.resolverRulesOwnerAccount }}
    aws.giantswarm.io/resolver-rules-owner-account: "{{ .Values.global.connectivity.dns.resolverRulesOwnerAccount }}"
    {{- end}}
    {{- if (eq .Values.global.connectivity.vpcMode "private") }}
    cluster.x-k8s.io/paused: "true"
    {{end}}
    aws.cluster.x-k8s.io/external-resource-gc: "true"
    aws.cluster.x-k8s.io/external-resource-tasks-gc: "load-balancer,security-group"
    aws.giantswarm.io/vpc-endpoint-mode: "{{ .Values.global.connectivity.vpcEndpointMode }}"
    network-topology.giantswarm.io/mode: "{{ .Values.global.connectivity.topology.mode }}"
    {{- if .Values.global.connectivity.topology.transitGatewayId }}
    network-topology.giantswarm.io/transit-gateway: "{{ .Values.global.connectivity.topology.transitGatewayId }}"
    {{- end }}
    {{- if .Values.global.connectivity.topology.prefixListId }}
    network-topology.giantswarm.io/prefix-list: "{{ .Values.global.connectivity.topology.prefixListId }}"
    {{- end }}
  labels:
    {{- include "labels.common" $ | nindent 4 }}
    {{- include "preventDeletionLabel" $ | nindent 4 -}}
    app.kubernetes.io/version: {{ .Chart.Version | quote }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  additionalTags:
    giantswarm.io/cluster: {{ include "resource.default.name" $ }}
    {{- if .Values.global.providerSpecific.additionalResourceTags -}}{{- toYaml .Values.global.providerSpecific.additionalResourceTags | nindent 4 }}{{- end}}
  bastion:
    enabled: false
  identityRef:
    kind: AWSClusterRoleIdentity
    {{- with .Values.global.providerSpecific.awsClusterRoleIdentityName }}
    name: {{ . | quote }}
    {{- end }}
  controlPlaneLoadBalancer:
    scheme: {{ if (eq .Values.global.controlPlane.apiMode "public") }}internet-facing{{ else }}internal{{ end }}
    {{- if .Values.global.controlPlane.loadBalancerIngressAllowCidrBlocks }}
    ingressRules:
    - description: "Kubernetes API"
      protocol: tcp
      fromPort: 443
      toPort: 443
      # We append the Giant Swarm VPN IPs (internal link: https://github.com/giantswarm/vpn/tree/master/hosts_inventory, https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/tc_api_whitelisting/)
      cidrBlocks: {{- toYaml ((concat .Values.global.controlPlane.loadBalancerIngressAllowCidrBlocks (list "95.179.153.65/32" "185.102.95.187/32")) | uniq) | nindent 6 }}
    {{- end }}
  network:
    cni:
      cniIngressRules:
      - description: allow AWS CNI traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
    vpc:
      availabilityZoneUsageLimit: {{ .Values.global.connectivity.availabilityZoneUsageLimit }}
      emptyRoutesDefaultVPCSecurityGroup: true
      {{- if .Values.global.connectivity.network.vpcId }}
      id: {{ .Values.global.connectivity.network.vpcId }}
      {{- else }}
      cidrBlock: {{ .Values.global.connectivity.network.vpcCidr }}
      {{- end }}
      {{- if .Values.global.connectivity.network.internetGatewayId }}
      internetGatewayId: {{ .Values.global.connectivity.network.internetGatewayId }}
      {{- end }}
    subnets:
    {{- range $j, $subnet := .Values.global.connectivity.subnets }}
    {{- if $subnet.id }}
    - id: {{ $subnet.id }}
      isPublic: {{ $subnet.isPublic }}
      routeTableId: {{ $subnet.routeTableId }}
      {{- if $subnet.natGatewayId }}
      natGatewayId: {{ $subnet.natGatewayId }}
      {{- end }}
    {{- else }}
    {{- range $i, $cidr := $subnet.cidrBlocks -}}
    {{- /*
    Use customer-specified availability zone for this subnet, default to picking one of the available zones from $azs variable
    We use the 'mod' function as an index because it might be that the number of subnets and the number of availability zones differ in a region
    */}}
    {{- $az := $cidr.availabilityZone | default (index $azs (mod $i (len $azs))) -}}
    {{- if (eq (len $az) 1) -}}
    {{- $az = printf "%s%s" (include "aws-region" $) $az -}}
    {{- end -}}
    {{/* CAPA v2.3.0 defaults to using the `id` field as subnet name unless it's an unmanaged one (`id` starts with `subnet-`), so use CAPA's previous standard subnet naming scheme */}}
    - id: "{{ include "resource.default.name" $ }}-subnet-{{ $subnet.isPublic | default false | ternary "public" "private" }}-{{ $az }}"
      cidrBlock: "{{ $cidr.cidr }}"
      availabilityZone: "{{ $az }}"
      isPublic: {{ $subnet.isPublic | default false }}
      {{- if or $subnet.tags $cidr.tags }}
      tags:
        {{- toYaml $subnet.tags | nindent 8 }}
        {{- if $cidr.tags }}
        {{- toYaml $cidr.tags | nindent 8 }}
        {{- end }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
  sshKeyName: ssh-key
  s3Bucket:
    controlPlaneIAMInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
    name: {{ include "aws-region" . }}-capa-{{ include "resource.default.name" $ }}
    nodesIAMInstanceProfiles:
    {{- range $name, $value := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
    - nodes-{{ $name }}-{{ include "resource.default.name" $ }}
    {{- end }}
  region: {{ include "aws-region" . }}
{{ end }}
