# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Make `karpenter-taint-remover` HelmRelease depend on `vertical-pod-autoscaler-crd` to ensure VPA CRDs are installed before deploying `karpenter-taint-remover`.

## [8.1.0] - 2026-03-19

### Changed

- Chart: Update `cluster` to v6.1.0.

## [8.0.0] - 2026-03-11

### Changed

- Chart: Update `cluster` to v6.0.0.

## [7.6.1] - 2026-03-11

### Fixed

- Set `appName` before `catalog` lookup in `aws-nth-app` template to ensure correct catalog resolution from Release CR.

## [7.6.0] - 2026-03-05

### Added

- Add `appVersion` field to `Chart.yaml`.
- Enable scraping metrics and logs from the karpenter app.
- Allow to configure the name of the hosted zone to use for the workload cluster by setting `global.connectivity.dns.hostedZoneName`.
- Allow to configure the AWS IAM Role to use when managing the DNS delegation for the hosted zone by setting `global.connectivity.dns.delegationIdentityName`.
- Added new annotation `network.giantswarm.io/base-domain` with the base domain value used for the workload cluster.
- Add support for `network.giantswarm.io/wildcard-cname-target` annotation on `AWSCluster` via `global.connectivity.dns.wildcardCnameTarget`.

### Changed

- Enable cert-manager DNS challenges by default.
- Chart: Update `cluster` to v5.3.1.

### Changed

- Reduced default karpenter consolidation from 6 hours to 1 hour.

## [7.5.0] - 2026-03-02

### Changed

- Chart: Update `cluster` to v5.3.0.
- Apps: Enable `rbac-bootstrap` as a default HelmRelease app.

## [7.4.0] - 2026-03-02

### Changed

- Values: Use container registries from `cluster` chart.
- Karpenter: Provide proxy configuration.
- AWS EBS CSI Driver & Karpenter: Reduce interval and enable drift detection.\
  This is required to have the bundles re-create the according apps after they get deleted due to renaming during upgrade.

## [7.3.0] - 2026-02-04

### Added

