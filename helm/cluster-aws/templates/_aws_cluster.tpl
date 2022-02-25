{{- define "aws-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha3
kind: AWSCluster
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  bastion:
    enabled: false
  identityRef:
    kind: AWSClusterRoleIdentity
    name: {{ include "resource.default.name" $ }}
  networkSpec:
    cni:
      cniIngressRules:
      - description: allow cni traffic across nodes and control plane
        fromPort: -1
        protocol: "-1"
        toPort: -1
      vpc:
        availabilityZoneUsageLimit: {{ .Values.network.availabilityZoneUsageLimit }}
        cidrBlock: {{ .Values.network.vpcCIDR }}
  sshKeyName: ssh-key
  region: {{ .Values.aws.region }}
{{ end }}
