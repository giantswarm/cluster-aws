{{- define "aws-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSCluster
metadata:
  annotations:
    aws.giantswarm.io/vpc-mode: "{{ .Values.network.vpcMode }}"
    aws.giantswarm.io/dns-mode: {{ if (eq .Values.network.dnsMode "private") }}"private"{{ else }}"public"{{ end }}
    {{- if (eq .Values.network.dnsMode "private") }}
    aws.giantswarm.io/dns-assign-additional-vpc: "{{ .Values.network.dnsAssignAdditionalVPCs }}"
    {{- end }}
    {{- if (eq .Values.network.vpcMode "private") }}
    cluster.x-k8s.io/paused: "true"
    {{end}}
    aws.cluster.x-k8s.io/external-resource-gc: "true"
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  bastion:
    enabled: false
  identityRef:
    kind: AWSClusterRoleIdentity
    name: {{ .Values.aws.awsClusterRole }}
  controlPlaneLoadBalancer:
    scheme: {{ if (eq .Values.network.apiMode "public") }}internet-facing{{ else }}internal{{ end }}
  network:
    cni:
      cniIngressRules:
      - description: allow AWS CNI traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
    vpc:
      availabilityZoneUsageLimit: {{ .Values.network.availabilityZoneUsageLimit }}
      cidrBlock: {{ .Values.network.vpcCIDR }}
    {{- if (eq .Values.network.vpcMode "private") }}
    subnets:
    {{- range $i, $subnet := .Values.network.subnets }}
    - cidrBlock: "{{ $subnet.cidrBlock }}"
      availabilityZone: "{{ include "aws-region" $ }}{{ add 97 $i | printf "%c" }}"
    {{- end -}}
    {{ end }}
  sshKeyName: ssh-key
  region: {{ include "aws-region" . }}
{{ end }}