- Add JSON schema validation patterns for `global.providerSpecific.region`.
- Add JSON schema validation patterns for `global.providerSpecific.awsAccountId`.
- Add JSON schema validation patterns for `global.controlPlane.instanceType` and node pool `instanceType`.
- Add JSON schema `maxLength: 20` constraint for `global.metadata.name`, aligning with the constraint enforced by [our kyverno policies](https://github.com/giantswarm/kyverno-policies-ux/blob/main/policies/ux/cluster-names.yaml).

### Changed

- Install the `aws-ebs-csi-driver-bundle` that contains the `aws-ebs-csi-driver` app, together with the crossplane resources to manage the AWS IAM Roles required by the app.
- Install the `karpenter-bundle` that contains the `karpenter` app, together with the crossplane custom resources to manage the AWS resources required by `karpenter`.
- Use `cluster` chart values for Karpenter kubelet `systemReserved` and `kubeReserved`.

## [7.2.0] - 2026-01-22

### Added

- Support for new node pool `instanceType` field for Karpenter pools.

## [7.1.0] - 2026-01-09

### Added

- Add support for crossplane resources to manage the AWS IAM Role for `aws-ebs-csi-driver`.
- Add support for crossplane resources to manage the AWS IAM Role required by `karpenter`.

### Changed

- Require AWS account ID via `global.providerSpecific.awsAccountId`.
- Remove VPC peering configuration from worker node pools.

## [7.0.1] - 2025-12-06

### Fixed

- Fix cloud provider AWS configuration to pass list of additional node pools including Karpenter pools.

## [7.0.0] - 2025-12-05

### Added

- Deploy `karpenter-taint-remover` app for management clusters.

### Changed

- Rename `karpenter-taint-remover` to `capa-karpenter-taint-remover`.
- Chart: Update `cluster` to v5.2.0.

## [6.2.0] - 2025-11-28

### Changed

- Chart: Update `cluster` to v5.1.0.

## [6.1.0] - 2025-11-19

### Added

- karpenter: Enabled `podLogs` and `serviceMonitor`.

## [6.0.0] - 2025-11-06

### Added

- Add `global.podSecurityStandards.enforced` value to align with the `cluster` chart.

### Changed

- Chart: Update `cluster` to v5.0.0.

## [5.3.0] - 2025-10-09

### Changed

- Chart: Update `cluster` to v4.3.0.

## [5.2.0] - 2025-10-08

### Changed

- Chart: Update `cluster` to v4.2.0.

## [5.1.0] - 2025-09-11

### Changed

- Chart: Update `cluster` to v4.1.0.

## [5.0.0] - 2025-09-04

### Changed

- Chart: Update `cluster` to v4.0.0.

## [4.3.0] - 2025-08-14

### Added

- Add annotation `kubectl.kubernetes.io/last-applied-configuration` to CAPA AWSManagedMachinePool resource so that `kubectl apply` can safely update it in the future.

## [4.2.0] - 2025-08-12

### Added

- Add support for the `AWSManagedMachinePool` custom node role via `global.nodePools[*].customNodeRole`.

## [4.1.0] - 2025-07-08

### Changed

- Chart: Update `cluster` to v3.1.0.

## [4.0.0] - 2025-06-26

### Changed

- Chart: Update `cluster` to v3.0.0.

## [3.1.0] - 2025-06-10

### Changed

- Chart: Update `cluster` to v2.4.0.

## [3.0.0] - 2025-05-22

### Changed

- Chart: Update `cluster` to v2.3.0.

## [2.5.0] - 2025-05-15

### Changed

- Chart: Update `cluster` to v2.2.0.

## [2.4.0] - 2025-05-07

### Changed

- Chart: Update `cluster` to v2.1.0.

## [2.3.0] - 2025-04-17

### Changed

- Chart: Update `cluster` to v2.0.0.

## [2.2.0] - 2025-03-27

### Changed

- Chart: Update `cluster` to v1.8.0.

## [2.1.0] - 2025-02-19

### Changed

- Chart: Update `cluster` to v1.7.0.

## [2.0.0] - 2025-02-07

### Changed

- Chart: Update `cluster` to v1.6.0.

## [1.9.0] - 2025-01-23

### Changed

- Chart: Update `cluster` to v1.5.0.

## [1.8.0] - 2024-12-19

### Changed

- Chart: Update `cluster` to v1.4.0.

## [1.7.0] - 2024-12-05

### Changed

- Chart: Update `cluster` to v1.3.0.

## [1.6.0] - 2024-11-21

### Changed

- Chart: Update `cluster` to v1.2.0.

## [1.5.0] - 2024-10-31

### Changed

- Chart: Update `cluster` to v1.1.0.

## [1.4.0] - 2024-10-16

### Changed

- Chart: Update `cluster` to v1.0.0.

## [1.3.0] - 2024-10-01

### Added

- Karpenter: Add support for `--feature-gates=SpotToSpotConsolidation=true` feature flag, that allows consolidating spot nodes (disabled by default).

### Changed

- Chart: Update `cluster` to v0.32.0.

## [1.2.0] - 2024-09-16

### Added

- Add `karpenter-taint-remover` app that removes the uninitialized taint from Karpenter worker nodes.

### Changed

- Karpenter: Consolidate after 1 hour instead of never.
- Chart: Update `cluster` to v0.31.0.

## [1.1.1] - 2024-08-28

### Fixed

- Chart: Update `cluster` to v0.29.1 to fix irsa IAM role error in upgrade path.

## [1.1.0] - 2024-08-22

### Added

- Karpenter: Add support for `karpenter.k8s.aws/instance-category` and `karpenter.k8s.aws/instance-family` requirements.

### Changed

- Karpenter: Consolidate after 6 hours instead of never.
- Chart: Update `cluster` to v0.29.0.

## [1.0.0] - 2024-08-08

### Added

- Release `cluster-aws` as a standalone chart, no longer depending on `cluster-aws-app`.
