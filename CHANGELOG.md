# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Remove duplicate label ` cluster.x-k8s.io/cluster-name:` in bastion MachineDeployment

## [0.29.1] - 2023-04-03

### Fixed

- Fix rendering `oidc.pem` by mistake when not specified

## [0.29.0] - 2023-03-27

### Fixed

- Run machine pools and control plane nodes on private subnets.

## [0.28.0] - 2023-03-23

**Note**: this release includes values schema changes which break compatibility with previous versions.

<details>
<summary>How to migrate from v0.27.0</summary>

To migrate values from cluster-aws v0.27.0, we provide below [yq](https://mikefarah.gitbook.io/yq/) script, which assumes your values (not a ConfigMap!) are available in the file `values.yaml`. Note that the file will be overwritten.

Also be aware that if you were using `.aws.awsClusterRole` to specify a role in v0.27.0, this cannot be migrated automatically. Instead you have to make sure to have a [AWSClusterRoleIdentity](https://cluster-api-aws.sigs.k8s.io/topics/multitenancy.html#awsclusterroleidentity) resource in the management cluster which specifies the identity to use. The name of that resource then has to be specified as `.providerSpecific.awsClusterRoleIdentityName` in the new values for v.28.0.

```bash
yq eval --inplace '
  with(select(.ami != null);                                .providerSpecific.ami = .ami) |
  with(select(.aws.awsClusterRoleIdentityName != null);     .providerSpecific.awsClusterRoleIdentityName = .aws.awsClusterRoleIdentityName) |
  with(select(.aws.region != null);                         .providerSpecific.region = .aws.region) |
  with(select(.bastion != null);                            .connectivity.bastion = .bastion) |
  with(select(.clusterDescription != null);                 .metadata.description = .clusterDescription) |
  with(select(.clusterName != null);                        .metadata.name = .clusterName) |
  with(select(.flatcarAWSAccount != null);                  .providerSpecific.flatcarAwsAccount = .flatcarAWSAccount) |
  with(select(.hashSalt != null);                           .internal.hashSalt = .hashSalt) |
  with(select(.kubernetesVersion != null);                  .internal.kubernetesVersion = .kubernetesVersion) |
  with(select(.machinePools != null);                       .nodePools = .machinePools) |
  with(select(.network.apiMode != null);                    .controlPlane.apiMode = .network.apiMode) |
  with(select(.network.availabilityZoneUsageLimit != null); .connectivity.availabilityZoneUsageLimit = .network.availabilityZoneUsageLimit) |
  with(select(.network.dnsAssignAdditionalVPCs != null);    .connectivity.dns.additionalVpc = (.network.dnsAssignAdditionalVPCs | split(","))) |
  with(select(.network.dnsMode != null);                    .connectivity.dns.mode = .network.dnsMode) |
  with(select(.network.podCIDR != null);                    .connectivity.network.podCidr = .network.podCIDR) |
  with(select(.network.prefixListID != null);               .connectivity.topology.prefixListId = .network.prefixListID) |
  with(select(.network.resolverRulesOwnerAccount != null);  .connectivity.dns.resolverRulesOwnerAccount = .network.resolverRulesOwnerAccount) |
  with(select(.network.serviceCIDR != null);                .connectivity.network.serviceCidr = .network.serviceCIDR) |
  with(select(.network.subnets != null);                    .connectivity.subnets = .network.subnets) |
  with(select(.network.topologyMode != null);               .connectivity.topology.mode = .network.topologyMode) |
  with(select(.network.transitGatewayID != null);           .connectivity.topology.transitGatewayId = .network.transitGatewayID) |
  with(select(.network.vpcCIDR != null);                    .connectivity.network.vpcCidr = .network.vpcCIDR) |
  with(select(.network.vpcEndpointMode != null);            .connectivity.vpcEndpointMode = .network.vpcEndpointMode) |
  with(select(.network.vpcMode != null);                    .connectivity.vpcMode = .network.vpcMode) |
  with(select(.oidc != null);                               .controlPlane.oidc = .oidc) |
  with(select(.organization != null);                       .metadata.organization = .organization) |
  with(select(.proxy.enabled != null);                      .connectivity.proxy.enabled = .proxy.enabled) |
  with(select(.proxy.http_proxy != null);                   .connectivity.proxy.httpProxy = .proxy.http_proxy) |
  with(select(.proxy.https_proxy != null);                  .connectivity.proxy.httpsProxy = .proxy.https_proxy) |
  with(select(.proxy.no_proxy != null);                     .connectivity.proxy.noProxy = .proxy.no_proxy) |
  with(select(.sshSSOPublicKey != null);                    .connectivity.sshSsoPublicKey = .sshSSOPublicKey) |

  del(.ami) |
  del(.aws) |
  del(.bastion) |
  del(.clusterDescription) |
  del(.clusterName) |
  del(.flatcarAWSAccount) |
  del(.hashSalt) |
  del(.includeClusterResourceSet) |
  del(.kubernetesVersion) |
  del(.machinePools) |
  del(.network) |
  del(.oidc) |
  del(.organization) |
  del(.proxy) |
  del(.releaseVersion) |
  del(.sshSSOPublicKey)
' ./values.yaml
```

</details>

### Changed

- Values schema:
  - Added annotations
  - Applied normalization using `schemalint normalize`
  - Added property schema for /connectivity/containerRegistries
  - Added property schema for subnetTags objects
  - Added default values
  - Move /ami to /providerSpecific/ami
  - Move /awsClusterRoleIdentityName to /providerSpecific/awsClusterRoleIdentityName
  - Move /region to /providerSpecific/region
  - Move /flatcarAWSAccount to /providerSpecific/flatcarAwsAccount
  - Move /clusterName to /metadata/name
  - Move /clusterDescription to /medatada/description
  - Move /organization to /metadata/organization
  - Move /oidc to /controlPlane/oidc
  - Move /bastion to /connectivity/bastion
  - Move /network/serviceCIDR to /connectivity/network/serviceCidr
  - Move /network/podCIDR to /connectivity/network/podCidr
  - Move /proxy to /connectivity/proxy
    - Rename /proxy/no_proxy to /connectivity/proxy/noProxy
    - Rename /proxy/http_proxy to /connectivity/proxy/httpProxy
    - Rename /proxy/https_proxy to /connectivity/proxy/httpsProxy
  - Move /sshSSOPublicKey to /connectivity/sshSsoPublicKey
  - Remove unused /includeClusterResourceSet
  - Remove /aws/awsClusterRole (previously deprecated)
  - Move /hashSalt to /internal/hashSalt
  - Move /kubernetesVersion to /internal/kubernetesVersion
  - Move /network/dnsMode to /connectivity/dns/mode
  - Move /network/dnsAssignAdditionalVPCs to /connectivity/dns/additionalVpc and change to type array
  - Move /network/vpcCIDR to /connectivity/network/vpcCidr
  - Move /network/apiMode to /controlPlane/apiMode
  - Move /network/resolverRulesOwnerAccount to /connectivity/dns/resolverRulesOwnerAccount
  - Move /network/prefixListID to /connectivity/topology/prefixListId
  - Move /network/topologyMode to /connectivity/topology/mode
  - Move /network/transitGatewayID to /connectivity/topology/transitGatewayId
  - Move /network/vpcEndpointMode to /connectivity/vpcEndpointMode
  - Move /network/vpcMode to /connectivity/vpcMode
  - Move /network/availabilityZoneUsageLimit to /connectivity/availabilityZoneUsageLimit
  - Move /network/subnets to /connectivity/subnets
  - Rename /machinePools to /nodePools
  - Disallow additional properties on the root level

### Added

- Values schema:
  - Add /managementCluster and /provider to account for values injected by controllers.

### Fixed

- Use region defaulting wherever possible, removing `region` from schema.

## [0.27.0] - 2023-03-01

### Removed

- Remove unused `releaseVersion` setting from `values.yaml`.

## [0.26.0] - 2023-03-01

### Added

- Add `MachineHealthCheck` for control plane nodes.

### Changed

- Fail in Helm template if `dnsMode=public` is combined with a `baseDomain` ending with `.internal`.

## [0.25.1] - 2023-02-16

### Fixed

- Quote bastion subnet tag filters in order to avoid type conversion errors.

## [0.25.0] - 2023-02-16

### Breaking Change

- Replaced `registry` parameter  to `connectivity.containerRegistries` in the values schema.

### Fixed

- Quote subnet tag filters in order to avoid type conversion errors.

### Added

- Made registry configurations `connectivity.containerRegistries` dynamic to accept as many container registries and mirrors as needed.
- Expose helm value for customers to decide whether VPC endpoint should be created by Giantswarm.

### Changed

- Set `/var/lib/kubelet` permissions to `0750` to fix `node-exporter` issue.

## [0.24.1] - 2023-02-07

### Added

- Customize tags per individual subnet.

## [0.24.0] - 2023-02-02

### Breaking Change

- Use object for `.machinePools` schema instead of array. This is to make it easier to overwrite values when using GitOps. For migration steps see the "Upgrading to `v0.24.0`" section in the readme.

## [0.23.0] - 2023-02-01

### Added

- Add value to specify which AWS account ID to use when associating Route53 Resolver Rules with workload cluster VPC.

## [0.22.0] - 2023-01-24

### Changed

- Bump kubernetes version to `1.23.16`

## [0.21.0] - 2023-01-19

### Breaking Change

- For private clusters, where `network.vpcMode` is set to `private`, the subnets property has changed. Instead of previously being a list of CIDR strings the property now include a more complex object providing more configuration options. For migration steps see the "Upgrading to `v0.21.0`" section in the readme.

### Added

- More configuration options when defining subnets to be created
- `controlPlane.subnetTags`, `bastion.subnetTags` and `machinePools[].subnetTags` to target specific subnets
- Add icon to Chart.yaml

### Changed

- Subnets are now specified on the `AWSCluster` resource by default rather than relying on CAPA code to default them. The same sizing as the CAPA default have been used.

## [0.20.7] - 2023-01-12

### Changed

- Use Giant Swarm image repository for official Kubernetes images

## [0.20.6] - 2023-01-11

### Added

- Add and propagate `no_proxy` value to the underlying components.

## [0.20.5] - 2023-01-11

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

[Unreleased]: https://github.com/giantswarm/cluster-aws/compare/v0.29.1...HEAD
[0.29.1]: https://github.com/giantswarm/cluster-aws/compare/v0.29.0...v0.29.1
[0.29.0]: https://github.com/giantswarm/cluster-aws/compare/v0.28.0...v0.29.0
[0.28.0]: https://github.com/giantswarm/cluster-aws/compare/v0.27.0...v0.28.0
[0.27.0]: https://github.com/giantswarm/cluster-aws/compare/v0.26.0...v0.27.0
[0.26.0]: https://github.com/giantswarm/cluster-aws/compare/v0.25.1...v0.26.0
[0.25.1]: https://github.com/giantswarm/cluster-aws/compare/v0.25.0...v0.25.1
[0.25.0]: https://github.com/giantswarm/cluster-aws/compare/v0.24.1...v0.25.0
[0.24.1]: https://github.com/giantswarm/cluster-aws/compare/v0.24.0...v0.24.1
[0.24.0]: https://github.com/giantswarm/cluster-aws/compare/v0.23.0...v0.24.0
[0.23.0]: https://github.com/giantswarm/cluster-aws/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/giantswarm/cluster-aws/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/giantswarm/cluster-aws/compare/v0.20.7...v0.21.0
[0.20.7]: https://github.com/giantswarm/cluster-aws/compare/v0.20.6...v0.20.7
[0.20.6]: https://github.com/giantswarm/cluster-aws/compare/v0.20.5...v0.20.6
[0.20.5]: https://github.com/giantswarm/cluster-aws/compare/v0.20.4...v0.20.5
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
