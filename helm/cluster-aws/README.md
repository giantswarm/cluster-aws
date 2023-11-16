# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-aws version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-aws/values.schema.json -o helm/cluster-aws/README.md

-->

<!-- DOCS_START -->

### AWS settings
Properties within the `.providerSpecific` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `providerSpecific.additionalResourceTags` | **Additional resource tags** - Additional tags to add to AWS resources created by the cluster.|**Type:** `object`<br/>|
| `providerSpecific.additionalResourceTags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `providerSpecific.ami` | **Amazon machine image (AMI)** - If specified, this image will be used to provision EC2 instances.|**Type:** `string`<br/>|
| `providerSpecific.awsClusterRoleIdentityName` | **Cluster role identity name** - Name of an AWSClusterRoleIdentity object. This in turn refers to the IAM role used to create all AWS cloud resources when creating the cluster. The role can be in another AWS account in order to create all resources in that account. Note: This name does not refer directly to an IAM role name/ARN.|**Type:** `string`<br/>**Value pattern:** `^[-a-zA-Z0-9_\.]{1,63}$`<br/>**Default:** `"default"`|
| `providerSpecific.flatcarAwsAccount` | **AWS account owning Flatcar image** - AWS account ID owning the Flatcar Container Linux AMI.|**Type:** `string`<br/>**Default:** `"706635527432"`|
| `providerSpecific.region` | **Region**|**Type:** `string`<br/>|

### Connectivity
Properties within the `.global.connectivity` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.connectivity.availabilityZoneUsageLimit` | **Availability zones** - Maximum number of availability zones (AZ) that should be used in a region. If a region has more than this number of AZs then this number of AZs will be picked randomly when creating subnets.|**Type:** `integer`<br/>**Default:** `3`|
| `global.connectivity.bastion` | **Bastion host**|**Type:** `object`<br/>|
| `global.connectivity.bastion.enabled` | **Enable**|**Type:** `boolean`<br/>**Default:** `true`|
| `global.connectivity.bastion.instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Default:** `"t3.small"`|
| `global.connectivity.bastion.replicas` | **Number of hosts**|**Type:** `integer`<br/>**Default:** `1`|
| `global.connectivity.bastion.subnetTags` | **Subnet tags** - Tags to filter which AWS subnets will be used for the bastion hosts.|**Type:** `array`<br/>|
| `global.connectivity.bastion.subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>|
| `global.connectivity.bastion.subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.containerRegistries` | **Container registries** - Endpoints and credentials configuration for container registries.|**Type:** `object`<br/>**Default:** `{"docker.io":[{"endpoint":"registry-1.docker.io"},{"endpoint":"giantswarm.azurecr.io"}]}`|
| `global.connectivity.containerRegistries.*` | **Registries** - Container registries and mirrors|**Type:** `array`<br/>|
| `global.connectivity.containerRegistries.*[*]` | **Registry**|**Type:** `object`<br/>|
| `global.connectivity.containerRegistries.*[*].credentials` | **Credentials**|**Type:** `object`<br/>|
| `global.connectivity.containerRegistries.*[*].credentials.auth` | **Auth** - Base64-encoded string from the concatenation of the username, a colon, and the password.|**Type:** `string`<br/>|
| `global.connectivity.containerRegistries.*[*].credentials.identitytoken` | **Identity token** - Used to authenticate the user and obtain an access token for the registry.|**Type:** `string`<br/>|
| `global.connectivity.containerRegistries.*[*].credentials.password` | **Password** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.connectivity.containerRegistries.*[*].credentials.username` | **Username** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.connectivity.containerRegistries.*[*].endpoint` | **Endpoint** - Endpoint for the container registry.|**Type:** `string`<br/>|
| `global.connectivity.dns` | **DNS**|**Type:** `object`<br/>|
| `global.connectivity.dns.resolverRulesOwnerAccount` | **Resolver rules owner** - ID of the AWS account that created the resolver rules to be associated with the workload cluster VPC.|**Type:** `string`<br/>|
| `global.connectivity.network` | **Network**|**Type:** `object`<br/>|
| `global.connectivity.network.internetGatewayId` | **Internet Gateway ID** - ID of the Internet gateway for the VPC.|**Type:** `string`<br/>|
| `global.connectivity.network.pods` | **Pods**|**Type:** `object`<br/>|
| `global.connectivity.network.pods.cidrBlocks` | **Pod subnets**|**Type:** `array`<br/>**Default:** `["100.64.0.0/12"]`|
| `global.connectivity.network.pods.cidrBlocks[*]` | **Pod subnet** - IPv4 address range for pods, in CIDR notation.|**Type:** `string`<br/>**Example:** `"10.244.0.0/16"`<br/>|
| `global.connectivity.network.services` | **Services**|**Type:** `object`<br/>|
| `global.connectivity.network.services.cidrBlocks` | **K8s Service subnets**|**Type:** `array`<br/>**Default:** `["172.31.0.0/16"]`|
| `global.connectivity.network.services.cidrBlocks[*]` | **Service subnet** - IPv4 address range for kubernetes services, in CIDR notation.|**Type:** `string`<br/>**Example:** `"172.31.0.0/16"`<br/>|
| `global.connectivity.network.vpcCidr` | **VPC subnet** - IPv4 address range to assign to this cluster's VPC, in CIDR notation.|**Type:** `string`<br/>**Default:** `"10.0.0.0/16"`|
| `global.connectivity.network.vpcId` | **VPC id** - ID of the VPC, where the cluster will be deployed. The VPC must exist and it case this is set, VPC wont be created by controllers.|**Type:** `string`<br/>|
| `global.connectivity.proxy` | **Proxy** - Whether/how outgoing traffic is routed through proxy servers.|**Type:** `object`<br/>|
| `global.connectivity.proxy.enabled` | **Enable**|**Type:** `boolean`<br/>|
| `global.connectivity.proxy.httpProxy` | **HTTP proxy** - To be passed to the HTTP_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.proxy.httpsProxy` | **HTTPS proxy** - To be passed to the HTTPS_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.proxy.noProxy` | **No proxy** - To be passed to the NO_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.sshSsoPublicKey` | **SSH public key for single sign-on**|**Type:** `string`<br/>**Default:** `"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"`|
| `global.connectivity.subnets` | **Subnets** - Subnets are created and tagged based on this definition.|**Type:** `array`<br/>**Default:** `[{"cidrBlocks":[{"availabilityZone":"a","cidr":"10.0.0.0/20"},{"availabilityZone":"b","cidr":"10.0.16.0/20"},{"availabilityZone":"c","cidr":"10.0.32.0/20"}],"isPublic":true},{"cidrBlocks":[{"availabilityZone":"a","cidr":"10.0.64.0/18"},{"availabilityZone":"b","cidr":"10.0.128.0/18"},{"availabilityZone":"c","cidr":"10.0.192.0/18"}],"isPublic":false}]`|
| `global.connectivity.subnets[*]` | **Subnet**|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks` | **Network**|**Type:** `array`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*]` |**None**|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].availabilityZone` | **Availability zone**|**Type:** `string`<br/>**Example:** `"a"`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].cidr` | **Address range** - IPv4 address range, in CIDR notation.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].tags` | **Tags** - AWS resource tags to assign to this subnet.|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.subnets[*].id` | **ID of the subnet** - ID of an existing subnet. When set, this subnet will be used instead of creating a new one.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].isPublic` | **Public**|**Type:** `boolean`<br/>|
| `global.connectivity.subnets[*].natGatewayId` | **ID of the NAT Gateway** - ID of the NAT Gateway used for this existing subnet.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].routeTableId` | **ID of route table** - ID of the route table, assigned to the existing subnet. Must be provided when defining subnet via ID.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].tags` | **Tags** - AWS resource tags to assign to this CIDR block.|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.topology` | **Topology** - Networking architecture between management cluster and workload cluster.|**Type:** `object`<br/>|
| `global.connectivity.topology.mode` | **Mode** - Valid values: GiantSwarmManaged, UserManaged, None.|**Type:** `string`<br/>**Default:** `"None"`|
| `global.connectivity.topology.prefixListId` | **Prefix list ID** - ID of the managed prefix list to use when the topology mode is set to 'UserManaged'.|**Type:** `string`<br/>|
| `global.connectivity.topology.transitGatewayId` | **Transit gateway ID** - If the topology mode is set to 'UserManaged', this can be used to specify the transit gateway to use.|**Type:** `string`<br/>|
| `global.connectivity.vpcEndpointMode` | **VPC endpoint mode** - Who is reponsible for creation and management of VPC endpoints.|**Type:** `string`<br/>**Default:** `"GiantSwarmManaged"`|
| `global.connectivity.vpcMode` | **VPC mode** - Whether the cluser's VPC is created with public, internet facing resources (public subnets, NAT gateway) or not (private).|**Type:** `string`<br/>**Default:** `"public"`|

### Control plane
Properties within the `.global.controlPlane` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.controlPlane.additionalSecurityGroups` | **Control Plane additional security groups** - Additional security groups that will be added to the control plane nodes.|**Type:** `array`<br/>|
| `global.controlPlane.additionalSecurityGroups[*]` | **Security group**|**Type:** `object`<br/>|
| `global.controlPlane.additionalSecurityGroups[*].id` | **Id of the security group** - ID of the security group that will be added to the control plane nodes. The security group must exist.|**Type:** `string`<br/>|
| `global.controlPlane.apiExtraArgs` | **API extra arguments** - Extra arguments passed to the kubernetes API server.|**Type:** `object`<br/>|
| `global.controlPlane.apiExtraArgs.PATTERN` | **argument**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^.+:.+$`<br/>|
| `global.controlPlane.apiExtraCertSANs` | **API extra cert SANs** - Extra certs SANs passed to the kubeadmcontrolplane CR.|**Type:** `array`<br/>|
| `global.controlPlane.apiExtraCertSANs[*]` | **cert SAN**|**Type:** `string`<br/>|
| `global.controlPlane.apiMode` | **API mode** - Whether the Kubernetes API server load balancer should be reachable from the internet (public) or internal only (private).|**Type:** `string`<br/>**Default:** `"public"`|
| `global.controlPlane.containerdVolumeSizeGB` | **Containerd volume size (GB)**|**Type:** `integer`<br/>**Default:** `100`|
| `global.controlPlane.etcdVolumeSizeGB` | **Etcd volume size (GB)**|**Type:** `integer`<br/>**Default:** `100`|
| `global.controlPlane.instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Default:** `"r6i.xlarge"`|
| `global.controlPlane.kubeletVolumeSizeGB` | **Kubelet volume size (GB)**|**Type:** `integer`<br/>**Default:** `100`|
| `global.controlPlane.loadBalancerIngressAllowCidrBlocks` | **Load balancer allow list** - IPv4 address ranges that are allowed to connect to the control plane load balancer, in CIDR notation. When setting this field, remember to add the Management cluster Nat Gateway IPs provided by Giant Swarm so that the cluster can still be managed. These Nat Gateway IPs can be found in the Management Cluster AWSCluster '.status.networkStatus.natGatewaysIPs' field.|**Type:** `array`<br/>|
| `global.controlPlane.loadBalancerIngressAllowCidrBlocks[*]` | **Address range**|**Type:** `string`<br/>|
| `global.controlPlane.machineHealthCheck` | **Machine health check**|**Type:** `object`<br/>|
| `global.controlPlane.machineHealthCheck.enabled` | **Enable**|**Type:** `boolean`<br/>**Default:** `true`|
| `global.controlPlane.machineHealthCheck.maxUnhealthy` | **Maximum unhealthy nodes**|**Type:** `string`<br/>**Example:** `"40%"`<br/>**Default:** `"40%"`|
| `global.controlPlane.machineHealthCheck.nodeStartupTimeout` | **Node startup timeout** - Determines how long a machine health check should wait for a node to join the cluster, before considering a machine unhealthy.|**Type:** `string`<br/>**Examples:** `"10m", "100s"`<br/>**Default:** `"8m0s"`|
| `global.controlPlane.machineHealthCheck.unhealthyNotReadyTimeout` | **Timeout for ready** - If a node is not in condition 'Ready' after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Default:** `"10m0s"`|
| `global.controlPlane.machineHealthCheck.unhealthyUnknownTimeout` | **Timeout for unknown condition** - If a node is in 'Unknown' condition after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Default:** `"10m0s"`|
| `global.controlPlane.oidc` | **OIDC authentication**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.clientId` | **Client ID**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.groupsClaim` | **Groups claim**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.issuerUrl` | **Issuer URL** - Exact issuer URL that will be included in identity tokens.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.usernameClaim` | **Username claim**|**Type:** `string`<br/>|
| `global.controlPlane.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Default:** `120`|
| `global.controlPlane.subnetTags` | **Subnet tags** - Tags to select AWS resources for the control plane by.|**Type:** `array`<br/>|
| `global.controlPlane.subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>|
| `global.controlPlane.subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|

### Internal
Properties within the `.internal` top-level object
For Giant Swarm internal use only, not stable, or not supported by UIs.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `internal.cgroupsv1` | **CGroups v1** - Force use of CGroups v1 for whole cluster.|**Type:** `boolean`<br/>**Default:** `false`|
| `internal.hashSalt` | **Hash salt** - If specified, this token is used as a salt to the hash suffix of some resource names. Can be used to force-recreate some resources.|**Type:** `string`<br/>|
| `internal.kubernetesVersion` | **Kubernetes version**|**Type:** `string`<br/>**Example:** `"1.24.7"`<br/>**Default:** `"1.24.14"`|
| `internal.migration` | **Migration values** - Section used for migration of cluster from vintage to CAPI|**Type:** `object`<br/>|
| `internal.migration.apiBindPort` | **Kubernetes API bind port** - Kubernetes API bind port used for kube api pod|**Type:** `integer`<br/>**Default:** `6443`|
| `internal.migration.controlPlaneExtraFiles` | **Control Plane extra files** - Additional fiels that will be provisioned to control-plane nodes, reference is from secret in the same namespace.|**Type:** `array`<br/>|
| `internal.migration.controlPlaneExtraFiles[*]` | **file**|**Type:** `object`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].contentFrom` | **content from**|**Type:** `object`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].contentFrom.secret` | **secret**|**Type:** `object`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].contentFrom.secret.key` | **secret key for file content**|**Type:** `string`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].contentFrom.secret.name` | **secret name for file content**|**Type:** `string`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].path` | **file path**|**Type:** `string`<br/>|
| `internal.migration.controlPlaneExtraFiles[*].permissions` | **file permissions in form 0644**|**Type:** `string`<br/>**Default:** `"0644"`|
| `internal.migration.controlPlanePostKubeadmCommands` | **Control Plane Post Kubeadm Commands** - Additional Post-Kubeadm Commands executed on the control plane node.|**Type:** `array`<br/>|
| `internal.migration.controlPlanePostKubeadmCommands[*]` | **command**|**Type:** `string`<br/>|
| `internal.migration.controlPlanePreKubeadmCommands` | **Control Plane Pre Kubeadm Commands** - Additional Pre-Kubeadm Commands executed on the control plane node.|**Type:** `array`<br/>|
| `internal.migration.controlPlanePreKubeadmCommands[*]` | **command**|**Type:** `string`<br/>|
| `internal.migration.etcdExtraArgs` | **Etcd extra arguments**|**Type:** `object`<br/>|
| `internal.migration.etcdExtraArgs.PATTERN` | **argument**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^.+:.+$`<br/>|
| `internal.nodePools` | **Default node pool**|**Type:** `object`<br/>**Default:** `{"def00":{"customNodeLabels":["label=default"],"instanceType":"r6i.xlarge","maxSize":3,"minSize":3}}`|
| `internal.nodePools.PATTERN` | **Node pool**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.additionalSecurityGroups` | **Machine pool additional security groups** - Additional security groups that will be added to the machine pool nodes.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.additionalSecurityGroups[*]` | **security group**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.additionalSecurityGroups[*].id` | **Id of the security group** - ID of the security group that will be added to the machine pool nodes. The security group must exist.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.availabilityZones` | **Availability zones**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.availabilityZones[*]` | **Availability zone**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeLabels[*]` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeTaints[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.instanceTypeOverrides` | **Instance type overrides** - Ordered list of instance types to be used for the machine pool. The first instance type that is available in the region will be used. Read more in our docs https://docs.giantswarm.io/advanced/cluster-management/node-pools-capi/|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `[]`|
| `internal.nodePools.PATTERN.instanceTypeOverrides[*]` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.maxSize` | **Maximum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.minSize` | **Minimum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.spotInstances` | **Spot instances** - Compared to on-demand instances, spot instances can help you save cost.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.spotInstances.enabled` | **Enable**|**Type:** `boolean`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `false`|
| `internal.nodePools.PATTERN.spotInstances.maxPrice` | **Maximum price to pay per instance per hour, in USD.**|**Type:** `number`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.subnetTags` | **Subnet tags** - Tags to filter which AWS subnets will be used for this node pool.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `internal.nodePools.PATTERN.subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `internal.sandboxContainerImage` | **Kubectl image**|**Type:** `object`<br/>|
| `internal.sandboxContainerImage.name` | **Repository**|**Type:** `string`<br/>**Default:** `"giantswarm/pause"`|
| `internal.sandboxContainerImage.registry` | **Registry**|**Type:** `string`<br/>**Default:** `"quay.io"`|
| `internal.sandboxContainerImage.tag` | **Tag**|**Type:** `string`<br/>**Default:** `"3.9"`|
| `internal.teleport` | **Teleport**|**Type:** `object`<br/>|
| `internal.teleport.enabled` | **Enable teleport**|**Type:** `boolean`<br/>**Default:** `false`|
| `internal.teleport.proxyAddr` | **Teleport proxy address**|**Type:** `string`<br/>**Default:** `"test.teleport.giantswarm.io:443"`|
| `internal.teleport.version` | **Teleport version**|**Type:** `string`<br/>**Default:** `"13.3.8"`|

