# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-aws version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-aws/values.schema.json -o helm/cluster-aws/README.md

-->

<!-- DOCS_START -->

<div class="crd-schema-version">
  <h2 class="headline-with-link">
    <a class="header-link" href="#">
      <i class="fa fa-link"></i>
    </a>Chart Configuration Reference
  </h2>
  <h3 class="headline-with-link">
    <a class="header-link" href="#AWS-settings">
      <i class="fa fa-link"></i>
    </a>AWS settings
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-additionalResourceTags">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.additionalResourceTags</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Additional resource tags.&nbsp;</span><span class="property-description">Additional tags to add to AWS resources created by the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-additionalResourceTags-*">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.additionalResourceTags.*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-ami">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.ami</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Amazon machine image (AMI).&nbsp;</span><span class="property-description">If specified, this image will be used to provision EC2 instances.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-awsClusterRoleIdentityName">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.awsClusterRoleIdentityName</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Cluster role identity name.&nbsp;</span><span class="property-description">Name of an AWSClusterRoleIdentity object. Learn more at https://docs.giantswarm.io/getting-started/cloud-provider-accounts/cluster-api/aws/#configure-the-awsclusterroleidentity .</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-flatcarAwsAccount">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.flatcarAwsAccount</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">AWS account owning Flatcar image.&nbsp;</span><span class="property-description">AWS account ID owning the Flatcar Container Linux AMI.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-providerSpecific-region">
          <i class="fa fa-link"></i>
        </a>.global.providerSpecific.region</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Region.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Apps">
      <i class="fa fa-link"></i>
    </a>Apps
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">App.&nbsp;</span><span class="property-description">Configuration of an default app that is part of the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-extraConfigs">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.extraConfigs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Extra config maps or secrets.&nbsp;</span><span class="property-description">Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-extraConfigs[*]">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.extraConfigs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Config map or secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-extraConfigs[*]-kind">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.extraConfigs[*].kind</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kind.&nbsp;</span><span class="property-description">Specifies whether the resource is a config map or a secret.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-extraConfigs[*]-name">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.extraConfigs[*].name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Name.&nbsp;</span><span class="property-description">Name of the config map or secret. The object must exist in the same namespace as the cluster App.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-extraConfigs[*]-optional">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.extraConfigs[*].optional</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Optional.&nbsp;</span><span class="property-description">Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsCloudControllerManager-values">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsCloudControllerManager.values</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Values.&nbsp;</span><span class="property-description">Values to be passed to the app. Values will have higher priority than values from configmaps.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">App.&nbsp;</span><span class="property-description">Configuration of an default app that is part of the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-extraConfigs">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.extraConfigs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Extra config maps or secrets.&nbsp;</span><span class="property-description">Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-extraConfigs[*]">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.extraConfigs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Config map or secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-extraConfigs[*]-kind">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.extraConfigs[*].kind</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kind.&nbsp;</span><span class="property-description">Specifies whether the resource is a config map or a secret.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-extraConfigs[*]-name">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.extraConfigs[*].name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Name.&nbsp;</span><span class="property-description">Name of the config map or secret. The object must exist in the same namespace as the cluster App.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-extraConfigs[*]-optional">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.extraConfigs[*].optional</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Optional.&nbsp;</span><span class="property-description">Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-awsEbsCsiDriver-values">
          <i class="fa fa-link"></i>
        </a>.global.apps.awsEbsCsiDriver.values</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Values.&nbsp;</span><span class="property-description">Values to be passed to the app. Values will have higher priority than values from configmaps.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">App.&nbsp;</span><span class="property-description">Configuration of an default app that is part of the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-extraConfigs">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.extraConfigs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Extra config maps or secrets.&nbsp;</span><span class="property-description">Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-extraConfigs[*]">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.extraConfigs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Config map or secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-extraConfigs[*]-kind">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.extraConfigs[*].kind</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kind.&nbsp;</span><span class="property-description">Specifies whether the resource is a config map or a secret.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-extraConfigs[*]-name">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.extraConfigs[*].name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Name.&nbsp;</span><span class="property-description">Name of the config map or secret. The object must exist in the same namespace as the cluster App.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-extraConfigs[*]-optional">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.extraConfigs[*].optional</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Optional.&nbsp;</span><span class="property-description">Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-cilium-values">
          <i class="fa fa-link"></i>
        </a>.global.apps.cilium.values</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Values.&nbsp;</span><span class="property-description">Values to be passed to the app. Values will have higher priority than values from configmaps.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">App.&nbsp;</span><span class="property-description">Configuration of an default app that is part of the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-extraConfigs">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.extraConfigs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Extra config maps or secrets.&nbsp;</span><span class="property-description">Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-extraConfigs[*]">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.extraConfigs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Config map or secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-extraConfigs[*]-kind">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.extraConfigs[*].kind</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kind.&nbsp;</span><span class="property-description">Specifies whether the resource is a config map or a secret.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-extraConfigs[*]-name">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.extraConfigs[*].name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Name.&nbsp;</span><span class="property-description">Name of the config map or secret. The object must exist in the same namespace as the cluster App.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-extraConfigs[*]-optional">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.extraConfigs[*].optional</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Optional.&nbsp;</span><span class="property-description">Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-coreDns-values">
          <i class="fa fa-link"></i>
        </a>.global.apps.coreDns.values</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Values.&nbsp;</span><span class="property-description">Values to be passed to the app. Values will have higher priority than values from configmaps.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">App.&nbsp;</span><span class="property-description">Configuration of an default app that is part of the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-extraConfigs">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.extraConfigs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Extra config maps or secrets.&nbsp;</span><span class="property-description">Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-extraConfigs[*]">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.extraConfigs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Config map or secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-extraConfigs[*]-kind">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.extraConfigs[*].kind</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kind.&nbsp;</span><span class="property-description">Specifies whether the resource is a config map or a secret.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-extraConfigs[*]-name">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.extraConfigs[*].name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Name.&nbsp;</span><span class="property-description">Name of the config map or secret. The object must exist in the same namespace as the cluster App.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-extraConfigs[*]-optional">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.extraConfigs[*].optional</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Optional.&nbsp;</span><span class="property-description">Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-apps-verticalPodAutoscalerCrd-values">
          <i class="fa fa-link"></i>
        </a>.global.apps.verticalPodAutoscalerCrd.values</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Values.&nbsp;</span><span class="property-description">Values to be passed to the app. Values will have higher priority than values from configmaps.</span><br /></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Components">
      <i class="fa fa-link"></i>
    </a>Components
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Containerd.&nbsp;</span><span class="property-description">Configuration of containerd.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Container registries.&nbsp;</span><span class="property-description">Endpoints and credentials configuration for container registries.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Registries.&nbsp;</span><span class="property-description">Container registries and mirrors</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Registry.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-credentials">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].credentials</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Credentials.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-credentials-auth">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].credentials.auth</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Auth.&nbsp;</span><span class="property-description">Base64-encoded string from the concatenation of the username, a colon, and the password.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-credentials-identitytoken">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].credentials.identitytoken</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Identity token.&nbsp;</span><span class="property-description">Used to authenticate the user and obtain an access token for the registry.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-credentials-password">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].credentials.password</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Password.&nbsp;</span><span class="property-description">Used to authenticate for the registry with username/password.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-credentials-username">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].credentials.username</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Username.&nbsp;</span><span class="property-description">Used to authenticate for the registry with username/password.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-components-containerd-containerRegistries-*[*]-endpoint">
          <i class="fa fa-link"></i>
        </a>.global.components.containerd.containerRegistries.*[*].endpoint</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Endpoint.&nbsp;</span><span class="property-description">Endpoint for the container registry.</span><br /></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Connectivity">
      <i class="fa fa-link"></i>
    </a>Connectivity
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-availabilityZoneUsageLimit">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.availabilityZoneUsageLimit</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Availability zones.&nbsp;</span><span class="property-description">Maximum number of availability zones (AZ) that should be used in a region. If a region has more than this number of AZs then this number of AZs will be picked randomly when creating subnets.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-baseDomain">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.baseDomain</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Base DNS domain.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-dns">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.dns</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">DNS.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-dns-resolverRulesOwnerAccount">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.dns.resolverRulesOwnerAccount</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Resolver rules owner.&nbsp;</span><span class="property-description">ID of the AWS account that created the resolver rules to be associated with the workload cluster VPC.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Network.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-allowAllEgress">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.allowAllEgress</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Allow all egress.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-internetGatewayId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.internetGatewayId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Internet Gateway ID.&nbsp;</span><span class="property-description">ID of the Internet gateway for the VPC.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-pods">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.pods</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Pods.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-pods-cidrBlocks">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.pods.cidrBlocks</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Pod subnets.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-pods-cidrBlocks[*]">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.pods.cidrBlocks[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Pod subnet.&nbsp;</span><span class="property-description">IPv4 address range for pods, in CIDR notation.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-services">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.services</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Services.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-services-cidrBlocks">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.services.cidrBlocks</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">K8s Service subnets.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-services-cidrBlocks[*]">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.services.cidrBlocks[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Service subnet.&nbsp;</span><span class="property-description">IPv4 address range for kubernetes services, in CIDR notation.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-vpcCidr">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.vpcCidr</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">VPC subnet.&nbsp;</span><span class="property-description">IPv4 address range to assign to this cluster's VPC, in CIDR notation.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-network-vpcId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.network.vpcId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">VPC id.&nbsp;</span><span class="property-description">ID of the VPC, where the cluster will be deployed. The VPC must exist and it case this is set, VPC wont be created by controllers.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-proxy">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.proxy</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Proxy.&nbsp;</span><span class="property-description">Whether/how outgoing traffic is routed through proxy servers.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-proxy-enabled">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.proxy.enabled</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Enable.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-proxy-httpProxy">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.proxy.httpProxy</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">HTTP proxy.&nbsp;</span><span class="property-description">To be passed to the HTTP_PROXY environment variable in all hosts.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-proxy-httpsProxy">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.proxy.httpsProxy</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">HTTPS proxy.&nbsp;</span><span class="property-description">To be passed to the HTTPS_PROXY environment variable in all hosts.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-proxy-noProxy">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.proxy.noProxy</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">No proxy.&nbsp;</span><span class="property-description">To be passed to the NO_PROXY environment variable in all hosts.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Subnets.&nbsp;</span><span class="property-description">Subnets are created and tagged based on this definition.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Subnet.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Network.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks[*]">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks[*]-availabilityZone">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks[*].availabilityZone</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Availability zone.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks[*]-cidr">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks[*].cidr</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Address range.&nbsp;</span><span class="property-description">IPv4 address range, in CIDR notation.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks[*]-tags">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks[*].tags</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Tags.&nbsp;</span><span class="property-description">AWS resource tags to assign to this subnet.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-cidrBlocks[*]-tags-*">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].cidrBlocks[*].tags.*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-id">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].id</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">ID of the subnet.&nbsp;</span><span class="property-description">ID of an existing subnet. When set, this subnet will be used instead of creating a new one.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-isPublic">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].isPublic</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Public.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-natGatewayId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].natGatewayId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">ID of the NAT Gateway.&nbsp;</span><span class="property-description">ID of the NAT Gateway used for this existing subnet.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-routeTableId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].routeTableId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">ID of route table.&nbsp;</span><span class="property-description">ID of the route table, assigned to the existing subnet. Must be provided when defining subnet via ID.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-tags">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].tags</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Tags.&nbsp;</span><span class="property-description">AWS resource tags to assign to this CIDR block.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-subnets[*]-tags-*">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.subnets[*].tags.*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-topology">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.topology</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Topology.&nbsp;</span><span class="property-description">Networking architecture between management cluster and workload cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-topology-mode">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.topology.mode</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Mode.&nbsp;</span><span class="property-description">Valid values: GiantSwarmManaged, UserManaged, None.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-topology-prefixListId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.topology.prefixListId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Prefix list ID.&nbsp;</span><span class="property-description">ID of the managed prefix list to use when the topology mode is set to 'UserManaged'.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-topology-transitGatewayId">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.topology.transitGatewayId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Transit gateway ID.&nbsp;</span><span class="property-description">If the topology mode is set to 'UserManaged', this can be used to specify the transit gateway to use.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-vpcEndpointMode">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.vpcEndpointMode</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">VPC endpoint mode.&nbsp;</span><span class="property-description">Who is reponsible for creation and management of VPC endpoints.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-connectivity-vpcMode">
          <i class="fa fa-link"></i>
        </a>.global.connectivity.vpcMode</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">VPC mode.&nbsp;</span><span class="property-description">Whether the cluser's VPC is created with public, internet facing resources (public subnets, NAT gateway) or not (private).</span><br /></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Control-plane">
      <i class="fa fa-link"></i>
    </a>Control plane
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-additionalSecurityGroups">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.additionalSecurityGroups</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Control Plane additional security groups.&nbsp;</span><span class="property-description">Additional security groups that will be added to the control plane nodes.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-additionalSecurityGroups[*]">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.additionalSecurityGroups[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Security group.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-additionalSecurityGroups[*]-id">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.additionalSecurityGroups[*].id</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Id of the security group.&nbsp;</span><span class="property-description">ID of the security group that will be added to the control plane nodes. The security group must exist.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiExtraArgs">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiExtraArgs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">API extra arguments.&nbsp;</span><span class="property-description">Extra arguments passed to the kubernetes API server.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiExtraArgs-PATTERN">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiExtraArgs.PATTERN</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">argument.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiExtraCertSANs">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiExtraCertSANs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">API extra cert SANs.&nbsp;</span><span class="property-description">Extra certs SANs passed to the kubeadmcontrolplane CR.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiExtraCertSANs[*]">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiExtraCertSANs[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">cert SAN.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiMode">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiMode</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">API mode.&nbsp;</span><span class="property-description">Whether the Kubernetes API server load balancer should be reachable from the internet (public) or internal only (private).</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-apiServerPort">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.apiServerPort</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">API server port.&nbsp;</span><span class="property-description">The API server Load Balancer port. This option sets the Spec.ClusterNetwork.APIServerPort field on the Cluster CR. In CAPI this field isn't used currently. It is instead used in providers. In CAPA this sets only the public facing port of the Load Balancer. In CAPZ both the public facing and the destination port are set to this value. CAPV and CAPVCD do not use it.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-containerdVolumeSizeGB">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.containerdVolumeSizeGB</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Containerd volume size (GB).&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-etcdVolumeSizeGB">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.etcdVolumeSizeGB</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Etcd volume size (GB).&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-instanceType">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.instanceType</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">EC2 instance type.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-kubeletVolumeSizeGB">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.kubeletVolumeSizeGB</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Kubelet volume size (GB).&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-loadBalancerIngressAllowCidrBlocks">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.loadBalancerIngressAllowCidrBlocks</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Load balancer allow list.&nbsp;</span><span class="property-description">IPv4 address ranges that are allowed to connect to the control plane load balancer, in CIDR notation. When setting this field, remember to add the Management cluster Nat Gateway IPs provided by Giant Swarm so that the cluster can still be managed. These Nat Gateway IPs can be found in the Management Cluster AWSCluster '.status.networkStatus.natGatewaysIPs' field.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-loadBalancerIngressAllowCidrBlocks[*]">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.loadBalancerIngressAllowCidrBlocks[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Address range.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Machine health check.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck-enabled">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck.enabled</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Enable.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck-maxUnhealthy">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck.maxUnhealthy</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Maximum unhealthy nodes.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck-nodeStartupTimeout">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck.nodeStartupTimeout</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Node startup timeout.&nbsp;</span><span class="property-description">Determines how long a machine health check should wait for a node to join the cluster, before considering a machine unhealthy.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck-unhealthyNotReadyTimeout">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck.unhealthyNotReadyTimeout</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Timeout for ready.&nbsp;</span><span class="property-description">If a node is not in condition 'Ready' after this timeout, it will be considered unhealthy.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-machineHealthCheck-unhealthyUnknownTimeout">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.machineHealthCheck.unhealthyUnknownTimeout</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Timeout for unknown condition.&nbsp;</span><span class="property-description">If a node is in 'Unknown' condition after this timeout, it will be considered unhealthy.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">OIDC authentication.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc-caPem">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc.caPem</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Certificate authority.&nbsp;</span><span class="property-description">Identity provider's CA certificate in PEM format.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc-clientId">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc.clientId</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Client ID.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc-groupsClaim">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc.groupsClaim</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Groups claim.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc-issuerUrl">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc.issuerUrl</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Issuer URL.&nbsp;</span><span class="property-description">Exact issuer URL that will be included in identity tokens.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-oidc-usernameClaim">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.oidc.usernameClaim</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Username claim.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-rootVolumeSizeGB">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.rootVolumeSizeGB</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Root volume size (GB).&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-subnetTags">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.subnetTags</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Subnet tags.&nbsp;</span><span class="property-description">Tags to select AWS resources for the control plane by.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-subnetTags[*]">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.subnetTags[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Subnet tag.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-controlPlane-subnetTags[*]-*">
          <i class="fa fa-link"></i>
        </a>.global.controlPlane.subnetTags[*].*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Internal">
      <i class="fa fa-link"></i>
    </a>Internal
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-cgroupsv1">
          <i class="fa fa-link"></i>
        </a>.internal.cgroupsv1</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">CGroups v1.&nbsp;</span><span class="property-description">Force use of CGroups v1 for whole cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-hashSalt">
          <i class="fa fa-link"></i>
        </a>.internal.hashSalt</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Hash salt.&nbsp;</span><span class="property-description">If specified, this token is used as a salt to the hash suffix of some resource names. Can be used to force-recreate some resources.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-kubernetesVersion">
          <i class="fa fa-link"></i>
        </a>.internal.kubernetesVersion</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Kubernetes version.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration">
          <i class="fa fa-link"></i>
        </a>.internal.migration</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Migration values.&nbsp;</span><span class="property-description">Section used for migration of cluster from vintage to CAPI</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-apiBindPort">
          <i class="fa fa-link"></i>
        </a>.internal.migration.apiBindPort</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Kubernetes API bind port.&nbsp;</span><span class="property-description">Kubernetes API bind port used for kube api pod</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Control Plane extra files.&nbsp;</span><span class="property-description">Additional fiels that will be provisioned to control-plane nodes, reference is from secret in the same namespace.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">file.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-contentFrom">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].contentFrom</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">content from.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-contentFrom-secret">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].contentFrom.secret</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">secret.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-contentFrom-secret-key">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].contentFrom.secret.key</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">secret key for file content.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-contentFrom-secret-name">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].contentFrom.secret.name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">secret name for file content.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-path">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].path</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">file path.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlaneExtraFiles[*]-permissions">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlaneExtraFiles[*].permissions</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">file permissions in form 0644.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlanePostKubeadmCommands">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlanePostKubeadmCommands</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Control Plane Post Kubeadm Commands.&nbsp;</span><span class="property-description">Additional Post-Kubeadm Commands executed on the control plane node.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlanePostKubeadmCommands[*]">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlanePostKubeadmCommands[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">command.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlanePreKubeadmCommands">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlanePreKubeadmCommands</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Control Plane Pre Kubeadm Commands.&nbsp;</span><span class="property-description">Additional Pre-Kubeadm Commands executed on the control plane node.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-controlPlanePreKubeadmCommands[*]">
          <i class="fa fa-link"></i>
        </a>.internal.migration.controlPlanePreKubeadmCommands[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">command.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-etcdExtraArgs">
          <i class="fa fa-link"></i>
        </a>.internal.migration.etcdExtraArgs</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Etcd extra arguments.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-etcdExtraArgs-PATTERN">
          <i class="fa fa-link"></i>
        </a>.internal.migration.etcdExtraArgs.PATTERN</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">argument.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-migration-irsaAdditionalDomain">
          <i class="fa fa-link"></i>
        </a>.internal.migration.irsaAdditionalDomain</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">IRSA additional domain.&nbsp;</span><span class="property-description">Additional domain to be added to IRSA trust relationship.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-sandboxContainerImage">
          <i class="fa fa-link"></i>
        </a>.internal.sandboxContainerImage</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Sandbox image.&nbsp;</span><span class="property-description">The image used by sandbox / pause container</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-sandboxContainerImage-name">
          <i class="fa fa-link"></i>
        </a>.internal.sandboxContainerImage.name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Repository.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-sandboxContainerImage-registry">
          <i class="fa fa-link"></i>
        </a>.internal.sandboxContainerImage.registry</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Registry.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-sandboxContainerImage-tag">
          <i class="fa fa-link"></i>
        </a>.internal.sandboxContainerImage.tag</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-teleport">
          <i class="fa fa-link"></i>
        </a>.internal.teleport</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Teleport.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-teleport-enabled">
          <i class="fa fa-link"></i>
        </a>.internal.teleport.enabled</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Enable teleport.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-teleport-proxyAddr">
          <i class="fa fa-link"></i>
        </a>.internal.teleport.proxyAddr</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Teleport proxy address.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#internal-teleport-version">
          <i class="fa fa-link"></i>
        </a>.internal.teleport.version</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Teleport version.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Kubectl-image">
      <i class="fa fa-link"></i>
    </a>Kubectl image
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#kubectlImage-name">
          <i class="fa fa-link"></i>
        </a>.kubectlImage.name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Repository.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#kubectlImage-registry">
          <i class="fa fa-link"></i>
        </a>.kubectlImage.registry</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Registry.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#kubectlImage-tag">
          <i class="fa fa-link"></i>
        </a>.kubectlImage.tag</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Metadata">
      <i class="fa fa-link"></i>
    </a>Metadata
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-metadata-description">
          <i class="fa fa-link"></i>
        </a>.global.metadata.description</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Cluster description.&nbsp;</span><span class="property-description">User-friendly description of the cluster's purpose.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-metadata-name">
          <i class="fa fa-link"></i>
        </a>.global.metadata.name</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Cluster name.&nbsp;</span><span class="property-description">Unique identifier, cannot be changed after creation.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-metadata-organization">
          <i class="fa fa-link"></i>
        </a>.global.metadata.organization</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Organization.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-metadata-preventDeletion">
          <i class="fa fa-link"></i>
        </a>.global.metadata.preventDeletion</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Prevent cluster deletion.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-metadata-servicePriority">
          <i class="fa fa-link"></i>
        </a>.global.metadata.servicePriority</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Service priority.&nbsp;</span><span class="property-description">The relative importance of this cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Node-pools">
      <i class="fa fa-link"></i>
    </a>Node pools
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Node pool.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-additionalSecurityGroups">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.additionalSecurityGroups</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Machine pool additional security groups.&nbsp;</span><span class="property-description">Additional security groups that will be added to the machine pool nodes.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-additionalSecurityGroups[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.additionalSecurityGroups[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">security group.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-additionalSecurityGroups[*]-id">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.additionalSecurityGroups[*].id</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Id of the security group.&nbsp;</span><span class="property-description">ID of the security group that will be added to the machine pool nodes. The security group must exist.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-availabilityZones">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.availabilityZones</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Availability zones.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-availabilityZones[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.availabilityZones[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Availability zone.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeLabels">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeLabels</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Custom node labels.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeLabels[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeLabels[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Label.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeTaints">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeTaints</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Custom node taints.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeTaints[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeTaints[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeTaints[*]-effect">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeTaints[*].effect</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Effect.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeTaints[*]-key">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeTaints[*].key</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Key.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-customNodeTaints[*]-value">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.customNodeTaints[*].value</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-instanceType">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.instanceType</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">EC2 instance type.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-instanceTypeOverrides">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.instanceTypeOverrides</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Instance type overrides.&nbsp;</span><span class="property-description">Ordered list of instance types to be used for the machine pool. The first instance type that is available in the region will be used. Read more in our docs https://docs.giantswarm.io/advanced/cluster-management/node-pools-capi/</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-instanceTypeOverrides[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.instanceTypeOverrides[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">EC2 instance type.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-maxSize">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.maxSize</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Maximum number of nodes.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-minSize">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.minSize</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Minimum number of nodes.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-rootVolumeSizeGB">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.rootVolumeSizeGB</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>integer</em></span>&nbsp;<br /><span class="property-title">Root volume size (GB).&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-spotInstances">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.spotInstances</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Spot instances.&nbsp;</span><span class="property-description">Compared to on-demand instances, spot instances can help you save cost.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-spotInstances-enabled">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.spotInstances.enabled</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Enable.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-spotInstances-maxPrice">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.spotInstances.maxPrice</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>number</em></span>&nbsp;<br /><span class="property-title">Maximum price to pay per instance per hour, in USD..&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-subnetTags">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.subnetTags</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>array</em></span>&nbsp;<br /><span class="property-title">Subnet tags.&nbsp;</span><span class="property-description">Tags to filter which AWS subnets will be used for this node pool.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-subnetTags[*]">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.subnetTags[*]</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Subnet tag.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-nodePools-PATTERN-subnetTags[*]-*">
          <i class="fa fa-link"></i>
        </a>.global.nodePools.PATTERN.subnetTags[*].*</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Tag value.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Other-global">
      <i class="fa fa-link"></i>
    </a>Other global
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-managementCluster">
          <i class="fa fa-link"></i>
        </a>.global.managementCluster</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Management cluster.&nbsp;</span><span class="property-description">Name of the Cluster API cluster managing this workload cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Pod-Security-Standards">
      <i class="fa fa-link"></i>
    </a>Pod Security Standards
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#global-podSecurityStandards-enforced">
          <i class="fa fa-link"></i>
        </a>.global.podSecurityStandards.enforced</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>boolean</em></span>&nbsp;<br /><span class="property-title">Enforced.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <h3 class="headline-with-link">
    <a class="header-link" href="#Other">
      <i class="fa fa-link"></i>
    </a>Other
  </h3>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#baseDomain">
          <i class="fa fa-link"></i>
        </a>.baseDomain</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Base DNS domain.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#cluster">
          <i class="fa fa-link"></i>
        </a>.cluster</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Cluster.&nbsp;</span><span class="property-description">Helm values for the provider-independent cluster chart</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#cluster-shared">
          <i class="fa fa-link"></i>
        </a>.cluster-shared</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>object</em></span>&nbsp;<br /><span class="property-title">Library chart.&nbsp;</span></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#managementCluster">
          <i class="fa fa-link"></i>
        </a>.managementCluster</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Management cluster.&nbsp;</span><span class="property-description">Name of the Cluster API cluster managing this workload cluster.</span><br /></span>
      </div>
    </div>
  </div>
  <div class="property depth-0">
    <div class="property-header">
      <h4 class="property-path headline-with-link">
        <a class="header-link" href="#provider">
          <i class="fa fa-link"></i>
        </a>.provider</h4>
    </div>
    <div class="property-body">
      <div class="property-meta"><span class="property-type"><em>string</em></span>&nbsp;<br /><span class="property-title">Cluster API provider name.&nbsp;</span></span>
      </div>
    </div>
  </div></div>


<!-- DOCS_END -->
