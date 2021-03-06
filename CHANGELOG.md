# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/cluster-aws/compare/v0.4.1...HEAD
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
