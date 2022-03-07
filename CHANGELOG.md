# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



## [Unreleased]

### Changed

- Upgrade to `vbeta1` version for all CRs.

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

[Unreleased]: https://github.com/giantswarm/cluster-aws/compare/v0.1.7...HEAD
[0.1.7]: https://github.com/giantswarm/cluster-aws/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/giantswarm/cluster-aws/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/giantswarm/cluster-aws/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/giantswarm/cluster-aws/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/giantswarm/cluster-aws/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/giantswarm/cluster-aws/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/giantswarm/cluster-aws/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/cluster-aws/releases/tag/v0.1.0
