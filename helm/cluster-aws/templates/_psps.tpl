{{- define "psps" }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "resource.default.name" $ }}-psps
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels.common" $ | nindent 4 }}
data:
  standard_psps.yml: |
    apiVersion: policy/v1beta1
    kind: PodSecurityPolicy
    metadata:
      name: privileged
      labels:
        {{- include "labels.common" $ | nindent 8 }}
      annotations:
        seccomp.security.alpha.kubernetes.io/allowedProfileNames: '*'
    spec:
      allowPrivilegeEscalation: true
      allowedCapabilities:
      - '*'
      fsGroup:
        rule: RunAsAny
      privileged: true
      runAsUser:
        rule: RunAsAny
      seLinux:
        rule: RunAsAny
      supplementalGroups:
        rule: RunAsAny
      volumes:
      - '*'
      hostPID: true
      hostIPC: true
      hostNetwork: true
      hostPorts:
      - min: 0
        max: 65536
    ---
    apiVersion: policy/v1beta1
    kind: PodSecurityPolicy
    metadata:
      name: restricted
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      privileged: false
      allowPrivilegeEscalation: false
      runAsUser:
        ranges:
          - max: 65535
            min: 1000
        rule: MustRunAs
      seLinux:
        rule: RunAsAny
      supplementalGroups:
        rule: 'MustRunAs'
        ranges:
          - min: 1
            max: 65535
      fsGroup:
        rule: 'MustRunAs'
        ranges:
          - min: 1
            max: 65535
      volumes:
      - 'secret'
      - 'configMap'
      hostPID: false
      hostIPC: false
      hostNetwork: false
      readOnlyRootFilesystem: false

  privileged_rbac.yml: |
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: privileged-psp-user
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    rules:
    - apiGroups:
      - extensions
      resources:
      - podsecuritypolicies
      resourceNames:
      - privileged
      verbs:
      - use
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: privileged-psp-users
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    subjects:
    - kind: ServiceAccount
      name: calico-node
      namespace: kube-system
    - kind: ServiceAccount
      name: calico-kube-controllers
      namespace: kube-system
    - kind: ServiceAccount
      name: kube-proxy
      namespace: kube-system
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: system:nodes
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: system:bootstrappers:kubeadm:default-node-token
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: privileged-psp-user
    ---

  restricted_rbac.yml: |
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: restricted-psp-user
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    rules:
    - apiGroups:
      - extensions
      resources:
      - podsecuritypolicies
      resourceNames:
      - restricted
      verbs:
      - use
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: restricted-psp-users
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    subjects:
    - kind: Group
      apiGroup: rbac.authorization.k8s.io
      name: system:authenticated
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: restricted-psp-user

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "resource.default.name" $ }}-coredns
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels.common" $ | nindent 4 }}
data:
  coredns.yml: |
    apiVersion: policy/v1beta1
    kind: PodSecurityPolicy
    metadata:
      name: coredns
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      privileged: false
      allowPrivilegeEscalation: false
      allowedCapabilities:
      - NET_BIND_SERVICE
      volumes:
        - 'configMap'
        - 'emptyDir'
        - 'projected'
        - 'secret'
        - 'downwardAPI'
      hostNetwork: false
      hostIPC: false
      hostPID: false
      runAsUser:
        rule: 'RunAsAny'
      seLinux:
        rule: 'RunAsAny'
      supplementalGroups:
        rule: 'MustRunAs'
        ranges:
          - min: 1
            max: 65535
      fsGroup:
        rule: 'MustRunAs'
        ranges:
          - min: 1
            max: 65535
      readOnlyRootFilesystem: false
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: coredns-psp-user
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    rules:
    - apiGroups:
      - extensions
      resources:
      - podsecuritypolicies
      resourceNames:
      - coredns
      verbs:
      - use
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: coredns-psp
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    subjects:
    - kind: ServiceAccount
      name: coredns
      namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: coredns-psp-user
      apiGroup: rbac.authorization.k8s.io
    ---
    kind: NetworkPolicy
    apiVersion: networking.k8s.io/v1
    metadata:
      namespace: kube-system
      name: coredns
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      podSelector:
        matchLabels:
          k8s-app: coredns
      ingress:
      - ports:
        - port: 1053
          protocol: UDP
        - port: 1053
          protocol: TCP
        - port: 53
          protocol: UDP
        - port: 53
          protocol: TCP
      - ports:
        - port: 9153
          protocol: TCP
      egress:
      - {}
      policyTypes:
      - Egress
      - Ingress
    ---

---

apiVersion: addons.cluster.x-k8s.io/v1beta1
kind: ClusterResourceSet
metadata:
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels.common" $ | nindent 4 }}
spec:
  clusterSelector:
    matchLabels:
      {{- include "labels.common" $ | nindent 6 }}
  resources:
  - kind: ConfigMap
    name: {{ include "resource.default.name" $ }}-psps
  - kind: ConfigMap
    name: {{ include "resource.default.name" $ }}-coredns
{{- end -}}
