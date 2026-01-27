# CLAUDE.md

## Codebase Overview

cluster-aws is a Helm chart that creates Cluster API (CAPA) Custom Resources for provisioning and managing Kubernetes clusters on AWS. It's part of the Giant Swarm platform and supports advanced features like Karpenter autoscaling, Cilium ENI networking, Crossplane-managed IAM, and multi-region deployments including China.

**Stack**: Helm, Cluster API, Crossplane, Karpenter, Cilium, Flux HelmReleases, Go (azs-getter tool)

**Structure**:
- `helm/cluster-aws/` - Main Helm chart with templates, values schema, and bootstrap scripts
- `azs-getter/` - Go CLI tool for fetching AWS availability zones
- `.github/workflows/` - CI/CD automation (validation, releases, AZ updates)

For detailed architecture, see [docs/CODEBASE_MAP.md](docs/CODEBASE_MAP.md).

## Key Commands

```bash
# Render templates locally
make template

# Render with server-side dry-run
make template-in-cluster

# Full regeneration (schema + docs + values)
make generate

# Lint chart
make lint-chart

# Test specific scenario
TEST_CASE=karpenter-full make template
```

## Important Notes

- `values.schema.json` is the source of truth - never edit `values.yaml` directly
- `zz_generated.*.yaml` workflows are managed by devctl - don't edit manually
- Template changes to `_control_plane.tpl` or `_machine_pools.tpl` trigger node rolling updates
- China regions require different endpoints and OIDC configuration
