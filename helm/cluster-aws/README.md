# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-aws version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-aws/values.schema.json -o helm/cluster-aws/README.md

-->

<!-- DOCS_START -->

### AWS settings
Properties within the `.global.providerSpecific` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.providerSpecific.additionalNodeTags` | **Additional node tags** - Additional tags to add to AWS nodes created by the cluster.|**Type:** `object`<br/>|
| `global.providerSpecific.additionalNodeTags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.providerSpecific.additionalResourceTags` | **Additional resource tags** - Additional tags to add to AWS resources created by the cluster.|**Type:** `object`<br/>|
| `global.providerSpecific.additionalResourceTags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.providerSpecific.ami` | **Amazon machine image (AMI)** - If specified, this image will be used to provision EC2 instances.|**Type:** `string`<br/>|
| `global.providerSpecific.awsAccountId` | **AWS Account ID** - Only used when rendering the chart template locally, you shouldn't use this value. Used to calculate the IRSA service account issuer when using the China region.|**Type:** `string`<br/>**Value pattern:** `^[0-9]{12}$`<br/>|
| `global.providerSpecific.awsClusterRoleIdentityName` | **Cluster role identity name** - Name of an AWSClusterRoleIdentity object. Learn more at https://docs.giantswarm.io/getting-started/cloud-provider-accounts/cluster-api/aws/#configure-the-awsclusterroleidentity .|**Type:** `string`<br/>**Value pattern:** `^[-a-zA-Z0-9_\.]{1,63}$`<br/>**Default:** `"default"`|
| `global.providerSpecific.controlPlaneAmi` | **Amazon machine image (AMI) for control plane** - If specified, this image will be used to provision EC2 instances for the control plane.|**Type:** `string`<br/>|
| `global.providerSpecific.flatcarAwsAccount` | **AWS account owning Flatcar image** - AWS account ID owning the Flatcar Container Linux AMI.|**Type:** `string`<br/>**Default:** `"706635527432"`|
| `global.providerSpecific.instanceMetadataOptions` | **Instance metadata options** - Instance metadata options for the EC2 instances in the cluster.|**Type:** `object`<br/>|
| `global.providerSpecific.instanceMetadataOptions.httpPutResponseHopLimit` | **Metadata response hop limit** - The hop limit is the number of network hops that the PUT response is allowed to make towards the instance metadata service. Learn more in [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-options.html). If specified, this applies to all nodes.|**Type:** `number`<br/>|
| `global.providerSpecific.instanceMetadataOptions.httpTokens` | **HTTP tokens** - The state of token usage for your instance metadata requests. If you set this parameter to `optional`, you can use either IMDSv1 or IMDSv2. If you set this parameter to `required`, you must use a IMDSv2 to access the instance metadata endpoint. Learn more at [What’s new in IMDSv2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html).|**Type:** `string`<br/>**Allowed values:** `optional`, `required`<br/>**Default:** `"required"`|
| `global.providerSpecific.irsaCrossplane` | **Use Crossplane to provision IRSA infrastructure** - Defaults to true. Crossplane will adopt all the resources created by IRSA Operator. If set to false, the IRSA Operator will take over the infrastructure again.|**Type:** `boolean`<br/>**Default:** `true`|
| `global.providerSpecific.nodePoolAmi` | **Amazon machine image (AMI) for node pools** - If specified, this image will be used to provision EC2 instances for node pools.|**Type:** `string`<br/>|
| `global.providerSpecific.nodeTerminationHandlerEnabled` | **Use the AWS Node Termination Handler app** - Defaults to true. Whether or not to enable the Auto Scaling Groups lifecycle hooks and use the node-termination-handler app (NTH) to manage the termination of EC2 instances.|**Type:** `boolean`<br/>**Default:** `true`|
| `global.providerSpecific.region` | **AWS Region**|**Type:** `string`<br/>**Value pattern:** `^[a-z]{2}(-[a-z]+)+-[0-9]+$`<br/>|

### Apps
Properties within the `.global.apps` object
Configuration of apps that are part of the cluster.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.apps.awsCloudControllerManager` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.awsCloudControllerManager.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.awsCloudControllerManager.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.awsCloudControllerManager.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.awsCloudControllerManager.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.awsCloudControllerManager.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.awsCloudControllerManager.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriver` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriver.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.awsEbsCsiDriver.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriver.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.awsEbsCsiDriver.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.awsEbsCsiDriver.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.awsEbsCsiDriver.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.awsEbsCsiDriverServiceMonitors.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.awsEbsCsiDriverServiceMonitors.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.awsNodeTerminationHandler` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.awsNodeTerminationHandler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.awsNodeTerminationHandler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.awsNodeTerminationHandler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.awsNodeTerminationHandler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.awsNodeTerminationHandler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.awsNodeTerminationHandler.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.awsPodIdentityWebhook` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.awsPodIdentityWebhook.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.awsPodIdentityWebhook.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.awsPodIdentityWebhook.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.awsPodIdentityWebhook.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.awsPodIdentityWebhook.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.awsPodIdentityWebhook.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.certExporter` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.certExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.certExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.certExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.certExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.certExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.certExporter.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.certManager` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.certManager.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.certManager.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.certManager.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.certManager.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.certManager.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.certManager.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.certManagerCrossplaneResources` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.certManagerCrossplaneResources.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.certManagerCrossplaneResources.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.certManagerCrossplaneResources.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.certManagerCrossplaneResources.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.certManagerCrossplaneResources.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.certManagerCrossplaneResources.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.chartOperatorExtensions.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.cilium` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.cilium.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.cilium.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.cilium.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.cilium.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.cilium.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.cilium.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.ciliumCrossplaneResources` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.ciliumCrossplaneResources.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.ciliumCrossplaneResources.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.ciliumCrossplaneResources.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.ciliumCrossplaneResources.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.ciliumCrossplaneResources.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.ciliumCrossplaneResources.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.ciliumServiceMonitors.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.clusterAutoscaler.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.coreDns` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.coreDns.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.coreDns.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.coreDns.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.coreDns.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.coreDns.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.coreDns.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.coreDnsExtensions` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.coreDnsExtensions.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.coreDnsExtensions.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.coreDnsExtensions.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.coreDnsExtensions.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.coreDnsExtensions.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.coreDnsExtensions.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.etcdDefrag` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.etcdDefrag.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.etcdDefrag.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.etcdDefrag.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.etcdDefrag.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.etcdDefrag.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.etcdDefrag.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.etcdKubernetesResourcesCountExporter.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.externalDns` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.externalDns.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.externalDns.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.externalDns.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.externalDns.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.externalDns.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.externalDns.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.irsaServiceMonitors` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.irsaServiceMonitors.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.irsaServiceMonitors.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.irsaServiceMonitors.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.irsaServiceMonitors.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.irsaServiceMonitors.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.irsaServiceMonitors.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.k8sAuditMetrics.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.k8sDnsNodeCache.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.karpenter` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.karpenter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.karpenter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.karpenter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.karpenter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.karpenter.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.karpenter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.metricsServer` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.metricsServer.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.metricsServer.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.metricsServer.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.metricsServer.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.metricsServer.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.metricsServer.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.netExporter` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.netExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.netExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.netExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.netExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.netExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.netExporter.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.networkPolicies` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.networkPolicies.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.networkPolicies.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.networkPolicies.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.nodeExporter` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.nodeExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.nodeExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.nodeExporter.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.nodeProblemDetector` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.nodeProblemDetector.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.nodeProblemDetector.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.nodeProblemDetector.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.nodeProblemDetector.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.nodeProblemDetector.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.nodeProblemDetector.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.observabilityBundle` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.observabilityBundle.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.observabilityBundle.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.observabilityPolicies.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.priorityClasses` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.priorityClasses.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.priorityClasses.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.priorityClasses.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.priorityClasses.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.priorityClasses.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.priorityClasses.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.prometheusBlackboxExporter.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.securityBundle` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.securityBundle.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.securityBundle.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.securityBundle.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.securityBundle.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.securityBundle.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.securityBundle.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.teleportKubeAgent.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler` | **App resource** - Configuration of a default app that is part of the cluster and is deployed as an App resource.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `configMap`, `secret`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.verticalPodAutoscaler.values` | **Config map** - Helm Values to be passed to the app as user config.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>**Allowed values:** `ConfigMap`, `Secret`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.verticalPodAutoscalerCrd.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|

