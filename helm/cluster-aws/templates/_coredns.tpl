{{- define "coredns" }}
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
        app.kubernetes.io/managed-by: Helm
      annotations:
        meta.helm.sh/release-name: coredns
        meta.helm.sh/release-namespace: kube-system
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
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: coredns
      namespace: kube-system
      labels:
        {{- include "labels.common" $ | nindent 8 }}
        app.kubernetes.io/managed-by: Helm
      annotations:
        meta.helm.sh/release-name: coredns
        meta.helm.sh/release-namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: coredns-psp-user
      labels:
        {{- include "labels.common" $ | nindent 8 }}
        app.kubernetes.io/managed-by: Helm
      annotations:
        meta.helm.sh/release-name: coredns
        meta.helm.sh/release-namespace: kube-system
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
        app.kubernetes.io/managed-by: Helm
      annotations:
        meta.helm.sh/release-name: coredns
        meta.helm.sh/release-namespace: kube-system
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
        app.kubernetes.io/managed-by: Helm
      annotations:
        meta.helm.sh/release-name: coredns
        meta.helm.sh/release-namespace: kube-system
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
    apiVersion: policy/v1beta1
    kind: PodSecurityPolicy
    metadata:
      name: coredns-adopter
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      hostNetwork: true
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
      readOnlyRootFilesystem: false
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: coredns-adopter
      namespace: kube-system
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: coredns-adopter
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    rules:
    - apiGroups: ["*"]
      resources: ["*"]
      resourceNames: ["coredns", "kube-dns", "system:coredns"]
      verbs: ["get", "list", "update", "patch"]
    - apiGroups: [""]
      resources: ["services"]
      resourceNames: ["kube-dns"]
      verbs: ["delete"]
    - apiGroups: ["apps"]
      resources: ["deployments"]
      resourceNames: ["coredns"]
      verbs: ["delete"]
    - apiGroups: [""]
      resources: ["services"]
      verbs: ["create"]
    - apiGroups: ["extensions"]
      resources: ["podsecuritypolicies"]
      resourceNames: ["coredns-adopter"]
      verbs: ["use"]
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: coredns-adopter
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    subjects:
    - kind: ServiceAccount
      name: coredns-adopter
      namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: coredns-adopter
      apiGroup: rbac.authorization.k8s.io
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: coredns-adopter-rbac
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    subjects:
    - kind: ServiceAccount
      name: coredns-adopter
      namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: system:coredns
      apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: coredns-adopter
      namespace: kube-system
      labels:
        {{- include "labels.common" $ | nindent 8 }}
      annotations:
        kubernetes.io/description: |
          Runs at cluster creation to label and annotate default CoreDNS resources so they can be managed by Helm
    spec:
      template:
        metadata:
          name: coredns-adopter
          labels:
            {{- include "labels.common" $ | nindent 8 }}
        spec:
          restartPolicy: OnFailure
          serviceAccountName: coredns-adopter
          tolerations:
          - operator: Exists
          hostNetwork: true # No need to wait for CNI to be ready
          containers:
          - name: kubectl
            image: quay.io/giantswarm/kubectl:1.23.5
            command:
            - bash
            - -c
            - |
              sleep 60
              RESOURCES=(
                "configmap coredns"
                "serviceaccount coredns"
                "service kube-dns"
                "deployment coredns"
              )
              for RESOURCE in "${RESOURCES[@]}"
              do
                kubectl -n kube-system annotate --overwrite ${RESOURCE} meta.helm.sh/release-name=coredns
                kubectl -n kube-system annotate --overwrite ${RESOURCE} meta.helm.sh/release-namespace=kube-system
                kubectl -n kube-system label --overwrite ${RESOURCE} app.kubernetes.io/managed-by=Helm
              done

              RESOURCES=(
                "clusterrole system:coredns"
                "clusterrolebinding system:coredns"
              )
              for RESOURCE in "${RESOURCES[@]}"
              do
                kubectl annotate --overwrite ${RESOURCE} meta.helm.sh/release-name=coredns
                kubectl annotate --overwrite ${RESOURCE} meta.helm.sh/release-namespace=kube-system
                kubectl label --overwrite ${RESOURCE} app.kubernetes.io/managed-by=Helm
              done

              kubectl -n kube-system get service kube-dns -o yaml | sed 's/  name: kube-dns/  name: coredns/' > /tmp/svc.yaml
              kubectl -n kube-system delete service kube-dns
              kubectl apply -f /tmp/svc.yaml

              kubectl -n kube-system delete deployment coredns

---

{{- end -}}
