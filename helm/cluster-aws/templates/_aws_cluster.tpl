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
    {{- if .Values.global.providerSpecific.irsa_crossplane }}
    giantswarm.io/pause-irsa-operator: "true"
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
    {{- /* Used for migration from Vintage AWS to CAPA cluster. This adds all listed service account issuers to IAM trust policies. */}}
    {{- if .Values.cluster.providerIntegration.controlPlane.kubeadmConfig.clusterConfiguration.apiServer.serviceAccountIssuers }}
    aws.giantswarm.io/irsa-trust-domains: {{ include "service-account-issuers-comma-separated" $ | quote }}
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
    giantswarm.io/installation: {{ .Values.global.managementCluster }}
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
    {{- if eq (required "global.connectivity.cilium.ipamMode is required"  .Values.global.connectivity.cilium.ipamMode) "eni" }}
    additionalControlPlaneIngressRules:
      - description: "Allow traffic from pods to control plane nodes for access of applications to Kubernetes API"
        protocol: "-1" # all
        fromPort: -1
        toPort: -1

        # We could also use `sourceSecurityGroupIds` here, but the ID of the "<cluster>-pods" security group isn't known yet
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
    additionalNodeIngressRules:
      - description: "Allow traffic from Pods to the Cilium Relay port running on the nodes"
        protocol: "tcp"
        fromPort: 4244
        toPort: 4244
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to Chart Operator running on the nodes"
        protocol: "tcp"
        fromPort: 8000
        toPort: 8000
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to EBS CSI Controller running on the nodes"
        protocol: "tcp"
        fromPort: 8610
        toPort: 8610
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to Cilium Operator and Envoy running on the nodes"
        protocol: "tcp"
        fromPort: 9963
        toPort: 9964
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to the Kubelet API running on the nodes"
        protocol: "tcp"
        fromPort: 10250
        toPort: 10250
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to Node Exporter running on the nodes"
        protocol: "tcp"
        fromPort: 10300
        toPort: 10300
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
      - description: "Allow traffic from Pods to Kubernetes Resource Count Exporter running on the nodes"
        protocol: "tcp"
        fromPort: 10999
        toPort: 10999
        cidrBlocks: {{ required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | toYaml | nindent 10 }}
    {{- end }}
    cni:
      cniIngressRules:
      - description: allow AWS CNI traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
    vpc:
      availabilityZoneUsageLimit: {{ .Values.global.connectivity.availabilityZoneUsageLimit }}
      emptyRoutesDefaultVPCSecurityGroup: true
      {{ $vpcCidrs := list }}
      {{- if .Values.global.connectivity.network.vpcId }}
      id: {{ .Values.global.connectivity.network.vpcId }}
      {{- else }}
      {{- if and .Values.global.connectivity.network.vpcCidr .Values.global.connectivity.network.vpcCidrs (ne .Values.global.connectivity.network.vpcCidr (.Values.global.connectivity.network.vpcCidrs | first)) }}
        {{ fail (printf "You have a VPC CIDR block %s specified in `global.connectivity.network.vpcCidr` that is different from the the first CIDR %s in the list `global.connectivity.network.vpcCidrs`. If this is an existing cluster template, this error happens because you need to migrate to `global.connectivity.network.vpcCidrs` (plural!). Please remove the deprecated `global.connectivity.network.vpcCidr` and ensure `global.connectivity.network.vpcCidrs` contains the desired CIDRs. If needed, `global.connectivity.network.vpcCidr` can be kept for backward compatibility, but its value must be the same as the first item in the array `global.connectivity.network.vpcCidrs`." (.Values.global.connectivity.network.vpcCidr | quote) (.Values.global.connectivity.network.vpcCidrs | first | quote)) }}
      {{- end }}
      {{- $vpcCidrs = or .Values.global.connectivity.network.vpcCidrs (list .Values.global.connectivity.network.vpcCidr) (list "10.0.0.0/16") }}
      cidrBlock: {{ $vpcCidrs | first | quote }}
      {{- end }}
      {{- if .Values.global.connectivity.network.internetGatewayId }}
      internetGatewayId: {{ .Values.global.connectivity.network.internetGatewayId }}
      {{- end }}
      {{- if eq (required "global.connectivity.cilium.ipamMode is required"  .Values.global.connectivity.cilium.ipamMode) "eni" }}
      secondaryCidrBlocks:
        # Managed by Cilium in ENI mode
        {{- if not (required "global.connectivity.network.pods.cidrBlocks is required" .Values.global.connectivity.network.pods.cidrBlocks | first | regexMatch "/(1[6-9]|2[0-8])$") }}
          {{ fail (printf "You have set `global.connectivity.cilium.ipamMode=eni`, but the pod CIDR %s is not supported as AWS VPC CIDR (see https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html: /16 to /28 sizes are supported). Please change `global.connectivity.network.pods.cidrBlocks` to a valid value (see https://github.com/giantswarm/cluster-aws/tree/main/helm/cluster-aws#connectivity)." (.Values.global.connectivity.network.pods.cidrBlocks | first | quote)) }}
        {{- end }}
        - ipv4CidrBlock: {{ .Values.global.connectivity.network.pods.cidrBlocks | first | quote }}

        {{/* First block gets created by CAPA through `AWSCluster.spec.vpc.cidrBlock`, others must be listed here */}}
        {{ range $cidrBlockIndex, $cidrBlock := $vpcCidrs }}
          {{ if and (gt $cidrBlockIndex 0) (ne $cidrBlock ($.Values.global.connectivity.network.pods.cidrBlocks | first)) }}
        - ipv4CidrBlock: {{ $cidrBlock | quote }}
          {{- end }}
        {{ end }}
      {{- else if gt (len $vpcCidrs) 1 }}
      secondaryCidrBlocks:
        {{/* First block gets created by CAPA through `AWSCluster.spec.vpc.cidrBlock`, others must be listed here */}}
        {{ range $cidrBlockIndex, $cidrBlock := $vpcCidrs }}
          {{ if gt $cidrBlockIndex 0 }}
            - ipv4CidrBlock: {{ $cidrBlock | quote }}
          {{- end }}
        {{ end }}
      {{- end }}
    subnets:
    {{- $generatedSubnetIds := dict }}
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
    {{/* CAPA v2.3.0 defaults to using the `id` field as subnet name unless it's an unmanaged one (`id` starts with `subnet-`), so use CAPA's previous standard subnet naming scheme. That field must be unique since it's used as map key, so if there are too many subnets, we ensure uniqueness with a suffix. */}}
    {{- $generatedSubnetId := printf "%s-subnet-%s-%s" (include "resource.default.name" $) ($subnet.isPublic | default false | ternary "public" "private") $az }}
    {{- if index $generatedSubnetIds $generatedSubnetId }}
      {{- range $i := list 1 2 3 4 5 6 7 8 9 10 }}
        {{- $generatedSubnetIdWithSuffix := printf "%s-%d" $generatedSubnetId $i }}
        {{- if not (index $generatedSubnetIds $generatedSubnetIdWithSuffix) }}
          {{- $generatedSubnetId = $generatedSubnetIdWithSuffix }}
          {{- break }}
        {{- end }}
      {{- end }}
    {{- end }}
    {{- $_ := set $generatedSubnetIds $generatedSubnetId true }}
    - id: {{ $generatedSubnetId | quote }}
      cidrBlock: "{{ $cidr.cidr }}"
      availabilityZone: "{{ $az }}"
      isPublic: {{ $subnet.isPublic | default false }}
      {{- if or $subnet.tags $cidr.tags }}
      tags:
        {{- if $subnet.tags }}
        {{- toYaml $subnet.tags | nindent 8 }}
        {{- end }}
        {{- if $cidr.tags }}
        {{- toYaml $cidr.tags | nindent 8 }}
        {{- end }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}

    {{- if eq (required "global.connectivity.cilium.ipamMode is required"  .Values.global.connectivity.cilium.ipamMode) "eni" }}
    {{- range $j, $subnet := .Values.global.connectivity.eniModePodSubnets }}
    {{- range $i, $cidr := $subnet.cidrBlocks }}
    - id: "{{ include "resource.default.name" $ }}-subnet-secondary-{{ if eq (len $cidr.availabilityZone) 1 }}{{ include "aws-region" $ }}{{ end }}{{ $cidr.availabilityZone }}"
      cidrBlock: "{{ $cidr.cidr }}"
      {{- if eq (len $cidr.availabilityZone) 1 }}
      availabilityZone: "{{ include "aws-region" $ }}{{ $cidr.availabilityZone }}"
      {{- else }}
      availabilityZone: "{{ $cidr.availabilityZone }}"
      {{- end }}
      isPublic: false
      {{- if ne (index $cidr.tags "sigs.k8s.io/cluster-api-provider-aws/association") "secondary" }}
        {{ fail (printf "You have set `global.connectivity.cilium.ipamMode=eni`, but the pod subnet %q in `global.connectivity.eniModePodSubnets` is not tagged with `sigs.k8s.io/cluster-api-provider-aws/association=secondary`, as required so that CAPA does not accidentally choose the subnet for nodes (see https://github.com/giantswarm/cluster-aws/tree/main/helm/cluster-aws#connectivity)." $cidr.cidr) }}
      {{- end }}
      {{- if or $subnet.tags $cidr.tags }}
      tags:
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