### Kubectl image
Properties within the `.kubectlImage` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `kubectlImage.name` | **Repository**|**Type:** `string`<br/>**Default:** `"giantswarm/kubectl"`|
| `kubectlImage.registry` | **Registry**|**Type:** `string`<br/>**Default:** `"quay.io"`|
| `kubectlImage.tag` | **Tag**|**Type:** `string`<br/>**Default:** `"1.23.5"`|

### Metadata
Properties within the `.global.metadata` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.metadata.description` | **Cluster description** - User-friendly description of the cluster's purpose.|**Type:** `string`<br/>|
| `global.metadata.name` | **Cluster name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `global.metadata.organization` | **Organization**|**Type:** `string`<br/>|
| `global.metadata.preventDeletion` | **Prevent cluster deletion**|**Type:** `boolean`<br/>**Default:** `false`|
| `global.metadata.servicePriority` | **Service priority** - The relative importance of this cluster.|**Type:** `string`<br/>**Default:** `"highest"`|

### Node pools
Properties within the `.global.nodePools` object
Node pools of the cluster. If not specified, this defaults to the value of `internal.nodePools`.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.nodePools.PATTERN` | **Node pool**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.additionalSecurityGroups` | **Machine pool additional security groups** - Additional security groups that will be added to the machine pool nodes.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.additionalSecurityGroups[*]` | **security group**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.additionalSecurityGroups[*].id` | **Id of the security group** - ID of the security group that will be added to the machine pool nodes. The security group must exist.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.availabilityZones` | **Availability zones**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.availabilityZones[*]` | **Availability zone**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeLabels[*]` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.instanceTypeOverrides` | **Instance type overrides** - Ordered list of instance types to be used for the machine pool. The first instance type that is available in the region will be used. Read more in our docs https://docs.giantswarm.io/advanced/cluster-management/node-pools-capi/|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `[]`|
| `global.nodePools.PATTERN.instanceTypeOverrides[*]` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.maxSize` | **Maximum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.minSize` | **Minimum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.spotInstances` | **Spot instances** - Compared to on-demand instances, spot instances can help you save cost.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.spotInstances.enabled` | **Enable**|**Type:** `boolean`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `false`|
| `global.nodePools.PATTERN.spotInstances.maxPrice` | **Maximum price to pay per instance per hour, in USD.**|**Type:** `number`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.subnetTags` | **Subnet tags** - Tags to filter which AWS subnets will be used for this node pool.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|

### Other global

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.managementCluster` | **Management cluster** - Name of the Cluster API cluster managing this workload cluster.|**Type:** `string`<br/>|

### Other

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `baseDomain` | **Base DNS domain**|**Type:** `string`<br/>|
| `cluster-shared` | **Library chart**|**Type:** `object`<br/>|
| `provider` | **Cluster API provider name**|**Type:** `string`<br/>|



<!-- DOCS_END -->
