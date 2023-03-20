# cluster-aws

`cluster-aws` is an app that helps create a CRs for a Cluster API AWS cluster for Giant Swarm platform.

## Custom Subnet Layouts

As of v0.21.0 it possible to specify more complex subnet layouts that allow using different sets of subnets for different grouping of machines.

Subnet groupings can be defined by setting `.network.subnets`. For example, to have different subnets for control plane, worker and bastion nodes you might have something similar to the following:

```yaml
connectivity:
  availabilityZoneUsageLimit: 3
  network:
    vpcCidr: 10.0.0.0/16
  subnets:
  # Control plane nodes subnets
  - cidrBlocks:
    - cidr: 10.0.32.0/19
      availabilityZone: a
    - cidr: 10.0.64.0/19
      availabilityZone: b
    - cidr: 10.0.96.0/19
      availabilityZone: c
    isPublic: false
    tags:
      subnet.giantswarm.io/role: control-plane
  # Worker nodes subnets
  - cidrBlocks:
    - cidr: 10.0.128.0/19
      availabilityZone: a
    - cidr: 10.0.160.0/19
      availabilityZone: b
    - cidr: 10.0.192.0/19
      availabilityZone: c
    isPublic: false
    tags:
      subnet.giantswarm.io/role: workers
  # Bastion nodes subnets
  - cidrBlocks:
    - cidr: 10.0.0.0/24
      availabilityZone: a
    - cidr: 10.0.1.0/24
      availabilityZone: b
    - cidr: 10.0.2.0/24
      availabilityZone: c
    isPublic: true
    tags:
      subnet.giantswarm.io/role: bastion
  # Ingress load balancer subnets
  - cidrBlocks:
    - cidr: 10.0.3.0/24
      availabilityZone: a
      tags:
        Name: cluster-ingress-lb-a
    - cidr: 10.0.4.0/24
      availabilityZone: b
      tags:
        Name: cluster-ingress-lb-b
    - cidr: 10.0.5.0/24
      availabilityZone: c
      tags:
        Name: cluster-ingress-lb-c
    isPublic: true
    tags:
      subnet.giantswarm.io/role: ingress
```

The desired subnet can then be targetted by using the `subnetTags` value to set the AWS tags to match on. For example:

```yaml

bastion:
  subnetTags:
    - subnet.giantswarm.io/role: bastion

controlPlane:
  subnetTags:
    - subnet.giantswarm.io/role: control-plane

machinePools:
  def00:
    subnetTags:
      - subnet.giantswarm.io/role: workers
```

### API-server ELB subnets

Currently it's not possible to target the subnets used for the api-server ELB using the `subnetTags` approach like other resources. The ELB will be associated with the first grouping of subnets defined in the `network.subnets` list.

If you want the ELB to use its own subnets then you can add a new grouping **first** in the list specifically for the api-server ELB.

### VPC Endpoints subnets

You can have VPC Endpoints target specific subnets by using the `subnet.giantswarm.io/endpoints: "true"` on those subnets. E.g.

```yaml
# VPC endpoints
- cidrBlocks:
  - cidr: 10.233.19.0/24
    availabilityZone: a
  - cidr: 10.233.20.0/24
    availabilityZone: b
  - cidr: 10.233.21.0/24
    availabilityZone: c
  isPublic: true
  tags:
    subnet.giantswarm.io/role: attachments
    subnet.giantswarm.io/endpoints: "true"
```

If the `subnet.giantswarm.io/endpoints: "true"` tag isn't found on any subnets then it will default to using the first grouping of subnets.

### Transit Gateway Attachment subnets

> **Warning**
> Currently not possible, see [giantswarm/roadmap#1865](https://github.com/giantswarm/roadmap/issues/1865)

You can have Transit Gateway Attachments target specific subnets by using the `subnet.giantswarm.io/tgw-attachments: "true"` on those subnets. E.g.

```yaml
# TGW attachments
- cidrBlocks:
  - cidr: 10.233.19.0/24
    availabilityZone: a
  - cidr: 10.233.20.0/24
    availabilityZone: b
  - cidr: 10.233.21.0/24
    availabilityZone: c
  isPublic: true
  tags:
    subnet.giantswarm.io/role: attachments
    subnet.giantswarm.io/tgw-attachments: "true"
```

If the `subnet.giantswarm.io/tgw-attachments: "true"` tag isn't found on any subnets then it will default to using the first grouping of subnets.

### Ingress subnets

> **Warning**
> Currently not possible, see [giantswarm/roadmap#1866](https://github.com/giantswarm/roadmap/issues/1866)

## Upgrade Migrations

### Upgrading to `v0.21.0`

If your cluster previously has `network.vpcMode` set to private you will need to make a small change to your values when upgrading to this version.

If using the default list of subnets you will need to set the following in your values:

```yaml
network:
  subnets:
  - cidrBlocks:
    - cidr: 10.0.0.0/18
      availabilityZone: a
    - cidr: 10.0.64.0/18
      availabilityZone: b
    - cidr: 10.0.128.0/18
      availabilityZone: c
    isPublic: false
```

If you've specified your own CIDR blocks previous you'll need to convert those strings to the block structure like above. Be aware to make sure the correct availability zone is specified for each CIDR block.

### Upgrading to `v0.24.0`

You will need to change the definition of your machine pools from using a list to an object.
For example, instead of the following:

```yaml
machinePools:
- name: def00  # Name of node pool.
  availabilityZones: []
  instanceType: m5.xlarge
  minSize: 3  # Number of replicas in node pool.
  maxSize: 3
  rootVolumeSizeGB: 300
  customNodeLabels:
  - label=default
  customNodeTaints: []
```

You should have:

```yaml
machinePools:
  def00:  # Name of node pool.
    availabilityZones: []
    instanceType: m5.xlarge
    minSize: 3  # Number of replicas in node pool.
    maxSize: 3
    rootVolumeSizeGB: 300
    customNodeLabels:
    - label=default
    customNodeTaints: []
```
