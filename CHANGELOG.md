# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Override image repository to `registry.k8s.io` because kubeadm of Kubernetes v1.23.15 tries to pull the official image incorrectly, resulting in failing cluster upgrades, and `k8s.gcr.io` is outdated

## [0.20.4] - 2023-01-05

### Changed

- Change default NTP server as AWS NTP server.
- Deprecate confusingly named `aws.awsClusterRole` in favor of `aws.awsClusterRoleIdentityName`. The value refers to an `AWSClusterRoleIdentity` object, not directly to an IAM role name/ARN.
- Bump Kubernetes to 1.23.15

## [0.20.3] - 2022-12-22

### Added

- Add cluster base domain to no proxy config.

## [0.20.2] - 2022-12-09

### Changed

- Dowgrade to using Ubuntu 20.04 as base OS.
- Run bastion on private IP if vpc mode is set to private.
- Remove registry authetication workaround.

## [0.20.1] - 2022-12-07

## [0.20.0] - 2022-12-06

### Added

- Add schema for items of the arrays `.machinePools[*].availabilityZones` and `.machinePools[*].customNodeTaints`.
- Add IRSA domain placeholder replacer as postKubeadm script.
- Add `containerd` registry auth workaround to bug https://github.com/giantswarm/roadmap/issues/1737.

## [0.19.0] - 2022-11-29

### Added

- Add option to specify oidc CA PEM in order to autheticate againts OIDC with custom CA.
- Add option to configure containerd registry authentication for `docker.io`.

## [0.18.0] - 2022-11-24

### Added

- Add external resource gc annotation.

### Fixed

- Change sed to fix replacement for Cloudfront placeholder.
- Added missing prefixListID for UserManaged network topology

### Changed

- Make `baseDomain` a required value.

## [0.17.1] - 2022-11-22

### Fixed

- Add `https://` for IRSA service account issuer.

## [0.17.0] - 2022-11-18

### Added

- Add full proxy configuration for private clusters.

## [0.16.1] - 2022-11-15

### Changed

- Allow scraping of k8s core components.
- Bump external-dns to latest release

## [0.16.0] - 2022-11-10

### Changed

- Make `kubeadm` skip the phase where it installs `coredns` as it will be installed by as a default app.

## [0.15.2] - 2022-11-08

### Fixed

- Bumped cluster-shared to latest with coredns-adopter apiserver polling

## [0.15.1] - 2022-11-07

### Fixed

- Handle default values in worker machine pool values

## [0.15.0] - 2022-11-07

### Added

- Support setting node taints using `customNodeTaints`

## [0.14.0] - 2022-11-03

### Changed

- Bumped Kubernetes to v1.23

### Fixed

- Immutable AWSMachineTemplate

## [0.13.2] - 2022-11-03

### Fixed

- Ensure the `KubeadmControlPlane` `.spec.version` value is always prefixed with `v`

## [0.13.1] - 2022-10-27

### Fixed

- Add the missing `api-audiences` attribute to the `KubeadmControlPlane` template, to fix the use of IRSA service account tokens.

### Changed