### Components
Properties within the `.global.components` object
Advanced configuration of components that are running on all nodes.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.components.auditd` | **Auditd** - Enable Auditd service.|**Type:** `object`<br/>|
| `global.components.auditd.enabled` | **Enabled** - Whether or not the Auditd service shall be enabled. When true, the Auditd service is enabled. When false, the Auditd rules service is disabled.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd` | **Containerd** - Configuration of containerd.|**Type:** `object`<br/>|
| `global.components.containerd.cdi` | **Container Device Interface (CDI)** - Configuration of CDI support in containerd.|**Type:** `object`<br/>|
| `global.components.containerd.cdi.enabled` | **Enabled** - Enabling this will configure containerd to support Container Device Interface (CDI) specification.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.cdi.specDirs` | **CDI spec directories** - List of directories to search for CDI spec files.|**Type:** `array`<br/>**Default:** `["/etc/cdi","/var/run/cdi"]`|
| `global.components.containerd.cdi.specDirs[*]` | **CDI spec directory** - Directory to search for CDI spec files.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries` | **Container registries** - Endpoints and credentials configuration for container registries.|**Type:** `object`<br/>**Default:** `{"docker.io":[{"endpoint":"registry-1.docker.io"},{"endpoint":"giantswarm.azurecr.io"}],"gsoci.azurecr.io":[{"endpoint":"gsoci.azurecr.io"}]}`|
| `global.components.containerd.containerRegistries.*` | **Registries** - Container registries and mirrors|**Type:** `array`<br/>|
| `global.components.containerd.containerRegistries.*[*]` | **Registry**|**Type:** `object`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials` | **Credentials**|**Type:** `object`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.auth` | **Auth** - Base64-encoded string from the concatenation of the username, a colon, and the password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.identitytoken` | **Identity token** - Used to authenticate the user and obtain an access token for the registry.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.password` | **Password** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.username` | **Username** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].endpoint` | **Endpoint** - Endpoint for the container registry.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].insecure` | **HTTP endpoint** - Set to true to configure endpoint as HTTP instead of HTTPS (default).|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.containerRegistries.*[*].overridePath` | **Override path enabled** - This setting is used to indicate the host's API root endpoint is defined in the URL path rather than by the API specification. This may be used with non-compliant OCI registries which are missing the /v2 prefix. (Defaults to false).|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.containerRegistries.*[*].skipVerify` | **Skip TLS verify** - Skip TLS verification of the endpoint.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.debug` | **ContainerD debug configuration** - Debug configuration for containerd.|**Type:** `object`<br/>|
| `global.components.containerd.debug.level` | **Debug level** - Debug level for containerd logging [trace, debug, info, warn, error, fatal, panic].|**Type:** `string`<br/>**Allowed values:** `trace`, `debug`, `info`, `warn`, `error`, `fatal`, `panic`<br/>**Default:** `"info"`|
| `global.components.containerd.localRegistryCache` | **Local registry caches configuration** - Enable local cache via http://127.0.0.1:<PORT>.|**Type:** `object`<br/>|
| `global.components.containerd.localRegistryCache.enabled` | **Enable local registry caches** - Flag to enable local registry cache.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.localRegistryCache.mirroredRegistries` | **Registries to cache locally** - A list of registries that should be cached.|**Type:** `array`<br/>**Default:** `[]`|
| `global.components.containerd.localRegistryCache.mirroredRegistries[*]` |**None**|**Type:** `string`<br/>|
| `global.components.containerd.localRegistryCache.port` | **Local port for the registry cache** - Port for the local registry cache under: http://127.0.0.1:<PORT>.|**Type:** `integer`<br/>**Default:** `32767`|
| `global.components.containerd.managementClusterRegistryCache` | **Management cluster registry cache** - Caching container registry on a management cluster level.|**Type:** `object`<br/>|
| `global.components.containerd.managementClusterRegistryCache.enabled` | **Enabled** - Enabling this will configure containerd to use management cluster's Zot registry service. To make use of it as a pull-through cache, you also have to specify registries to cache images for.|**Type:** `boolean`<br/>**Default:** `true`|
| `global.components.containerd.managementClusterRegistryCache.mirroredRegistries` | **Registries to cache** - Here you must specify each registry to cache container images for. Please also make sure to have an entry for each registry in Global > Components > Containerd > Container registries.|**Type:** `array`<br/>**Default:** `["gsoci.azurecr.io"]`|
| `global.components.containerd.managementClusterRegistryCache.mirroredRegistries[*]` |**None**|**Type:** `string`<br/>|
| `global.components.containerd.selinux` | **SELinux configuration** - SELinux configuration for containerd.|**Type:** `object`<br/>|
| `global.components.containerd.selinux.enabled` | **Enabled** - Enabling this will configure containerd to do SELinux relabeling to containers.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.selinux` | **SELinux** - Configuration of SELinux.|**Type:** `object`<br/>|
| `global.components.selinux.mode` | **SELinux mode** - Configure SELinux mode: 'enforcing', 'permissive' or 'disabled'.|**Type:** `string`<br/>**Allowed values:** `enforcing`, `permissive`, `disabled`<br/>**Default:** `"permissive"`|

