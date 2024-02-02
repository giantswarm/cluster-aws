.PHONY: template
template: ## Output the rendered template yaml
	@cd helm/cluster-aws && helm template . -f ci/ci-values.yaml

ensure-schema-gen:
	@helm schema-gen --help &>/dev/null || helm plugin install https://github.com/mihaisee/helm-schema-gen.git

.PHONY: schema-gen
schema-gen: ensure-schema-gen ## Generates the values schema file
	@cd helm/cluster-aws && helm schema-gen values.yaml > values.schema.json

.PHONY: update-chart-deps
update-chart-deps: ## Update chart dependencies to latest (matching) version
	@cd helm/cluster-aws && helm dependency update
