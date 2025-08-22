# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Expose new `machinepool` values to configure the karpenter node pools:
    - `consolidateAfter`
    - `consolidationBudgets`
    - `consolidationPolicy`

### Removed

- Remove Helm chart that creates karpenter node pools, because they will be created by a kubernetes controller running in the management cluster.

### Changed

- Chart: Update `cluster` to v2.6.0.

## [3.6.0] - 2025-07-31

### Changed

- Chart: Update `cluster` to v2.5.0.

## [3.5.0] - 2025-07-30

### Added

- Add `giantswarm.io/role: nodes` by default to private subnets used for nodes. Can be overwritten.

### Changed

- Only deploy `node-termination-handler` when there are non-karpenter node pools because karpenter takes care of node draining
- Change `imageLookupFormat` to use a static string rather than CAPI replacing the OS and Kubernetes versions. This rolls control plane nodes.

### Fixed

- Use reduced IAM permissions on `karpenter` worker nodes instance profile. This can be toggled back with `global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers`.

## [3.4.0] - 2025-06-12

### Changed

- Reduce IMDS Response Hop Limit to 2 if pod networking is in ENI mode to increase security.

### Added

- Adopt IRSA infrastructure with Crossplane. It can be disabled to use IRSA Operator.
- Support multiple VPC CIDRs
- Add `karpenter` support
  - Expose new values to configure karpenter node pools.
  - Deploy `karpenter` app when `karpenter` node pools are configured.

## [3.3.0] - 2025-06-03

### Added

- Add `cert-manager-crossplane-resources` App in private clusters so `DNS01` `clusterIssuer`.
- Add configuration for `DNS01` `clusterIssuer` deployed by `cert-manager-app` in private clusters.
- Apply startup taint `ebs.csi.aws.com/agent-not-ready` for AWS EBS CSI driver on worker nodes.

### Changed

- Configure HelmReleases to retry indefinitely when installation or upgrade fails by setting retries: -1.
- Chart: Update `cluster` to v2.4.0.

## [3.2.2] - 2025-05-15

### Changed

- Chart: Update `cluster` to v2.2.1.

## [3.2.1] - 2025-03-19

### Added

- Add ingress rule in nodes Security Group to allow access for monitoring Chart Operator, EBS CSI Controller, Cilium Operator and Node Exporter.

## [3.2.0] - 2025-03-18

### Changed

- Chart: Update `cluster` to v2.2.0.

## [3.1.1] - 2025-03-07

### Added

- Add ingress rule in nodes Security Group to allow access to the Cilium Relay when using ENI mode.

## [3.1.0] - 2025-03-05

### Changed

- Chart: Update `cluster` to v2.1.1.
- Add option `global.providerSpecific.nodeTerminationHandlerEnabled` to disable the AWS Node Termination Handler (NTH).

## [3.0.0] - 2025-02-20

### Added

- Values: Add schema for `cilium-crossplane-resources`.

### Changed

- Scale down cilium-operator before deleting a cluster (only in eni mode)
- Chart: Update `cluster` to v2.0.1.
- Chart: Enable `coredns-extensions` and `etcd-defrag`.

## [2.6.1] - 2025-02-07

### Added

- Add ingress rule in nodes Security Group to allow access to the Kubelet API when using ENI mode. This is needed by the metrics server to gather metrics from the Kubelet

### Changed

- Cilium: Replace no longer supported `tunnel` option by `routingMode`.

## [2.6.0] - 2025-01-23

### Changed

- Chart: Reduce default etcd volume size to 50 GB.
- Explicitly set Ignition user data storage type to S3 bucket objects for machine pools
- Use reduced IAM permissions on worker nodes instance profile. This can be toggled back with `global.providerSpecific.reducedInstanceProfileIamPermissionsForWorkers`.

### Fixed

- Explicitly set aws-node-termination-handler queue region so crash-loops are avoided, allowing faster startup

## [2.5.0] - 2024-12-13

### Added

- Add aws-node-termination-handler bundle
- Values: Add `global.providerSpecific.controlPlaneAmi` & `global.providerSpecific.nodePoolAmi`.
- Make ASG lifecycle hook heartbeat timeout configurable

### Changed