### Connectivity
Properties within the `.global.connectivity` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.connectivity.availabilityZoneUsageLimit` | **Availability zones** - Maximum number of availability zones (AZ) that should be used in a region. If a region has more than this number of AZs then this number of AZs will be picked randomly when creating subnets.|**Type:** `integer`<br/>**Default:** `3`|
| `global.connectivity.baseDomain` | **Base DNS domain**|**Type:** `string`<br/>|
| `global.connectivity.certManager` | **CertManager** - Configuration of CertManager.|**Type:** `object`<br/>|
| `global.connectivity.certManager.useDnsChallenges` | **Use DNS Challenges** - Set to true to enable DNS challenges in the default ClusterIssuer and install all necessary IAM roles.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.connectivity.cilium` | **Cilium** - Configuration of the Cilium CNI.|**Type:** `object`<br/>|
| `global.connectivity.cilium.ipamMode` | **IPAM mode (IP allocation strategy)** - Use `eni` for ENI (AWS Elastic Network Interfaces) allocation of IPs in Cilium (https://docs.cilium.io/en/latest/network/concepts/ipam/eni/). The default is `kubernetes` (https://docs.cilium.io/en/latest/network/concepts/ipam/kubernetes/). WARNING: The `eni` feature is currently in an early stage and there might be breaking changes in the future. The networking infrastructure will be made consistent with our vintage cluster implementations so that pod IPs are placed in a secondary VPC CIDR.|**Type:** `string`<br/>**Allowed values:** `eni`, `kubernetes`<br/>**Default:** `"kubernetes"`|
| `global.connectivity.dns` | **DNS**|**Type:** `object`<br/>|
| `global.connectivity.dns.delegationIdentityName` | **DNS Delegation AWSClusterRoleIdentity** - AWSClusterRoleIdentity to use when taking care of creating the DNS delegation between the cluster hosted zone and its parent hosted zone. It needs to have permissions to manage the parent hosted zone.|**Type:** `string`<br/>**Examples:** `"default"`, `"production"`, `"development"`<br/>|
| `global.connectivity.dns.hostedZoneName` | **Hosted Zone name** - Name of the hosted zone to create for this cluster.|**Type:** `string`<br/>**Example:** `"my-cluster.example.com"`<br/>|
| `global.connectivity.dns.resolverRulesOwnerAccount` | **Resolver rules owner** - ID of the AWS account that created the resolver rules to be associated with the workload cluster VPC.|**Type:** `string`<br/>|
| `global.connectivity.dns.resolverRulesOwnerAccount[option#1]` |**None**|**Value pattern:** `^\d{12}$`<br/>|
| `global.connectivity.dns.resolverRulesOwnerAccount[option#2]` |**None**|**Must have value:** ``<br/>|
| `global.connectivity.eniModePodSubnets` | **Pod Subnets for Cilium ENI mode** - Pod subnets are created and tagged based on this definition. **Only used for `global.connectivity.cilium.ipamMode=eni`** which puts pods on a secondary CIDR block in the VPC, and therefore requires separate subnets. The subnets must be tagged with `sigs.k8s.io/cluster-api-provider-aws/association=secondary` to be correctly handled by CAPA (so those subnets aren't accidentally chosen for nodes). These subnets are always private.|**Type:** `array`<br/>**Default:** `[{"cidrBlocks":[{"availabilityZone":"a","cidr":"10.1.0.0/18","tags":{"sigs.k8s.io/cluster-api-provider-aws/association":"secondary"}},{"availabilityZone":"b","cidr":"10.1.64.0/18","tags":{"sigs.k8s.io/cluster-api-provider-aws/association":"secondary"}},{"availabilityZone":"c","cidr":"10.1.128.0/18","tags":{"sigs.k8s.io/cluster-api-provider-aws/association":"secondary"}}]}]`|
| `global.connectivity.eniModePodSubnets[*]` | **Subnet**|**Type:** `object`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks` | **Network**|**Type:** `array`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks[*]` |**None**|**Type:** `object`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks[*].availabilityZone` | **Availability zone**|**Type:** `string`<br/>**Example:** `"a"`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks[*].cidr` | **Address range** - IPv4 address range, in CIDR notation.|**Type:** `string`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks[*].tags` | **Tags** - AWS resource tags to assign to this subnet.|**Type:** `object`<br/>|
| `global.connectivity.eniModePodSubnets[*].cidrBlocks[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.eniModePodSubnets[*].tags` | **Tags** - AWS resource tags to assign to this CIDR block.|**Type:** `object`<br/>|
| `global.connectivity.eniModePodSubnets[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.network` | **Network**|**Type:** `object`<br/>|
| `global.connectivity.network.allowAllEgress` | **Allow all egress**|**Type:** `boolean`<br/>**Default:** `false`|
| `global.connectivity.network.internetGatewayId` | **Internet Gateway ID** - ID of the Internet gateway for the VPC.|**Type:** `string`<br/>|
| `global.connectivity.network.nodePortIngressRuleCidrBlocks` | **NodePort security group ingress rules**|**Type:** `array`<br/>|
| `global.connectivity.network.nodePortIngressRuleCidrBlocks[*]` | **CIDR** - IPv4 address range to allow in the NodePort security group ingress rules. These will get merged with the CIDRs defined in .Values.global.connectivity.network.vpcCidrs.|**Type:** `string`<br/>**Example:** `["10.0.0.0/16"]`<br/>**Value pattern:** `^(([0-9]{1,3}\.){3}[0-9]{1,3}/(1[6-9]|2[0-8]))$`<br/>|
| `global.connectivity.network.pods` | **Pods**|**Type:** `object`<br/>|
| `global.connectivity.network.pods.cidrBlocks` | **Pod subnets** - CIDR blocks used for pods. Multiple blocks are supported.<br/><br/>These will be associated as primary/secondary VPC CIDRs. Therefore, only sizes /16 to /28 sizes are possible (see https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html).<br/><br/>**Note if you use `global.connectivity.cilium.ipamMode=eni` (https://docs.cilium.io/en/latest/network/concepts/ipam/eni/#ipam-eni):** `global.connectivity.eniModePodSubnets` must be a valid split of the CIDR you chose here – we recommend setting `10.1.0.0/16` here for ENI mode because the default values for `global.connectivity.eniModePodSubnets` match that CIDR.|**Type:** `array`<br/>**Default:** `["100.64.0.0/12"]`|
| `global.connectivity.network.pods.cidrBlocks[*]` | **Pod subnet** - IPv4 address range for pods, in CIDR notation.|**Type:** `string`<br/>**Example:** `"10.244.0.0/16"`<br/>|
| `global.connectivity.network.pods.nodeCidrMaskSize` | **Node CIDR mask size** - The size of the mask that is used for the node CIDR. The node CIDR is a sub-range of the pod CIDR and so the mask size and pod CIDR must be chosen such that there is enough space for the maximum number of nodes in the cluster.|**Type:** `integer`<br/>**Default:** `24`|
| `global.connectivity.network.services` | **Services**|**Type:** `object`<br/>|
| `global.connectivity.network.services.cidrBlocks` | **K8s Service subnets**|**Type:** `array`<br/>**Default:** `["172.31.0.0/16"]`|
| `global.connectivity.network.services.cidrBlocks[*]` | **Service subnet** - IPv4 address range for kubernetes services, in CIDR notation.|**Type:** `string`<br/>**Example:** `"172.31.0.0/16"`<br/>|
| `global.connectivity.network.vpcCidr` | **VPC CIDR** - IPv4 address range to assign to this cluster's VPC, in CIDR notation. **DEPRECATED**, please use `global.connectivity.network.vpcCidrs`.|**Type:** `string`<br/>|
| `global.connectivity.network.vpcCidrs` | **VPC CIDRs**|**Type:** `array`<br/>|
| `global.connectivity.network.vpcCidrs[*]` | **VPC CIDR** - IPv4 address range to assign to this cluster's VPC, in CIDR notation. The first-listed CIDR should not be changed because this could lead to unexpected reconciliation behavior. Only /16 to /28 sizes are supported (see https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html). Defaults to '10.0.0.0/16' if no value is provided, unless an existing VPC ID is given in `global.connectivity.network.vpcId`.|**Type:** `string`<br/>**Example:** `["10.0.0.0/16"]`<br/>**Value pattern:** `^(([0-9]{1,3}\.){3}[0-9]{1,3}/(1[6-9]|2[0-8]))$`<br/>|
| `global.connectivity.network.vpcId` | **VPC id** - ID of the VPC, where the cluster will be deployed. The VPC must exist and it case this is set, VPC wont be created by controllers.|**Type:** `string`<br/>|
| `global.connectivity.proxy` | **Proxy** - Whether/how outgoing traffic is routed through proxy servers.|**Type:** `object`<br/>|
| `global.connectivity.proxy.enabled` | **Enable**|**Type:** `boolean`<br/>|
| `global.connectivity.proxy.httpProxy` | **HTTP proxy** - To be passed to the HTTP_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.proxy.httpsProxy` | **HTTPS proxy** - To be passed to the HTTPS_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.proxy.noProxy` | **No proxy** - To be passed to the NO_PROXY environment variable in all hosts.|**Type:** `string`<br/>|
| `global.connectivity.subnets` | **Subnets** - Subnets are created and tagged based on this definition.|**Type:** `array`<br/>**Default:** `[{"cidrBlocks":[{"cidr":"10.0.0.0/20"},{"cidr":"10.0.16.0/20"},{"cidr":"10.0.32.0/20"}],"isPublic":true},{"cidrBlocks":[{"cidr":"10.0.64.0/18"},{"cidr":"10.0.128.0/18"},{"cidr":"10.0.192.0/18"}],"isPublic":false}]`|
| `global.connectivity.subnets[*]` | **Subnet**|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks` | **Network**|**Type:** `array`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*]` |**None**|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].availabilityZone` | **Availability zone**|**Type:** `string`<br/>**Example:** `"a"`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].cidr` | **Address range** - IPv4 address range, in CIDR notation. Only /16 to /28 sizes are supported (see https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html#subnet-sizing-ipv4).|**Type:** `string`<br/>**Value pattern:** `^(([0-9]{1,3}\.){3}[0-9]{1,3}/(1[6-9]|2[0-8]))$`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].tags` | **Tags** - AWS resource tags to assign to this subnet.|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].cidrBlocks[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.subnets[*].id` | **ID of the subnet** - ID of an existing subnet. When set, this subnet will be used instead of creating a new one.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].isPublic` | **Public**|**Type:** `boolean`<br/>|
| `global.connectivity.subnets[*].natGatewayId` | **ID of the NAT Gateway** - ID of the NAT Gateway used for this existing subnet.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].routeTableId` | **ID of route table** - ID of the route table, assigned to the existing subnet. Must be provided when defining subnet via ID.|**Type:** `string`<br/>|
| `global.connectivity.subnets[*].tags` | **Tags** - AWS resource tags to assign to this CIDR block.|**Type:** `object`<br/>|
| `global.connectivity.subnets[*].tags.*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.connectivity.topology` | **Topology** - Networking architecture between management cluster and workload cluster.|**Type:** `object`<br/>|
| `global.connectivity.topology.mode` | **Mode** - Valid values: GiantSwarmManaged, UserManaged, None.|**Type:** `string`<br/>**Allowed values:** `None`, `GiantSwarmManaged`, `UserManaged`<br/>**Default:** `"None"`|
| `global.connectivity.topology.prefixListId` | **Prefix list ID** - ID of the managed prefix list to use when the topology mode is set to 'UserManaged'.|**Type:** `string`<br/>|
| `global.connectivity.topology.transitGatewayId` | **Transit gateway ID** - If the topology mode is set to 'UserManaged', this can be used to specify the transit gateway to use.|**Type:** `string`<br/>|
| `global.connectivity.vpcEndpointMode` | **VPC endpoint mode** - Who is reponsible for creation and management of VPC endpoints.|**Type:** `string`<br/>**Allowed values:** `GiantSwarmManaged`, `UserManaged`<br/>**Default:** `"GiantSwarmManaged"`|
| `global.connectivity.vpcMode` | **VPC mode** - Whether the cluser's VPC is created with public, internet facing resources (public subnets, NAT gateway) or not (private).|**Type:** `string`<br/>**Allowed values:** `public`, `private`<br/>**Default:** `"public"`|

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
| `global.controlPlane.apiMode` | **API mode** - Whether the Kubernetes API server load balancer should be reachable from the internet (public) or internal only (private).|**Type:** `string`<br/>**Allowed values:** `public`, `private`<br/>**Default:** `"public"`|
| `global.controlPlane.apiServerPort` | **API server port** - The API server Load Balancer port. This option sets the Spec.ClusterNetwork.APIServerPort field on the Cluster CR. In CAPI this field isn't used currently. It is instead used in providers. In CAPA this sets only the public facing port of the Load Balancer. In CAPZ both the public facing and the destination port are set to this value. CAPV and CAPVCD do not use it.|**Type:** `integer`<br/>**Default:** `443`|
| `global.controlPlane.etcdVolumeSizeGB` | **Etcd volume size (GB)**|**Type:** `integer`<br/>**Default:** `50`|
| `global.controlPlane.instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Value pattern:** `^[a-z][a-z0-9]*\.[a-z0-9]+$`<br/>**Default:** `"r6i.xlarge"`|
| `global.controlPlane.libVolumeSizeGB` | **Lib volume size (GB)** - Size of the volume mounted at `/var/lib` on the control plane nodes. This disk is shared between kubelet folder `/var/lib/kubelet` and containerd folder `/var/lib/containerd`.|**Type:** `integer`<br/>**Default:** `40`|
| `global.controlPlane.loadBalancerIngressAllowCidrBlocks` | **Load balancer allow list** - IPv4 address ranges that are allowed to connect to the control plane load balancer, in CIDR notation. When setting this field, remember to add the Management cluster Nat Gateway IPs provided by Giant Swarm so that the cluster can still be managed. These Nat Gateway IPs can be found in the Management Cluster AWSCluster '.status.networkStatus.natGatewaysIPs' field.|**Type:** `array`<br/>|
| `global.controlPlane.loadBalancerIngressAllowCidrBlocks[*]` | **Address range**|**Type:** `string`<br/>|
| `global.controlPlane.logVolumeSizeGB` | **Log volume size (GB)** - Size of the volume mounted at /var/log on the control plane nodes.|**Type:** `integer`<br/>**Default:** `15`|
| `global.controlPlane.machineHealthCheck` | **Machine health check**|**Type:** `object`<br/>|
| `global.controlPlane.machineHealthCheck.diskFullContainerdTimeout` | **DiskFullContainerd timeout** - Determines how long a machine health check should wait for a node with condition DiskFullContainerd=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Default:** `""`|
| `global.controlPlane.machineHealthCheck.diskFullKubeletTimeout` | **DiskFullKubelet timeout** - Determines how long a machine health check should wait for a node with condition DiskFullKubelet=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Default:** `""`|
| `global.controlPlane.machineHealthCheck.diskFullVarLogTimeout` | **DiskFullVarLog timeout** - Determines how long a machine health check should wait for a node with condition DiskFullVarLog=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Default:** `""`|
| `global.controlPlane.machineHealthCheck.enabled` | **Enable**|**Type:** `boolean`<br/>**Default:** `true`|
| `global.controlPlane.machineHealthCheck.maxUnhealthy` | **Maximum unhealthy nodes** - Defaults to 40% for control plane nodes and 20% for worker nodes.|**Type:** `string`<br/>**Example:** `"40%"`<br/>|
| `global.controlPlane.machineHealthCheck.nodeStartupTimeout` | **Node startup timeout** - Determines how long a machine health check should wait for a node to join the cluster, before considering a machine unhealthy.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Default:** `"8m0s"`|
| `global.controlPlane.machineHealthCheck.unhealthyNotReadyTimeout` | **Timeout for ready** - If a node is not in condition 'Ready' after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Default:** `"10m0s"`|
| `global.controlPlane.machineHealthCheck.unhealthyUnknownTimeout` | **Timeout for unknown condition** - If a node is in 'Unknown' condition after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Default:** `"10m0s"`|
| `global.controlPlane.oidc` | **OIDC authentication**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.clientId` | **Client ID**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.groupsClaim` | **Groups claim**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.issuerUrl` | **Issuer URL** - Exact issuer URL that will be included in identity tokens.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication` | **Structured authentication**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.enabled` | **Enable structured authentication**|**Type:** `boolean`<br/>**Default:** `false`|
| `global.controlPlane.oidc.structuredAuthentication.issuers` | **Issuers**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*]` |**None**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].audienceMatchPolicy` | **Audience match policy**|**Type:** `string`<br/>**Allowed value:** `MatchAny`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].audiences` | **Audiences**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].audiences[*]` |**None**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings` | **Claim mappings**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.extra` | **Extra attributes**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.extra[*]` |**None**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.extra[*].key` | **Key**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.extra[*].valueExpression` | **Value expression**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.groups` | **Groups mapping**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.groups.claim` | **Claim** - JWT claim to use for groups. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.groups.expression` | **CEL expression** - CEL expression to determine groups. Mutually exclusive with 'claim' and 'prefix'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.groups.prefix` | **Prefix** - Prefix to prepend to group claims. Required if 'claim' is set. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.uid` | **UID mapping**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.uid.claim` | **Claim** - JWT claim to use as the UID. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.uid.expression` | **CEL expression** - CEL expression to determine the UID. Mutually exclusive with 'claim'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.username` | **Username mapping**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.username.claim` | **Claim** - JWT claim to use as the username. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.username.expression` | **CEL expression** - CEL expression to determine the username. Mutually exclusive with 'claim' and 'prefix'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimMappings.username.prefix` | **Prefix** - Prefix to prepend to the username claim. Required if 'claim' is set. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules` | **Claim validation rules**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules[*]` |**None**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules[*].claim` | **Claim** - JWT claim to validate. Used with 'requiredValue'. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules[*].expression` | **CEL expression** - CEL expression that must evaluate to true. Mutually exclusive with 'claim' and 'requiredValue'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules[*].message` | **Validation message** - Error message shown in API server logs when validation fails.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].claimValidationRules[*].requiredValue` | **Required value** - Required value for the claim. Used with 'claim'. Mutually exclusive with 'expression'.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].clientId` | **Client ID**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].discoveryUrl` | **Discovery URL** - Overrides the URL used to fetch discovery information.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].groupsClaim` | **Groups claim**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].groupsPrefix` | **Groups prefix**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].issuerUrl` | **Issuer URL** - Exact issuer URL that will be included in identity tokens.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].requiredClaims` | **Required claims (Legacy)**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].requiredClaims[*]` |**None**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].requiredClaims[*].claim` | **Claim**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].requiredClaims[*].requiredValue` | **Required value**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].userValidationRules` | **User validation rules**|**Type:** `array`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].userValidationRules[*]` |**None**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].userValidationRules[*].expression` | **CEL expression** - CEL expression that must evaluate to true for the user to be valid.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].userValidationRules[*].message` | **Validation message** - Error message shown in API server logs when validation fails.|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].usernameClaim` | **Username claim**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.structuredAuthentication.issuers[*].usernamePrefix` | **Username prefix**|**Type:** `string`<br/>|
| `global.controlPlane.oidc.usernameClaim` | **Username claim**|**Type:** `string`<br/>|
| `global.controlPlane.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Default:** `8`|
| `global.controlPlane.subnetTags` | **Subnet tags** - Tags to select AWS resources for the control plane by.|**Type:** `array`<br/>|
| `global.controlPlane.subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>|
| `global.controlPlane.subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|

### Internal
Properties within the `.internal` top-level object
For Giant Swarm internal use only, not stable, or not supported by UIs.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `internal.awsPartition` | **AWS Partition** - Only used when rendering the chart template locally, you shouldn't use this value.|**Type:** `string`<br/>|
| `internal.hashSalt` | **Hash salt** - If specified, this token is used as a salt to the hash suffix of some resource names. Can be used to force-recreate some resources.|**Type:** `string`<br/>|

### Metadata
Properties within the `.global.metadata` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.metadata.description` | **Cluster description** - User-friendly description of the cluster's purpose.|**Type:** `string`<br/>|
| `global.metadata.labels` | **Labels** - These labels are added to the Kubernetes resources defining this cluster.|**Type:** `object`<br/>|
| `global.metadata.labels.PATTERN` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-zA-Z0-9/\._-]+$`<br/>**Value pattern:** `^[a-zA-Z0-9\._-]+$`<br/>|
| `global.metadata.name` | **Cluster name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `global.metadata.organization` | **Organization**|**Type:** `string`<br/>|
| `global.metadata.preventDeletion` | **Prevent cluster deletion**|**Type:** `boolean`<br/>**Default:** `false`|
| `global.metadata.servicePriority` | **Service priority** - The relative importance of this cluster.|**Type:** `string`<br/>**Allowed values:** `highest`, `medium`, `lowest`<br/>**Default:** `"highest"`|

### Node pools
Properties within the `.global.nodePools` object
Node pools of the cluster. If not specified, this defaults to the value of `cluster.providerIntegration.workers.defaultNodePools`.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.nodePools.PATTERN` | **Node pool**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].additionalSecurityGroups` | **Machine pool additional security groups** - Additional security groups that will be added to the machine pool nodes.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].additionalSecurityGroups[*]` | **security group**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].additionalSecurityGroups[*].id` | **Id of the security group** - ID of the security group that will be added to the machine pool nodes. The security group must exist.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidateAfter` | **Consolidate after** - The duration karpenter will wait before attempting to terminate nodes that are underutilized after a pod has been added or removed from the node.|**Type:** `string`<br/>**Examples:** `"3m"`, `"24h"`, `"Never"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^(([0-9]+(s|m|h))+|Never)$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationBudgets` | **Disruption budgets** - Budgets control the speed Karpenter can scale down nodes. Karpenter will respect the minimum of the currently active budgets, and will round up when considering percentages. Duration and Schedule must be set together.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `[{"nodes":"10%"}]`|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*]` | **Budget**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*].duration` | **Duration** - Determines how long a Budget is active since each Schedule hit. Only minutes and hours are accepted, as cron does not work in seconds. If omitted, the budget is always active.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^((([0-9]+(h|m))|([0-9]+h[0-9]+m))(0s)?)$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*].nodes` | **Nodes** - Dictates the maximum number of NodeClaims owned by this NodePool that can be terminating at once. This is calculated by counting nodes that have a deletion timestamp set, or are actively being deleted by Karpenter. This field is required when specifying a budget.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^((100|[0-9]{1,2})%|[0-9]+)$`<br/>**Default:** `"10%"`|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*].reasons` | **Disruption reasons** - List of disruption methods that this budget applies to. If Reasons is not set, this budget applies to all methods.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*].reasons[*]` |**None**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `Underutilized`, `Empty`, `Drifted`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationBudgets[*].schedule` | **Schedule** - Specifies when a budget begins being active, following the upstream cronjob syntax. If omitted, the budget is always active. Timezones are not supported.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^(@(annually|yearly|monthly|weekly|daily|midnight|hourly))|((.+)\s(.+)\s(.+)\s(.+)\s(.+))$`<br/>|
| `global.nodePools.PATTERN[option#1].consolidationPolicy` | **Consolidation policy** - Describes which nodes Karpenter can disrupt through its consolidation algorithm. If using 'WhenEmptyOrUnderutilized', Karpenter will consider all nodes for consolidation and attempt to remove or replace Nodes when it discovers that the Node is empty or underutilized and could be changed to reduce cost. If using `WhenEmpty`, Karpenter will only consider nodes for consolidation that contain no workload pods.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `WhenEmptyOrUnderutilized`, `WhenEmpty`<br/>**Default:** `"WhenEmptyOrUnderutilized"`|
| `global.nodePools.PATTERN[option#1].customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeLabels[*]` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeTaints[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `NoSchedule`, `PreferNoSchedule`, `NoExecute`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].expireAfter` | **Expire after** - The duration the controller will wait before terminating a node, measured from when the node is created. Use either 'Never' or specify duration in the format `Xs`, `Xm`, `Xh`.|**Type:** `string`<br/>**Examples:** `"1h"`, `"30m"`, `"1h30m"`, `"Never"`, `"45s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^(([0-9]+(s|m|h))+|Never)$`<br/>**Default:** `"720h"`|
| `global.nodePools.PATTERN[option#1].libVolumeSizeGB` | **Lib volume size (GB)** - Size of the volume mounted at `/var/lib` on the worker nodes. This disk is shared between kubelet folder `/var/lib/kubelet` and containerd folder `/var/lib/containerd`s.|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `120`|
| `global.nodePools.PATTERN[option#1].limits` | **Nodepool limits** - These limits constrains the maximum amount of resources that the NodePool can consume|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].limits.cpu` |CPU limits are described with a DecimalSI value|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"1000"`|
| `global.nodePools.PATTERN[option#1].limits.memory` |Memory limits are described with a BinarySI value, such as 1000Gi.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"1000Gi"`|
| `global.nodePools.PATTERN[option#1].logVolumeSizeGB` | **Log volume size (GB)** - Size of the volume mounted at `/var/log` on the worker nodes.|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `30`|
| `global.nodePools.PATTERN[option#1].requirements` | **Nodepool requirements** - Requirements that constrain the parameters of provisioned nodes.|**Type:** `array`<br/>**Examples:** `[{"key":"karpenter.k8s.aws/instance-family","operator":"NotIn","values":["t3","t3a","t2"]},{"key":"karpenter.sh/capacity-type","operator":"In","values":["spot","on-demand"]}]`, `[{"key":"karpenter.k8s.aws/instance-cpu","operator":"In","values":["4","8","16","32"]},{"key":"karpenter.k8s.aws/instance-hypervisor","operator":"In","values":["nitro"]},{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `[{"key":"karpenter.k8s.aws/instance-family","operator":"NotIn","values":["t3","t3a","t2"]},{"key":"karpenter.sh/capacity-type","operator":"In","values":["spot","on-demand"]},{"key":"karpenter.k8s.aws/instance-cpu","operator":"In","values":["4","8","16","32"]},{"key":"karpenter.k8s.aws/instance-hypervisor","operator":"In","values":["nitro"]},{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]`|
| `global.nodePools.PATTERN[option#1].requirements[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].requirements[*].key` |The label key that the selector applies to.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].requirements[*].operator` |Represents a key's relationship to a set of values.|**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt`, `Lt`<br/>|
| `global.nodePools.PATTERN[option#1].requirements[*].values` |If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].requirements[*].values[*]` |**None**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `8`|
| `global.nodePools.PATTERN[option#1].subnetTags` | **Subnet tags** - Tags to filter which AWS subnets will be used for this node pool.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#1].subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.nodePools.PATTERN[option#1].terminationGracePeriod` | **Termination Grace Period** - The amount of time a Node can be draining before Karpenter forcibly cleans up the node. Pods blocking eviction like PDBs and do-not-disrupt will be respected during draining until the terminationGracePeriod is reached, where those pods will be forcibly deleted.|**Type:** `string`<br/>**Example:** `"48h"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^([0-9]+(s|m|h))+$`<br/>**Default:** `"30m"`|
| `global.nodePools.PATTERN[option#1].type` | **Node pool type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Must have value:** `karpenter`<br/>|
| `global.nodePools.PATTERN[option#1].type` | **Node pool type** - Controller that will manage the node pool. Only used to enable karpenter node pools.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Must have value:** `karpenter`<br/>|
| `global.nodePools.PATTERN[option#2].additionalSecurityGroups` | **Machine pool additional security groups** - Additional security groups that will be added to the machine pool nodes.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].additionalSecurityGroups[*]` | **security group**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].additionalSecurityGroups[*].id` | **Id of the security group** - ID of the security group that will be added to the machine pool nodes. The security group must exist.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].annotations` | **Annotations** - These annotations are added to all Kubernetes resources defining this node pool.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].annotations.PATTERN_2` | **Annotation**|**Type:** `string`<br/>**Key patterns:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>`PATTERN_2`=`^([a-zA-Z0-9/\.-]{1,253}/)?[a-zA-Z0-9/\._-]{1,63}$`<br/>|
| `global.nodePools.PATTERN[option#2].availabilityZones` | **Availability zones**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].availabilityZones[*]` | **Availability zone**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].awsNodeTerminationHandler` | **aws-node-termination-handler related settings** - Configuration for the ASG lifecycle hook used by aws-node-termination-handler|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].awsNodeTerminationHandler.heartbeatTimeoutSeconds` | **Heartbeat timeout for ASG lifecycle hook**|**Type:** `number`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeLabels[*]` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeTaints[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `NoSchedule`, `PreferNoSchedule`, `NoExecute`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].instanceType` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^[a-z][a-z0-9]*\.[a-z0-9]+$`<br/>|
| `global.nodePools.PATTERN[option#2].instanceTypeOverrides` | **Instance type overrides** - Ordered list of instance types to be used for the machine pool. The first instance type that is available in the region will be used. Read more in our docs https://docs.giantswarm.io/advanced/cluster-management/node-pools-capi/|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `[]`|
| `global.nodePools.PATTERN[option#2].instanceTypeOverrides[*]` | **EC2 instance type**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].instanceWarmup` | **Time interval, in seconds, between node replacement.**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].labels` | **Labels** - These labels are added to all Kubernetes resources defining this node pool.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].labels.PATTERN_2` | **Label**|**Type:** `string`<br/>**Key patterns:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>`PATTERN_2`=`^[a-zA-Z0-9/\._-]+$`<br/>**Value pattern:** `^[a-zA-Z0-9/\._-]*$`<br/>|
| `global.nodePools.PATTERN[option#2].libVolumeSizeGB` | **Lib volume size (GB)** - Size of the volume mounted at `/var/lib` on the worker nodes. This disk is shared between kubelet folder `/var/lib/kubelet` and containerd folder `/var/lib/containerd`s.|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `120`|
| `global.nodePools.PATTERN[option#2].logVolumeSizeGB` | **Log volume size (GB)** - Size of the volume mounted at `/var/log` on the worker nodes.|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `30`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck` | **Machine health check**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.diskFullContainerdTimeout` | **DiskFullContainerd timeout** - Determines how long a machine health check should wait for a node with condition DiskFullContainerd=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `""`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.diskFullKubeletTimeout` | **DiskFullKubelet timeout** - Determines how long a machine health check should wait for a node with condition DiskFullKubelet=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `""`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.diskFullVarLogTimeout` | **DiskFullVarLog timeout** - Determines how long a machine health check should wait for a node with condition DiskFullVarLog=True before considering a machine unhealthy. Use an empty value to not consider this condition.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `""`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.enabled` | **Enable**|**Type:** `boolean`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `true`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.maxUnhealthy` | **Maximum unhealthy nodes** - Defaults to 40% for control plane nodes and 20% for worker nodes.|**Type:** `string`<br/>**Example:** `"40%"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.nodeStartupTimeout` | **Node startup timeout** - Determines how long a machine health check should wait for a node to join the cluster, before considering a machine unhealthy.|**Type:** `string`<br/>**Examples:** `"10m"`, `"100s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"8m0s"`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.unhealthyNotReadyTimeout` | **Timeout for ready** - If a node is not in condition 'Ready' after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"10m0s"`|
| `global.nodePools.PATTERN[option#2].machineHealthCheck.unhealthyUnknownTimeout` | **Timeout for unknown condition** - If a node is in 'Unknown' condition after this timeout, it will be considered unhealthy.|**Type:** `string`<br/>**Example:** `"300s"`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"10m0s"`|
| `global.nodePools.PATTERN[option#2].maxHealthyPercentage` | **Maximum percentage of instances that can be in service when replacing instances.** - The percentage of capacity in ASG that can be in service and healthy, or pending, to support your workload when replacing instances. A larger range increases the number of instances that can be replaced at the same time. The difference between minHealthyPercentage and maxHealthyPercentage cannot be greater than 100.|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `100`|
| `global.nodePools.PATTERN[option#2].maxSize` | **Maximum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].minHealthyPercentage` | **Minimum percentage of instances that must remain healthy during node replacement.**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `90`|
| `global.nodePools.PATTERN[option#2].minSize` | **Minimum number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `8`|
| `global.nodePools.PATTERN[option#2].spotInstances` | **Spot instances** - Compared to on-demand instances, spot instances can help you save cost.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].spotInstances.enabled` | **Enable**|**Type:** `boolean`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `false`|
| `global.nodePools.PATTERN[option#2].spotInstances.maxPrice` | **Maximum price to pay per instance per hour, in USD.**|**Type:** `number`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].strategy` | **Update strategy** - Strategy to use when updating the machines.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].strategy.rollingUpdate` | **Rolling update strategy** - Rolling update config params.|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].strategy.rollingUpdate.deletePolicy` | **Delete policy** - DeletePolicy defines the policy used by the MachineDeployment to identify nodes to delete when downscaling. When no value is supplied, the default DeletePolicy of MachineSet is used.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Allowed values:** `Random`, `Newest`, `Oldest`<br/>|
| `global.nodePools.PATTERN[option#2].strategy.rollingUpdate.maxSurge` | **Max surge** - The maximum number of machines that can be scheduled above the desired number of machines. Value can be an absolute number (ex: 5) or a percentage of desired machines (ex: 10%). This can not be 0 if MaxUnavailable is 0. Absolute number is calculated from percentage by rounding up. Defaults to 1.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"1"`|
| `global.nodePools.PATTERN[option#2].strategy.rollingUpdate.maxUnavailable` | **Max unavailable** - The maximum number of machines that can be unavailable during the update. Value can be an absolute number (ex: 5) or a percentage of desired machines (ex: 10%). Absolute number is calculated from percentage by rounding down. This can not be 0 if MaxSurge is 0. Defaults to 0.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"0"`|
| `global.nodePools.PATTERN[option#2].subnetTags` | **Subnet tags** - Tags to filter which AWS subnets will be used for this node pool.|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].subnetTags[*]` | **Subnet tag**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN[option#2].subnetTags[*].*` | **Tag value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Value pattern:** `^[ a-zA-Z0-9\._:/=+-@]+$`<br/>|
| `global.nodePools.PATTERN[option#2].type` | **Node pool type** - Controller that will manage the node pool. Only used to enable karpenter node pools. Defaults to `machinepool` if not set.|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Must have value:** `machinepool`<br/>|

### Other global

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.managementCluster` | **Management cluster** - Name of the Cluster API cluster managing this workload cluster.|**Type:** `string`<br/>|

### Pod Security Standards
Properties within the `.global.podSecurityStandards` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.podSecurityStandards.enforced` | **Enforced**|**Type:** `boolean`<br/>**Default:** `true`|

### Release
Properties within the `.global.release` object
Information about the workload cluster release.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.release.version` | **Version**|**Type:** `string`<br/>|

### Other

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `baseDomain` | **Base DNS domain**|**Type:** `string`<br/>|
| `cluster` | **Cluster** - Helm values for the provider-independent cluster chart|**Type:** `object`<br/>**Default:** `{"providerIntegration":{"apps":{"certExporter":{"enable":true},"certManager":{"configTemplateName":"awsCertManagerHelmValues","enable":true},"chartOperatorExtensions":{"enable":true},"cilium":{"configTemplateName":"awsCiliumHelmValues","enable":true},"ciliumServiceMonitors":{"enable":true},"clusterAutoscaler":{"configTemplateName":"awsClusterAutoscalerHelmValues","enable":true},"coreDns":{"configTemplateName":"awsCorednsHelmValues","enable":true},"coreDnsExtensions":{"enable":true},"etcdDefrag":{"enable":true},"etcdKubernetesResourcesCountExporter":{"enable":true},"externalDns":{"configTemplateName":"awsExternalDnsHelmValues","enable":true},"k8sAuditMetrics":{"enable":true},"k8sDnsNodeCache":{"enable":true},"metricsServer":{"enable":true},"netExporter":{"enable":true},"networkPolicies":{"configTemplateName":"awsNetworkPoliciesHelmValues","enable":true},"nodeExporter":{"enable":true},"nodeProblemDetector":{"enable":true},"observabilityBundle":{"enable":true},"observabilityPolicies":{"enable":true},"priorityClasses":{"enable":true},"prometheusBlackboxExporter":{"enable":true},"securityBundle":{"configTemplateName":"awsSecurityBundleHelmValues","enable":true},"teleportKubeAgent":{"enable":true},"verticalPodAutoscaler":{"enable":true},"verticalPodAutoscalerCrd":{"enable":true}},"clusterAnnotationsTemplateName":"awsConnectivityLabels","components":{"systemd":{"timesyncd":{"ntp":["169.254.169.123"]}}},"connectivity":{"proxy":{"noProxy":{"templateName":"awsNoProxyList","value":["elb.amazonaws.com","169.254.169.254"]}}},"controlPlane":{"kubeadmConfig":{"clusterConfiguration":{"apiServer":{"apiAudiences":{"templateName":"awsApiServerApiAudiences"},"serviceAccountIssuers":[{"templateName":"awsIrsaServiceAccountIssuer"}]}},"files":[{"contentFrom":{"secret":{"key":"wait-elb-dns.sh","name":"provider-specific-files-5","prependClusterNameAsPrefix":true}},"path":"/opt/bin/wait-elb-dns.sh","permissions":"0755"}],"ignition":{"containerLinuxConfig":{"additionalConfig":{"storage":{"filesystems":[{"mount":{"device":"/dev/xvdc","format":"xfs","label":"etcd","wipeFilesystem":true},"name":"etcd"},{"mount":{"device":"/dev/xvdd","format":"xfs","label":"lib","wipeFilesystem":true},"name":"lib"},{"mount":{"device":"/dev/xvde","format":"xfs","label":"log","wipeFilesystem":true},"name":"log"}]},"systemd":{"units":[{"contents":{"install":{"wantedBy":["local-fs-pre.target"]},"mount":{"type":"xfs","what":"/dev/disk/by-label/etcd","where":"/var/lib/etcd"},"unit":{"defaultDependencies":false,"description":"etcd volume"}},"enabled":true,"name":"var-lib-etcd.mount"},{"contents":{"install":{"wantedBy":["local-fs-pre.target"]},"mount":{"type":"xfs","what":"/dev/disk/by-label/lib","where":"/var/lib"},"unit":{"defaultDependencies":false,"description":"var lib volume"}},"enabled":true,"name":"var-lib.mount"},{"contents":{"install":{"wantedBy":["local-fs-pre.target"]},"mount":{"type":"xfs","what":"/dev/disk/by-label/log","where":"/var/log"},"unit":{"defaultDependencies":false,"description":"log volume"}},"enabled":true,"name":"var-log.mount"}]}}}},"preKubeadmCommands":["/opt/bin/wait-elb-dns.sh"]},"resources":{"infrastructureMachineTemplate":{"group":"infrastructure.cluster.x-k8s.io","kind":"AWSMachineTemplate","version":"v1beta2"},"infrastructureMachineTemplateSpecTemplateName":"controlplane-awsmachinetemplate-spec"}},"environmentVariables":{"hostName":"COREOS_EC2_HOSTNAME","ipv4":"COREOS_EC2_IPV4_LOCAL"},"kubeadmConfig":{"files":[{"contentFrom":{"secret":{"key":"kubelet-aws-config.sh","name":"provider-specific-files-5","prependClusterNameAsPrefix":true}},"path":"/opt/bin/kubelet-aws-config.sh","permissions":"0755"},{"contentFrom":{"secret":{"key":"kubelet-aws-config.service","name":"provider-specific-files-5","prependClusterNameAsPrefix":true}},"path":"/etc/systemd/system/kubelet-aws-config.service","permissions":"0644"},{"contentFrom":{"secret":{"key":"99-unmanaged-devices.network","name":"provider-specific-files-5","prependClusterNameAsPrefix":true}},"path":"/etc/systemd/network/99-unmanaged-devices.network","permissions":"0644"}],"ignition":{"containerLinuxConfig":{"additionalConfig":{"systemd":{"units":[{"enabled":true,"name":"kubelet-aws-config.service"}]}}}}},"osImage":{"variant":"3"},"pauseProperties":{"global.connectivity.vpcMode":"private"},"provider":"aws","registry":{"templateName":"awsContainerImageRegistry"},"resourcesApi":{"bastionResourceEnabled":false,"cleanupHelmReleaseResourcesEnabled":true,"clusterResourceEnabled":true,"controlPlaneResourceEnabled":true,"helmRepositoryResourcesEnabled":true,"infrastructureCluster":{"group":"infrastructure.cluster.x-k8s.io","kind":"AWSCluster","version":"v1beta2"},"infrastructureMachinePool":{"group":"infrastructure.cluster.x-k8s.io","kind":"AWSMachinePool","version":"v1beta2"},"machineHealthCheckResourceEnabled":true,"machinePoolResourcesEnabled":true,"nodePoolKind":"MachinePool"},"useReleases":true,"workers":{"defaultNodePools":{"def00":{"customNodeLabels":["label=default"],"instanceType":"r6i.xlarge","instanceWarmup":600,"maxSize":3,"minHealthyPercentage":90,"minSize":3}},"kubeadmConfig":{"files":[],"ignition":{"containerLinuxConfig":{"additionalConfig":{"storage":{"filesystems":[{"mount":{"device":"/dev/xvdd","format":"xfs","label":"lib","wipeFilesystem":true},"name":"lib"},{"mount":{"device":"/dev/xvde","format":"xfs","label":"log","wipeFilesystem":true},"name":"log"}]},"systemd":{"units":[{"contents":{"install":{"wantedBy":["local-fs-pre.target"]},"mount":{"type":"xfs","what":"/dev/disk/by-label/lib","where":"/var/lib"},"unit":{"defaultDependencies":false,"description":"lib volume"}},"enabled":true,"name":"var-lib.mount"},{"contents":{"install":{"wantedBy":["local-fs-pre.target"]},"mount":{"type":"xfs","what":"/dev/disk/by-label/log","where":"/var/log"},"unit":{"defaultDependencies":false,"description":"log volume"}},"enabled":true,"name":"var-log.mount"}]}}}},"taints":[{"effect":"NoExecute","key":"ebs.csi.aws.com/agent-not-ready"}]}}}}`|
| `cluster-shared` | **Library chart**|**Type:** `object`<br/>|
| `managementCluster` | **Management cluster** - Name of the Cluster API cluster managing this workload cluster.|**Type:** `string`<br/>|
| `provider` | **Cluster API provider name**|**Type:** `string`<br/>|


<!-- DOCS_END -->