- Update [cluster-shared](https://github.com/giantswarm/cluster-shared) from v0.3.0 to v0.6.3.

## [0.13.0] - 2022-10-19

### Changed

- Make `kubeadm` skip the phase where it installs `kube-proxy` as we will use `cilium` as a replacement.

## [0.12.0] - 2022-10-14

### Added

- IRSA for CAPA.
- Make subnets configurable.

### Fixed

- Re-added Ubuntu 22.04 with correct lookup

### Changed

- Enable tcp forwarding for sshd on bastion.

## [0.11.1] - 2022-10-14

### Fixed

- Rolled back to Ubuntu 20.04

## [0.11.0] - 2022-10-14

### Added

- Set `aws.giantswarm.io/vpc-mode` annotation on AWSCluster.
- Set cluster to paused when vpcMode is set to private.

### Changed

- Updated to Kubernetes 1.22.15
- Updated to using Ubuntu 22.04 as base OS

## [0.10.0] - 2022-10-04

### Changed

- `.Values.controlPlane.apiLoadbalancerScheme` has been removed in favour of `.Values.network.apiMode`

### Added

- Support for specifying private VPC configuration (not yet used)
- Support for specifying private DNS zone configuration.
- Validation of vpcMode and apiMode combination being valid

## [0.9.2] - 2022-09-16

### Changed

- Default network topology mode changed to 'None'

## [0.9.1] - 2022-09-06

### Fixed

- Fix helm context for proxy helper function.

## [0.9.0] - 2022-09-06

### Added

- Add support for configuring outgoing proxy for the cluster.
- Allow configuration of loadbalancer for Control Plane API (`internet-facing` will be default).

## [0.8.7] - 2022-08-26

### Fixed

- Improved hash function to hash based on whole `.Spec` rather than just provided values

## [0.8.6] - 2022-08-23

### Fixed

- AZ list rendering

## [0.8.5] - 2022-08-17

### Added

- Network topology mode annotations
- Add role label to bastion machine.

## [0.8.4] - 2022-08-17

### Fixed

- Ensure availability zone restrictions are added to the subnet filters

## [0.8.3] - 2022-08-15

### Fixed

- Fix subnet filter to relevant with `tag:` prefix.

## [0.8.1] - 2022-08-15

### Fixed

- Limit subnet filter to relevant, cluster owned, subnets

## [0.8.0] - 2022-08-15

### Added

- `hash` function to ensure immutable resources change be changed via recreate/replacement

## [0.7.4] - 2022-08-11

## [0.7.3] - 2022-08-11

### Fixed

- Ensure worker nodes are only launched in private subnets

## [0.7.2] - 2022-08-11

### Added

- Add OIDC support for k8s api.

## [0.7.1] - 2022-08-09

### Fixed

- Added the OS version to the imageLookupBaseOS

## [0.7.0] - 2022-08-09

### Changed

- Use our Giant Swarm built AMIs
- Bump default Kubernetes version to 1.22.12

## [0.6.2] - 2022-08-06

### Fixed

- Fixed app version label.

## [0.6.1] - 2022-08-03

### Added

- Add `localhost` and `api` domain to the certSANs of apiserver certificates.

## [0.6.0] - 2022-07-28

### Removed

- `replicas` value from `controlPlane` no longer configurable - always set to 3 for HA

## [0.5.2] - 2022-07-26

### Fixed

- Quoted boolean to a string

## [0.5.1] - 2022-07-26

### Fixed

- Pod CIDR as array rather than string

## [0.5.0] - 2022-07-26

### Changed

- Set pod CIDR to 100.64.0.0/12 to match what we set in Cilium (and to not clash with AWS CIDR)

## [0.4.2] - 2022-07-25

### Changed

- Fix values schema.
- Make bastion optional.

## [0.4.1] - 2022-07-15

### Changed

- Add team label to helm resources.
- Add `values.schema.json` file.
- Remove helm lookup function for SSH CA cert and use value fro central vault instead.

## [0.4.0] - 2022-04-14

### Changed

- Updated to latest `cluster-shared` library chart

### Added

- Support for specifying the `clusterName` (defaults to chart release name)

## [0.3.0] - 2022-04-12

### Changed

- Switched to using `cluster-shared` for PSPs and coredns-adopter

## [0.2.1] - 2022-03-31

### Added

- Lookup AWS region if not set in values
- Lookup AWS Availability Zones if not set in values

## [0.2.0] - 2022-03-29

- Allow app platform to take over managing coredns

## [0.1.14] - 2022-03-22

## [0.1.13] - 2022-03-21

- Rename `networkSpec` to `network` in AWSCluster CR due renaming in `v1beta1`.

## [0.1.12] - 2022-03-18

- Prefix machine pool with cluster id.
- Set etcd max db size to 8 GB.
- Add encryption provider config for k8s secrets.

## [0.1.11] - 2022-03-15

- Add `audit-policy` to kubernetes api.
- Fix AWSMachinePool min and max values.

## [0.1.10] - 2022-03-09

## [0.1.9] - 2022-03-07

### Changed

- Upgrade to `vbeta1` version for all CRs.
-
## [0.1.8] - 2022-03-07

## [0.1.7] - 2022-03-07

## [0.1.6] - 2022-03-07

## [0.1.5] - 2022-03-04

### Removed

- Remove `AWSClusterRole` CR from the repository to prevent deletion of the role before the cluster is deleted.

## [0.1.4] - 2022-03-03

### Added

- Add labels to machine metadata to `AWSMachineTemplate` CRs.

## [0.1.3] - 2022-03-02

### Added

- Add `sourceIdenityRef` to AWSClusterRoleIdentity CR.

## [0.1.2] - 2022-02-25

## Fixed

- Fix aws cluster role identity value reference.

## [0.1.1] - 2022-02-25

### Fixed

- Fix bastion secret.

## [0.1.0] - 2022-02-25

[Unreleased]: https://github.com/giantswarm/cluster-aws/compare/v0.20.4...HEAD
[0.20.4]: https://github.com/giantswarm/cluster-aws/compare/v0.20.3...v0.20.4
[0.20.3]: https://github.com/giantswarm/cluster-aws/compare/v0.20.2...v0.20.3
[0.20.2]: https://github.com/giantswarm/cluster-aws/compare/v0.20.1...v0.20.2
[0.20.1]: https://github.com/giantswarm/cluster-aws/compare/v0.20.0...v0.20.1
[0.20.0]: https://github.com/giantswarm/cluster-aws/compare/v0.19.0...v0.20.0
[0.19.0]: https://github.com/giantswarm/cluster-aws/compare/v0.18.0...v0.19.0
[0.18.0]: https://github.com/giantswarm/cluster-aws/compare/v0.17.1...v0.18.0
[0.17.1]: https://github.com/giantswarm/cluster-aws/compare/v0.17.0...v0.17.1
[0.17.0]: https://github.com/giantswarm/cluster-aws/compare/v0.16.1...v0.17.0
[0.16.1]: https://github.com/giantswarm/cluster-aws/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/giantswarm/cluster-aws/compare/v0.15.2...v0.16.0
[0.15.2]: https://github.com/giantswarm/cluster-aws/compare/v0.15.1...v0.15.2
[0.15.1]: https://github.com/giantswarm/cluster-aws/compare/v0.15.0...v0.15.1
[0.15.0]: https://github.com/giantswarm/cluster-aws/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/giantswarm/cluster-aws/compare/v0.13.2...v0.14.0
[0.13.2]: https://github.com/giantswarm/cluster-aws/compare/v0.13.1...v0.13.2
[0.13.1]: https://github.com/giantswarm/cluster-aws/compare/v0.13.0...v0.13.1
[0.13.0]: https://github.com/giantswarm/cluster-aws/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/giantswarm/cluster-aws/compare/v0.11.1...v0.12.0
[0.11.1]: https://github.com/giantswarm/cluster-aws/compare/v0.11.0...v0.11.1
[0.11.0]: https://github.com/giantswarm/cluster-aws/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/giantswarm/cluster-aws/compare/v0.9.2...v0.10.0
[0.9.2]: https://github.com/giantswarm/cluster-aws/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/giantswarm/cluster-aws/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/giantswarm/cluster-aws/compare/v0.8.7...v0.9.0
[0.8.7]: https://github.com/giantswarm/cluster-aws/compare/v0.8.6...v0.8.7
[0.8.6]: https://github.com/giantswarm/cluster-aws/compare/v0.8.5...v0.8.6
[0.8.5]: https://github.com/giantswarm/cluster-aws/compare/v0.8.4...v0.8.5
[0.8.4]: https://github.com/giantswarm/cluster-aws/compare/v0.8.3...v0.8.4
[0.8.3]: https://github.com/giantswarm/cluster-aws/compare/v0.8.1...v0.8.3
[0.8.1]: https://github.com/giantswarm/cluster-aws/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/giantswarm/cluster-aws/compare/v0.7.4...v0.8.0
[0.7.4]: https://github.com/giantswarm/cluster-aws/compare/v0.7.3...v0.7.4
[0.7.3]: https://github.com/giantswarm/cluster-aws/compare/v0.7.2...v0.7.3
[0.7.2]: https://github.com/giantswarm/cluster-aws/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/giantswarm/cluster-aws/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/giantswarm/cluster-aws/compare/v0.6.2...v0.7.0
[0.6.2]: https://github.com/giantswarm/cluster-aws/compare/v0.6.1...v0.6.2
[0.6.1]: https://github.com/giantswarm/cluster-aws/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/giantswarm/cluster-aws/compare/v0.5.2...v0.6.0
[0.5.2]: https://github.com/giantswarm/cluster-aws/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/giantswarm/cluster-aws/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/giantswarm/cluster-aws/compare/v0.4.2...v0.5.0
[0.4.2]: https://github.com/giantswarm/cluster-aws/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/giantswarm/cluster-aws/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/giantswarm/cluster-aws/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/giantswarm/cluster-aws/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/giantswarm/cluster-aws/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/cluster-aws/compare/v0.1.14...v0.2.0
[0.1.14]: https://github.com/giantswarm/cluster-aws/compare/v0.1.13...v0.1.14
[0.1.13]: https://github.com/giantswarm/cluster-aws/compare/v0.1.12...v0.1.13
[0.1.12]: https://github.com/giantswarm/cluster-aws/compare/v0.1.11...v0.1.12
[0.1.11]: https://github.com/giantswarm/cluster-aws/compare/v0.1.10...v0.1.11
[0.1.10]: https://github.com/giantswarm/cluster-aws/compare/v0.1.9...v0.1.10
[0.1.9]: https://github.com/giantswarm/cluster-aws/compare/v0.1.8...v0.1.9
[0.1.8]: https://github.com/giantswarm/cluster-aws/compare/v0.1.7...v0.1.8
[0.1.7]: https://github.com/giantswarm/cluster-aws/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/giantswarm/cluster-aws/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/giantswarm/cluster-aws/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/giantswarm/cluster-aws/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/giantswarm/cluster-aws/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/giantswarm/cluster-aws/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/giantswarm/cluster-aws/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/cluster-aws/releases/tag/v0.1.0