- Chart: Update `cluster` to [v1.7.0](https://github.com/giantswarm/cluster/releases/tag/v1.7.0).
  - Add `teleport-init` systemd unit to handle initial token setup before `teleport` service starts
  - Improve `teleport` service reliability by adding proper file and service dependencies and pre-start checks

### Fixed

- Fix aws-nth-bundle to use the MC's kubeconfig context if it's in a different organization namespace.

  Workload clusters outside the MC's `org-giantswarm` namespace failed to deploy the bundle because `HelmRelease` does not allow specifying the MC's kubeconfig secret namespace. The bundle was therefore switched to an `App`.

## [2.4.0] - 2024-11-12

### Added

- Add `global.providerSpecific.additionalNodeTags`. Field used to specify tags applied to nodes only.

### Fixed

- Only try to render subnet tags if they are defined by the user.

## [2.3.0] - 2024-10-17

### Added

- Expose the `maxHealthyPercentage` property to allow setting the maximum percentage of healthy machines in the Auto Scaling Group during upgrades.

## [2.2.0] - 2024-09-23

### Added

- Allow to enable `auditd` through `global.components.auditd.enabled` helm value.
- Chart: Support multiple service account issuers.\
  This is used for example in the migration from Vintage AWS clusters to CAPA. Multiple issuers were previously supported only through internal chart values (this change removes `internal.migration.irsaAdditionalDomain`). The internal annotation `aws.giantswarm.io/irsa-additional-domain` on AWSMachineTemplate objects is changed to plural `aws.giantswarm.io/irsa-trust-domains` on the AWSCluster object.

### Changed

- Chart: Update `cluster` to v1.4.1.
- Set provider specific configuration for cilium CNI ENI values.

### Removed

- Remove Cilium app deprecated values.

## [2.1.0] - 2024-08-29

### ⚠️ Breaking change

- Do not allow additional properties in the following fields in order to avoid unnoticed typos:
  - global.connectivity.network
  - global.connectivity.network.pods
  - global.connectivity.network.services
  - global.connectivity.subnets[]
  - global.connectivity.topology
  - global.controlPlane
  - global.controlPlane.additionalSecurityGroups[]
  - global.controlPlane.machineHealthCheck
  - global.controlPlane.oidc
  - global.providerSpecific
  - global.providerSpecific.instanceMetadataOptions

### Changed

- Validate that machine pool availability zones belong to the selected region.
- CI: Bump release version.
- Apps: Use `catalog` from Release CR.

### Removed

- Remove unused kubectl image Helm value.

## [2.0.0] - 2024-08-07

> [!IMPORTANT]
> Releases that include this cluster-aws version must have the `os-tooling` component in the Release resource `.spec.components`,
> as well as observability-policies app in the Release resource `.spec.apps`.
>
> See `ami` changes below for more details about the change and see AWS (CAPA) release v29.0.0 for a Release resource example.

### Added

- Add `global.metadata.labels` to values schema. This field is used to add labels to the cluster resources.
- Enable `observability-policies` app.

### Changed

- Update cluster chart to v1.1.0.
  - This sets cilium `kubeProxyReplacement` config to `"true"` instead to `"strict"` (`"strict"` has been deprecated since cilium v1.14, see [this upstream cilium](https://github.com/cilium/cilium/issues/32711) issue for more details).
- Update `ami` named template to correctly render OS image name with the new format `flatcar-stable-<flatcar version>-kube-<kubernetes version>-tooling-<capi-image-builder version>-gs`.

## [1.3.0] - 2024-07-25

### Changed

- Update cluster chart version to v1.0.0. This update adds MC Zot deployment as a registry mirror for `gsoci.azurecr.io` registry. This is the new default behavior.

## [1.2.1] - 2024-07-22

### Changed

- Apps: Fix service monitor dependencies.

## [1.2.0] - 2024-07-22

This release removes the `CronJobTimeZone` feature gate as it becomes stable and is included in Kubernetes v1.29.

For Kubernetes <v1.29, you will need to re-enable it using the respective values.

### Changed

- Chart: Update `cluster` chart to v0.36.0. ([#703](https://github.com/giantswarm/cluster-aws/pull/703))

### Removed

- Feature Gates: Remove `CronJobTimeZone`. ([#699](https://github.com/giantswarm/cluster-aws/pull/699))

## [1.1.0] - 2024-07-11

### Changed

- Update cluster chart to 0.35.0

### Fixed

- Fixed China IRSA suffix

## [1.0.1] - 2024-07-09

### Added

- Add the Management Cluster name as a tag to the AWS resources created by CAPA.
- Add the node pool name as a tag to the AWS resources associated with the node pool.

### Changed

- Update cluster chart to 0.33.1

## [1.0.0] - 2024-06-20

### Changed

- First major release, breaking changes not allowed in minor releases anymore.

## [0.79.0] - 2024-06-19

### Changed

- Set maximum number of pods (kubelet `--max-pods`) for Cilium ENI mode due to restrictions by number of ENIs and IPs per ENI. This change will roll nodes even if not using Cilium ENI mode, since a new script is introduced.

## [0.78.2] - 2024-06-12

### Changed

- Update cluster chart to 0.31.4

## [0.78.1] - 2024-06-12

### Changed

- Update cluster chart to 0.31.2

## [0.78.0] - 2024-06-10

### Added

- Add `irsa-servicemonitors` and `aws-ebs-csi-driver-servicemonitors` apps.

### Changed

- Set `prometheus-blackbox-exporter` and `k8s-audit-metrics` as enabled.

## [0.77.0] - 2024-06-07

### Added

- Add configuration for `aws-pod-web-identity-webook` app to include region into the IRSA enabled pods.

## [0.76.2] - 2024-06-05

### Changed

- Set environment variable `COREOS_EC2_IPV4_LOCAL` to inject value to kubeadm configuration.
- Set environmane variable `COREOS_EC2_HOSTNAME` to inject value to kubeadm configuration.
- Update aws-cloud-controller-manager-app to v1.25.14-gs3.
- Update cluster chart to v0.27.0. More details in [cluster chart v0.27.0 release notes](https://github.com/giantswarm/cluster/releases/tag/v0.27.0).
- Always render `userConfig` values reference to configmap for `aws-pod-identity-webhook-app`.
- Store EC2 user data (Ignition config) for machine pools in S3 bucket to overcome the size limit (requires this new CAPA feature and `AWSMachinePool.spec.ignition` field)
- Update CAPA CR references to API version `v1beta2`

## [0.76.1] - 2024-05-16

### Changed

- Set token audience for `aws-pod-identity-webhook` based on AWS region.

## [0.76.0] - 2024-05-14

### ⚠️ Breaking change

- Update cluster chart to v0.25.0 and enable all default apps. More details in [cluster chart v0.25.0 release notes](https://github.com/giantswarm/cluster/releases/tag/v0.25.0).

Cluster upgrade steps are the following:
- Upgrade default-apps-aws App to v0.52.0 or newer.
- Update default-apps-aws Helm value `.Values.deleteOptions.moveAppsHelmOwnershipToClusterAws` to true.
  - All apps, except observability-bundle and security-bundle will get `app-operator.giantswarm.io/paused: true` annotation, so wait few minutes for the change to get applied by the Helm post-upgrade hook.
- Delete default-apps-aws.
  - App resources for all default apps will get deleted. Wait few minutes for this to happen.
  - Chart resources on the workload cluster will stay, so all apps will continue running.
- Upgrade cluster-aws App to v0.76.0.
  - cluster-aws will deploy all default apps, wait a few minutes for all Apps to be successfully deployed.
  - Chart resources on the workload cluster will get updated, as newly deployed App resources will take over the reconciliation of the existing Chart resources.

### Added

- Chart: Add `aws-pod-identity-webhook` app. ([#581](https://github.com/giantswarm/cluster-aws/pull/581)).

## [0.75.0] - 2024-05-09

### Added

- Worker nodes - Add `nonRootVolumes` fields to mount `/var/lib` and `/var/log` on separate disk volumes.
- BREAKING CHANGE: values `global.controlplane.containerdVolumeSizeGB` and `global.controlplane.kubeletVolumeSizeGB` merged into single value `.global.controlPlane.libVolumeSizeGB` which define size of disk volume used for `/var/lib` mount point.

### Changed

- Control-plane nodes - combine kubelet disk `/var/lib/kubelet` and containerd disk `/var/lib/containerd` into single disk `/var/lib` to share the volume space and save cost.

## [0.74.0] - 2024-05-08

### Fixed

- Added an annotation to Kubernetes resources to resolve an issue where deletion was stuck due to hanging load balancers.

### Added

- Make Cilium ENI-based IP allocation configurable with high-level `global.connectivity.cilium.ipamMode` value. This feature was previously introduced as prototype and is now fully working.
- Allow to configure SELinux mode through `global.components.selinux.mode` helm value.

### Changed

- Update cluster chart to v0.22.0.

## [0.73.0] - 2024-04-30

### Added

- Add `log` volume to control-plane nodes.

## [0.72.0] - 2024-04-24

### Added

- Add option to configure instance metadata http tokens for EC2 instances to enable or disable IMDSv2 enforcement.

## [0.71.0] - 2024-04-16

### Changed

- Update cluster chart to v0.18.0. This updates teleport node labels and will roll nodes.
- Update instanceWarmup to 10' to be on pair with Vintage
- Enable extraPolicies from network-policies-app.
- Disable and remove extraPolicies from cilium-app.
- Values: Separate `app` and `helmRelease` definition. ([#581](https://github.com/giantswarm/cluster-aws/pull/581))

## [0.70.0] - 2024-04-15

### Changed

- Update cluster chart to v0.17.0. This updates cilium app from v0.21.0 to v0.22.0.

### Fixed

- Update aws-ebs-csi-driver-app from v2.30.0 to v2.30.1. This fixes accidental installation of PSPs which could break the upgrade to previous `cluster-aws` versions which didn't have this fix yet.

## [0.69.0] - 2024-04-11

### Added

- Allow customizing instance refresh parameters.

### Fixed

- Fix selecting right AWS region for Machine Pools when cluster is in different AWS region than MC.

### Changed

- Update Availability Zones in helm/cluster-aws/files/azs-in-region.yaml
- AMI: Use new AMI which includes latest teleport binary v15.1.7

## [0.68.0] - 2024-03-27

### Changed

- Chart: Bump `cluster` to v0.16.0.

## [0.67.0] - 2024-03-26

### Added

- Smart defaulting for AWS availability zones using actual AZs in the region of choice rather than hardcoded values.

## [0.66.1] - 2024-03-21

### Fixed

- Update Chart.lock with current version of dependencies.

## [0.66.0] - 2024-03-21

### Added

- Make Cilium ENI-based IP allocation configurable with new high-level `global.connectivity.cilium.ipamMode` value (prototype)
- Add automatic support for deploying to AWS China.

### Changed

- Use cleanup hook job HelmRelease from cluster chart.
- Chart: Bump `cluster` to v0.13.0.

## [0.65.0] - 2024-03-07

### Fixed

- Pass `clusterID` to `aws-ebs-csi-driver` app's values for volume tagging purposes.

### Changed

- Change image lookup format for base OS image. osImageVariant is set to "2" for this kubernetes version. This is a **breaking change** that requires manual steps. For the next kubernetes versions, osImageVariant should not be set.

## [0.64.2] - 2024-03-06

### Changed

- Fix allow list API port 443.

## [0.64.1] - 2024-02-29

### Changed

- Chart: Bump `cluster` to v0.11.1.

## [0.64.0] - 2024-02-28

### Changed

- Chart: Bump `cluster` to v0.11.0.
- Use cilium and network-policies from cluster chart, and remove them from cluster-aws.

## [0.63.0] - 2024-02-22

### Changed

- Use default HelmRepositories from cluster chart.
- Use vertical-pod-autoscaler-crd HelmRelease from cluster chart.
- Use coredns HelmRelease from cluster chart.
- Remove default HelmRepositories from cluster-aws.
- Remove vertical-pod-autoscaler-crd HelmRelease from cluster-aws.
- Remove coredns HelmRelease from cluster-aws.

## [0.62.1] - 2024-02-19

### Fixed

- Update network-policies to avoid installing deny-all policy.

## [0.62.0] - 2024-02-14

### Added

- Add network-policies helm release.

## [0.61.0] - 2024-02-12

### Changed

- Render MachineHealthCheck resource from the cluster chart.
- Remove MachineHealthCheck resource.
- Render MachinePool and KubeadmConfig resources from the cluster chart.
- Remove MachinePool and KubeadmConfig resources.

### Fixed

- Remove duplicate containerd config as it's already deployed by the cluster chart.

## [0.60.1] - 2024-02-05

### Added

- Allow customers to specify optional extraConfigs in HelmRelease apps.
- Include cluster-test-catalog in the CI, so we can more easily test dev builds of subcharts.

### Changed

- Update cluster chart version to the latest v0.7.1 release.
- Render control plane resources from the cluster chart.
- Remove KubeadmControlPlane resource.
- Use `cluster.connectivity.proxy.noProxy` Helm template from cluster chart to render NO_PROXY in cluster-aws.
- Rename CI files, so they are used in GitHub action that checks Helm rendering.
- Remove ingress and egress rules from the security group that AWS creates by default when creating a new VPC.
- Remove unnecessary architect brackets cleanup.
- Use CI values to render templates locally.

## [0.60.0] - 2024-01-29

### Changed

- Bumped kubernetes version to 1.25.16. This change also enforces PSS.

## [0.59.1] - 2024-01-24

### Fixed

- Do not hardcode cilium k8s service port. Use `global.controlPlane.apiServerPort`.

## [0.59.0] - 2024-01-23

### Changed

- Use `gsoci.azurecr.io` for `kubeadm` container images.
- Use `gsoci.azurecr.io` for sandbox container image (pause container).
- Update `coredns` to `1.21.0` to use `gsoci.azurecr.io`.
- Update `aws-cloud-controller-manager` to `1.25.14-gs2` to use `gsoci.azurecr.io`.

## [0.58.0] - 2024-01-22

### Changed

- Bump cilium-app to v0.19.2 (upgrades Cilium to v1.14.5 and fixes a `CiliumNetworkPolicy` definition for reaching coredns)

### Fixed

- Fix removing allow-all Cilium network policies

## [0.57.0] - 2024-01-10

### Added

- Add propagating tags from `cluster-aws` to resources managed my `ebs-csi-driver`.
- CI: trigger automated e2e tests on Renovate PRs.
- Add new annotation for vintage irsa domain which is only used for migrating vintage clusters.
- Use 443 as the default api-server Load Balancer port.

### Changed

- Remove allow-all Cilium network policies.

## [0.56.0] - 2024-01-08

### Changed

- Add topology annotations to AWSCluster
- Add `cluster` chart as subchart.
- Render Cluster resource from the `cluster` chart.
- Delete Cluster resource template.
- Add missing kubelet configuration to align it with vintage config.

## [0.55.0] - 2023-12-21

### Fixed

- Change `KubeadmConfig` bootstrap config reference to ensure nodes get rolled when making changes to node specification (requires newer versions of CAPI/CAPA as shown in the original [issue](https://github.com/kubernetes-sigs/cluster-api/issues/8858)). Add machine pool instance warmup setting (5 minutes) to ensure nodes do not get replaced too quickly.
- Run kubeadm after containerd to avoid node startup problems

## [0.54.0] - 2023-12-21

### **Breaking change**

- Added option to customize app via configmap or secret with `global.apps.{app_name}.extraConfigs`.
- In-line custom values for app moved from `global.apps.{app_name}` to `global.apps.{app_name}.values`.

## [0.53.0] - 2023-12-13

### Changed

- Remove bastion and ssh configuration on nodes.

## [0.52.0] - 2023-12-11

### Fixed

- Set node pool subnet filters to include avaiability zone.
- Fix error messages if `global.connectivity.baseDomain` is missing

## [0.51.0] - 2023-12-07

### Changed

- Fill `AWSCluster.spec.network.subnets[*].id` field for managed subnets for compatibility with CAPA v2.3.0

## [0.50.0] - 2023-12-04

<details>
<summary>How to migrate to v0.50.0</summary>

Please ensure you did install [yq](https://mikefarah.gitbook.io/yq/) first.

To migrate values from cluster-aws `v0.50.0`, we provide below a bash script which writes an `app.yaml` file which you need to apply.
This will move the existing user config values into `global` and it also increases the `version` field of `cluster-aws` app to `v0.50.0`.

* Login to the management cluster and run the script (e.g: `./migrate.sh organization my-cluster`)
* Verify the `app.yaml` file and apply it to the management cluster (e.g: `kubectl apply -f app.yaml`)

```bash
#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]
  then
    echo "Incorrect number of arguments supplied. Please provide the organization name and the cluster name."
    exit 1
fi

# Use the first argument as the organization name and the second as the cluster name
org=$1
cluster=$2

# Fetch the ConfigMap YAML
kubectl get cm -n org-$org ${cluster}-userconfig -o yaml > ${cluster}_cm.yaml

# Extract the ConfigMap values into a temporary file
yq eval '.data.values' ${cluster}_cm.yaml > tmp_cm_values.yaml

##### OPTIONAL START

# Fetch AppCatalog YAML
kubectl get helmreleases.helm.toolkit.fluxcd.io -n flux-giantswarm appcatalog-cluster -o yaml > catalog.yaml

# Extract the AppCatalog values into a temporary file
yq eval '.spec.values.appCatalog.config.configMap.values' catalog.yaml >> tmp_cm_values.yaml

###### OPTIONAL END

# Modify the values in tmp_cm_values.yaml as needed
yq eval --inplace 'with(select(.metadata != null);    .global.metadata = .metadata) |
  with(select(.connectivity != null);                 .global.connectivity = .connectivity) |
  with(select(.controlPlane != null);                 .global.controlPlane = .controlPlane) |
  with(select(.nodePools != null);                    .global.nodePools = .nodePools) |
  with(select(.managementCluster != null);            .global.managementCluster = .managementCluster ) |

  with(select(.providerSpecific != null);                   .global.providerSpecific = .providerSpecific) |

  with(select(.baseDomain != null);                   .global.connectivity.baseDomain = .baseDomain) |
  with(select(.managementCluster != null);                 .global.managementCluster = .managementCluster) |

  del(.metadata) |
  del(.connectivity) |
  del(.controlPlane) |
  del(.nodePools) |
  del(.managementCluster) |
  del(.baseDomain) |
  del(.provider) |
  del(.providerSpecific)' tmp_cm_values.yaml


# Merge the modified values back into the ConfigMap YAML
yq eval-all 'select(fileIndex==0).data.values = select(fileIndex==1) | select(fileIndex==0)' ${cluster}_cm.yaml tmp_cm_values.yaml > app.yaml

## Multi-line
sed -i '' 's/values:/values: \|/g' app.yaml

# Fetch the App YAML
kubectl get app -n org-$org $cluster -o yaml > ${cluster}_app.yaml

## Update the version of the App YAML
yq eval --inplace 'with(select(.spec.version != null); .spec.version = "0.50.0")' ${cluster}_app.yaml

# Merge the App YAML and ConfigMap YAML
echo "---" >> app.yaml

cat ${cluster}_app.yaml >> app.yaml

# Clean up
rm ${cluster}_cm.yaml
rm tmp_cm_values.yaml
rm ${cluster}_app.yaml
rm catalog.yaml
```

</details>

### **Breaking change**

- Move Helm values property `.Values.metadata` to `.Values.global.metadata`.
- Move Helm values property `.Values.connectivity` to `.Values.global.connectivity`.
- Move Helm values property `.Values.controlPlane` to `.Values.global.controlPlane`.
- Move Helm values property `.Values.nodePools` to `.Values.global.nodePools`.
- Move Helm values property `.Values.managementCluster` to `.Values.global.managementCluster`.
- Move Helm values property `.Values.baseDomain` to `.Values.global.connectivity.baseDomain`.
- Move Helm values property `.Values.providerSpecific` to `.Values.global.providerSpecific`.
- Move Helm values property `.Values.global.connectivity.containerRegistries` to `.Values.global.components.containerd.containerRegistries`.

### Changed

- Bump the Kubernetes version to `v1.24.16`.
- Bump Teleport version to `v14.1.3`.
- Enable Teleport by default.

### Added

- Make Helm values configurable for aws-cloud-controller-manager, aws-ebs-csi-driver, cilium, coredns and vertical-pod-autoscaler-crd
- Expose value to configure launch template overrides, used to override the instance type specified by the launch template with multiple instance types that can be used to launch instances.

### Fixed

- Fixed issue when deleting node pools that would prevent the deletion, caused by the fact that `MachinePool` and `AWSMachinePool` CRs were annotated with `"helm.sh/resource-policy": keep`.

## [0.49.0] - 2023-11-23

### Changed

- Change schema validation allowing to add additional properties in `global`.
- Support longer node pool names and allow dashes.
- Bump cilium-app to v0.18.0 (upgrades Cilium to v1.14.3)

### Fixed

- Fix containerd config that was breaking in newer flatcar versions.

## [0.48.1] - 2023-11-13

### Fixed

- The value to configure the control plane load balancer ingress rules is filtered to avoid duplicates and to always contain GiantSwarm VPN IPs.

## [0.48.0] - 2023-11-13

### Added

- Add `global.metadata.preventDeletion` to add the [deletion prevention label](https://docs.giantswarm.io/advanced/deletion-prevention/) to cluster resources

## [0.47.0] - 2023-11-07

### Added

- Allow cluster-autoscaler handling MachinePools.
- Add additional tag for cluster autoscaler to MachinePool ASGs.
- Add option to force CGroups v1.

## [0.46.1] - 2023-11-01

### Added

- Allow configuration of `AWSCluster.spec.AdditionalTags` value and add a default giantswarm tag.

## [0.46.0] - 2023-10-24

### Fixed

- Move labels to AWSMachineTemplate manifest to avoid unnecessary rolling/no rolling.

### Added

- Add teleport.service: Secure SSH access via Teleport.
- Add `controlPlane.loadBalancerIngressAllowCidrBlocks` to configure control plane load balancer ingress rules.

### Changed

- Bump `coredns` version to `1.19.0` and fix values.

## [0.45.0] - 2023-10-04

### Added

- Add values neccessery for migration from vintage.

## [0.44.0] - 2023-09-28

### Fixed

- Make AWS instances names independent of helm label to prevent unnecessary rolling.

### Changed

- Align job that cleans `HelmReleases` and `HelmCharts` with other providers.

## [0.43.1] - 2023-09-27

### Fixed

- Revert to install default Cilium policies again. Some operators' "allow access to API nodes" `NetworkPolicy`s are not effective and Cilium first needs to be upgraded, including a recent upstream fix to the [known issue](https://github.com/cilium/cilium/issues/20550).

## [0.43.0] - 2023-09-27

### Removed

- Remove installation of Cilium policies that allow certain cluster traffic unconditionally (`defaultPolicies.enabled` in `cilium-app`). This is no longer necessary as all operators have been adapted with own network policies.

## [0.42.0] - 2023-09-21

### Removed

- Remove `connectivity.dns.mode` and `connectivity.dns.additionalVpc` properties due dropping support for private DNS.

## [0.41.0] - 2023-09-19

⚠️ When upgrading, please use v0.41.0 (_this release_) or newer. See our note on the breaking change in v0.38.4.

### Fixed

- Accept old service account issuer URI without `https://` prefix as well. This fixes the breaking change introduced in v0.38.4. Existing service account tokens, and the operators/applications using them, will keep working even before the tokens get rotated with the new service account issuer URI. When upgrading, it is recommended to skip earlier releases and immediately jump from v0.38.3 (or older) to _this one_.

## [0.40.0] - 2023-09-18

⚠️ When upgrading, please use v0.41.0 or newer. See our note on the breaking change in v0.38.4.

### Added

- Add support for Spot instances.

## [0.39.0] - 2023-09-12

⚠️ When upgrading, please use v0.41.0 or newer. See our note on the breaking change in v0.38.4.

### Added

- Support creating `CiliumNetworkPolicy` manifests that allow egress requests to DNS and conditionally the proxy host (via [`cilium-app`](https://github.com/giantswarm/cilium-app))

## [0.38.5] - 2023-09-12

⚠️ When upgrading, please use v0.41.0 or newer. See our note on the breaking change in v0.38.4.

### Changed

- Remove dependency between `cilium` and CPI so that `cilium` is installed as soon as possible.

## [0.38.4] - 2023-08-30

⚠️ We advise not to upgrade from v0.38.3 (or older) to v0.38.4. Please use v0.41.0 or newer which ensures that both the old and new service account issuer URIs are allowed (difference is only the `https://` prefix, which is a breaking change), avoiding that operators lose access to the Kubernetes API which could render the cluster unhealthy.

### Changed

- Add `https://` scheme prefix to service-account-issuer URI

## [0.38.3] - 2023-08-29

### Fixed

- Fix job that removes `HelmReleases` and `HelmCharts`.
- Delete `HelmReleases` and `HelmCharts` clean-up jobs when they are successful.

## [0.38.2] - 2023-08-29

### Fixed

- Delete all `HelmCharts` on the organization namespace that contain the cluster name on its name.

## [0.38.1] - 2023-08-25

### Changed

- Update kubernetes version to `1.24.14`.

## [0.38.0] - 2023-08-24

### Fixed

- Add always-required values to `noProxy` list for aws-cloud-controller-manager-app and aws-ebs-csi-driver-app (only relevant for private clusters with proxy)
- Forbid additional properties under `connectivity.proxy` to avoid typos

### Changed

- Use fixed alias CloudFront domain for IRSA
- Tolerate CAPI taints on uninitialized nodes when scheduling cilium relay and ui.

## [0.37.0] - 2023-07-19

### Changed

- Decrease `interval` on `HelmReleases` to make things more reactive.

### Fixed

- Fix RBAC for `HelmReleases` clean up job.

## [0.36.2] - 2023-07-12

### Fixed

- Specify `HelmChart` type when patching `HelmCharts` in job that removes finalizers.

## [0.36.1] - 2023-07-11

### Fixed

- Fix job that removes finalizers by dropping namespace from the `HelmChart` name when using it for patching.

## [0.36.0] - 2023-07-10

### Changed

- Remove finalizers from `HelmCharts` when removing this app to avoid leaving leftovers in the management cluster.

### Added

- Set value for `controller-manager` `terminated-pod-gc-threshold` to `125` ( consistent with vintage )

## [0.35.1] - 2023-06-29

## Fixed

- Fix defaulting of node pool for AWSCluster CR.

## [0.35.0] - 2023-06-28

### Added

- Add CNI/CSI/coredns apps as HelmReleases.

## [0.34.0] - 2023-06-21

### **Breaking change**
- Migrating from Ubuntu AMI to Flatcar AMI is a **breaking change** that requires manual steps.

### Changed

- Use CAPBK to provision bastion node with Flatcar AMI.
- Use CAPBK to provision control plane nodes with Flatcar AMI.
- Use CAPBK to provision worker nodes with Flatcar AMI.
- Migrating from Ubuntu AMI to Flatcar AMI is a **breaking change** that requires manual steps.
- Apply default OS setting for flatcar and os hardening.
- Update CAPA CRs API version from `v1beta1` to `v1beta2`.
- Values schema: disallow additional properties on the `.nodePools` object. This is a **breaking change** where node pool names are in use that do not match the pattern `^[a-z0-9]{5,10}$`.

## [0.33.0] - 2023-06-07

### Changed

**Note**: this release includes values schema changes which break compatibility with previous versions.

- Removed `connectivity.network.podCidr` and `connectivity.network.serviceCidr`. Replaced by `connectivity.network.pods.cidrBlocks` and `connectivity.network.services.cidrBlocks`.
- Remove `app.kubernetes.io/version` from common labels. They are part of hashes, but we don't want to always roll nodes just because we are deploying a new version.
- Remove `architect` templating from `Chart.yaml` file.
- Remove control plane replicas value `controlPlane.replicas`. Now it's hardcoded to 3 nodes.
- Set `r6i.xlarge` as the new default AWS instance type for the control plane and node pools.
- Added value `.metadata.servicePriority` to the schema to set the cluster's relative priority.
- Updated `cluster-shared` chart dependency to `0.6.5`

### Added

- Add JSON schema related makefile.
  - generate `values.yaml` from `values.schema.json` with `make generate-values`
  - normalize `values.schema.json` with `make normalize-schema`
  - validate that `values.schema.json` is according to requirements with `make validate-schema`
- Add full configuration values documentation.
- Add `"helm.sh/resource-policy": keep` annotation to AWSCluster,
  (AWS)MachineDeployments, (AWS)MachinePools and KubeadmControlPlane. The
  deletion of these resources has to be in order and must be handled by the
  CAPI and CAPA controllers.

## [0.32.1] - 2023-04-27

### Changed

- Moved the core components feature flags to their configuration, as the `featureGates` field is for `kubeadm` feature flags.

### Removed

- Remove `TTLAfterFinished` because it defaults to true.

## [0.32.0] - 2023-04-26

### Changed

- Enable `CronJobTimeZone` feature gate in the kubelet.
- Set kubernetes `1.24.10` as the default version.
- Switch from the in-tree cloud-controller-manager to the external one. This requires version `v0.26.0` of `default-apps-aws`.

### Removed

- Remove old JSON schema workflow.

## [0.31.0] - 2023-04-24

### Changed

- Rename `defaultMachinePools` to `internal.nodePools` to fit new schema requirements and make clear that it should not be changed by customers.
- Default to using `giantswarm.azurecr.io` as Docker Hub mirror.

### Fixed

- Remove duplicate label `cluster.x-k8s.io/cluster-name` in bastion MachineDeployment.

### Removed

- Remove `image-pull-progress-deadline` kubelet flag, as it's Docker only, and it's removed in k8s v1.24+.

## [0.30.0] - 2023-04-06

## Added

- Configure kubelet `ShutdownGracePeriod` to 5m and `ShutdownGracePeriodCriticalPods` to 1m. These options let `kubelet` prevent a node from shutting down until it has evicted all the pods from the node. The critical pods will be removed in the last 1m of the total 5m grace period and include pods with their priorityClassName set to system-cluster-critical or system-node-critical.
- Set default Node systemd logind `InhibitDelayMaxSec` to 5m.

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

[Unreleased]: https://github.com/giantswarm/cluster-aws/compare/v3.6.0...HEAD
[3.6.0]: https://github.com/giantswarm/cluster-aws/compare/v3.5.0...v3.6.0
[3.5.0]: https://github.com/giantswarm/cluster-aws/compare/v3.4.0...v3.5.0
[3.4.0]: https://github.com/giantswarm/cluster-aws/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/giantswarm/cluster-aws/compare/v3.2.2...v3.3.0
[3.2.2]: https://github.com/giantswarm/cluster-aws/compare/v3.2.1...v3.2.2
[3.2.1]: https://github.com/giantswarm/cluster-aws/compare/v3.2.0...v3.2.1
[3.2.0]: https://github.com/giantswarm/cluster-aws/compare/v3.1.1...v3.2.0
[3.1.1]: https://github.com/giantswarm/cluster-aws/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/giantswarm/cluster-aws/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/giantswarm/cluster-aws/compare/v2.6.1...v3.0.0
[2.6.1]: https://github.com/giantswarm/cluster-aws/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/giantswarm/cluster-aws/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/giantswarm/cluster-aws/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/giantswarm/cluster-aws/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/giantswarm/cluster-aws/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/giantswarm/cluster-aws/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/giantswarm/cluster-aws/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/giantswarm/cluster-aws/compare/v1.3.0...v2.0.0
[1.3.0]: https://github.com/giantswarm/cluster-aws/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/giantswarm/cluster-aws/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/giantswarm/cluster-aws/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/giantswarm/cluster-aws/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/giantswarm/cluster-aws/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/giantswarm/cluster-aws/compare/v0.79.0...v1.0.0
[0.79.0]: https://github.com/giantswarm/cluster-aws/compare/v0.78.2...v0.79.0
[0.78.2]: https://github.com/giantswarm/cluster-aws/compare/v0.78.1...v0.78.2
[0.78.1]: https://github.com/giantswarm/cluster-aws/compare/v0.78.0...v0.78.1
[0.78.0]: https://github.com/giantswarm/cluster-aws/compare/v0.77.0...v0.78.0
[0.77.0]: https://github.com/giantswarm/cluster-aws/compare/v0.76.2...v0.77.0
[0.76.2]: https://github.com/giantswarm/cluster-aws/compare/v0.76.1...v0.76.2
[0.76.1]: https://github.com/giantswarm/cluster-aws/compare/v0.76.0...v0.76.1
[0.76.0]: https://github.com/giantswarm/cluster-aws/compare/v0.75.0...v0.76.0
[0.75.0]: https://github.com/giantswarm/cluster-aws/compare/v0.74.0...v0.75.0
[0.74.0]: https://github.com/giantswarm/cluster-aws/compare/v0.73.0...v0.74.0
[0.73.0]: https://github.com/giantswarm/cluster-aws/compare/v0.72.0...v0.73.0
[0.72.0]: https://github.com/giantswarm/cluster-aws/compare/v0.71.0...v0.72.0
[0.71.0]: https://github.com/giantswarm/cluster-aws/compare/v0.70.0...v0.71.0
[0.70.0]: https://github.com/giantswarm/cluster-aws/compare/v0.69.0...v0.70.0
[0.69.0]: https://github.com/giantswarm/cluster-aws/compare/v0.68.0...v0.69.0
[0.68.0]: https://github.com/giantswarm/cluster-aws/compare/v0.67.0...v0.68.0
[0.67.0]: https://github.com/giantswarm/cluster-aws/compare/v0.66.1...v0.67.0
[0.66.1]: https://github.com/giantswarm/cluster-aws/compare/v0.66.0...v0.66.1
[0.66.0]: https://github.com/giantswarm/cluster-aws/compare/v0.65.0...v0.66.0
[0.65.0]: https://github.com/giantswarm/cluster-aws/compare/v0.64.2...v0.65.0
[0.64.2]: https://github.com/giantswarm/cluster-aws/compare/v0.64.1...v0.64.2
[0.64.1]: https://github.com/giantswarm/cluster-aws/compare/v0.64.0...v0.64.1
[0.64.0]: https://github.com/giantswarm/cluster-aws/compare/v0.63.0...v0.64.0
[0.63.0]: https://github.com/giantswarm/cluster-aws/compare/v0.62.1...v0.63.0
[0.62.1]: https://github.com/giantswarm/cluster-aws/compare/v0.62.0...v0.62.1
[0.62.0]: https://github.com/giantswarm/cluster-aws/compare/v0.61.0...v0.62.0
[0.61.0]: https://github.com/giantswarm/cluster-aws/compare/v0.60.1...v0.61.0
[0.60.1]: https://github.com/giantswarm/cluster-aws/compare/v0.60.0...v0.60.1
[0.60.0]: https://github.com/giantswarm/cluster-aws/compare/v0.59.1...v0.60.0
[0.59.1]: https://github.com/giantswarm/cluster-aws/compare/v0.59.0...v0.59.1
[0.59.0]: https://github.com/giantswarm/cluster-aws/compare/v0.58.0...v0.59.0
[0.58.0]: https://github.com/giantswarm/cluster-aws/compare/v0.57.0...v0.58.0
[0.57.0]: https://github.com/giantswarm/cluster-aws/compare/v0.56.0...v0.57.0
[0.56.0]: https://github.com/giantswarm/cluster-aws/compare/v0.55.0...v0.56.0
[0.55.0]: https://github.com/giantswarm/cluster-aws/compare/v0.54.0...v0.55.0
[0.54.0]: https://github.com/giantswarm/cluster-aws/compare/v0.53.0...v0.54.0
[0.53.0]: https://github.com/giantswarm/cluster-aws/compare/v0.52.0...v0.53.0
[0.52.0]: https://github.com/giantswarm/cluster-aws/compare/v0.51.0...v0.52.0
[0.51.0]: https://github.com/giantswarm/cluster-aws/compare/v0.50.0...v0.51.0
[0.50.0]: https://github.com/giantswarm/cluster-aws/compare/v0.49.0...v0.50.0
[0.49.0]: https://github.com/giantswarm/cluster-aws/compare/v0.48.1...v0.49.0
[0.48.1]: https://github.com/giantswarm/cluster-aws/compare/v0.48.0...v0.48.1
[0.48.0]: https://github.com/giantswarm/cluster-aws/compare/v0.47.0...v0.48.0
[0.47.0]: https://github.com/giantswarm/cluster-aws/compare/v0.46.1...v0.47.0
[0.46.1]: https://github.com/giantswarm/cluster-aws/compare/v0.46.0...v0.46.1
[0.46.0]: https://github.com/giantswarm/cluster-aws/compare/v0.45.0...v0.46.0
[0.45.0]: https://github.com/giantswarm/cluster-aws/compare/v0.44.0...v0.45.0
[0.44.0]: https://github.com/giantswarm/cluster-aws/compare/v0.43.1...v0.44.0
[0.43.1]: https://github.com/giantswarm/cluster-aws/compare/v0.43.0...v0.43.1
[0.43.0]: https://github.com/giantswarm/cluster-aws/compare/v0.42.0...v0.43.0
[0.42.0]: https://github.com/giantswarm/cluster-aws/compare/v0.41.0...v0.42.0
[0.41.0]: https://github.com/giantswarm/cluster-aws/compare/v0.40.0...v0.41.0
[0.40.0]: https://github.com/giantswarm/cluster-aws/compare/v0.39.0...v0.40.0
[0.39.0]: https://github.com/giantswarm/cluster-aws/compare/v0.38.5...v0.39.0
[0.38.5]: https://github.com/giantswarm/cluster-aws/compare/v0.38.4...v0.38.5
[0.38.4]: https://github.com/giantswarm/cluster-aws/compare/v0.38.3...v0.38.4
[0.38.3]: https://github.com/giantswarm/cluster-aws/compare/v0.38.2...v0.38.3
[0.38.2]: https://github.com/giantswarm/cluster-aws/compare/v0.38.1...v0.38.2
[0.38.1]: https://github.com/giantswarm/cluster-aws/compare/v0.38.0...v0.38.1
[0.38.0]: https://github.com/giantswarm/cluster-aws/compare/v0.37.0...v0.38.0
[0.37.0]: https://github.com/giantswarm/cluster-aws/compare/v0.36.2...v0.37.0
[0.36.2]: https://github.com/giantswarm/cluster-aws/compare/v0.36.1...v0.36.2
[0.36.1]: https://github.com/giantswarm/cluster-aws/compare/v0.36.0...v0.36.1
[0.36.0]: https://github.com/giantswarm/cluster-aws/compare/v0.35.1...v0.36.0
[0.35.1]: https://github.com/giantswarm/cluster-aws/compare/v0.35.0...v0.35.1
[0.35.0]: https://github.com/giantswarm/cluster-aws/compare/v0.34.0...v0.35.0
[0.34.0]: https://github.com/giantswarm/cluster-aws/compare/v0.33.0...v0.34.0
[0.33.0]: https://github.com/giantswarm/cluster-aws/compare/v0.32.1...v0.33.0
[0.32.1]: https://github.com/giantswarm/cluster-aws/compare/v0.32.0...v0.32.1
[0.32.0]: https://github.com/giantswarm/cluster-aws/compare/v0.31.0...v0.32.0
[0.31.0]: https://github.com/giantswarm/cluster-aws/compare/v0.30.0...v0.31.0
[0.30.0]: https://github.com/giantswarm/cluster-aws/compare/v0.29.1...v0.30.0
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
