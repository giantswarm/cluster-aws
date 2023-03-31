{{- define "aws-cluster" }}
{{- if and (regexMatch "\\.internal$" (required "baseDomain is required" .Values.baseDomain)) (eq (required "connectivity.dns.mode required" .Values.connectivity.dns.mode) "public") }}
{{- fail "connectivity.dns.mode=public cannot be combined with a '*.internal' baseDomain since reserved-as-private TLDs are not propagated to public DNS servers and therefore crucial DNS records such as api.<baseDomain> cannot be looked up" }}
{{- end }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSCluster
metadata:
  annotations:
    aws.giantswarm.io/vpc-mode: "{{ .Values.connectivity.vpcMode }}"
    aws.giantswarm.io/dns-mode: {{ if (eq .Values.connectivity.dns.mode "private") }}"private"{{ else }}"public"{{ end }}
    {{- if (eq .Values.connectivity.dns.mode "private") }}
    {{- with .Values.connectivity.dns.additionalVpc }}
    aws.giantswarm.io/dns-assign-additional-vpc: {{ . | join "," | quote }}
    {{- end }}
    {{- end }}
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
  network:
    cni:
      cniIngressRules:
      - description: allow AWS CNI traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
    vpc:
      availabilityZoneUsageLimit: {{ .Values.connectivity.availabilityZoneUsageLimit }}
      cidrBlock: {{ .Values.connectivity.network.vpcCidr }}
    subnets:
    {{- range $j, $subnet := .Values.connectivity.subnets }}
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
  sshKeyName: ssh-key
  s3Bucket:
    controlPlaneIAMInstanceProfile: control-plane-{{ include "resource.default.name" $ }}
    name: {{ include "aws-region" . }}-capa-{{ include "resource.default.name" $ }}
    nodesIAMInstanceProfiles:
    {{- range .Values.machinePools }}
    - nodes-{{ .name }}-{{ include "resource.default.name" $ }}
    {{- end }}
  region: {{ include "aws-region" . }}
{{ end }}
