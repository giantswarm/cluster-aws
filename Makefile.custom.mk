.PHONY: template
template:
	@cd helm/cluster-aws && \
		sed -i '' 's/version: \[/version: 1 #\[/' Chart.yaml && \
		helm template . && \
		sed -i '' 's/version: 1 #\[/version: \[/' Chart.yaml

ensure-schema-gen:
	@helm schema-gen --help &>/dev/null || helm plugin install https://github.com/mihaisee/helm-schema-gen.git

.PHONY: schema-gen
schema-gen: ensure-schema-gen ## Generates the values schema file
	@cd helm/cluster-aws && helm schema-gen values.yaml > values.schema.json

.PHONY: update-chart-deps
update-chart-deps: ## Update chart dependencies to latest (matching) version
	@cd helm/cluster-aws && \
	sed -i.bk 's/version: \[\[ .Version \]\]/version: 1/' Chart.yaml && \
	helm dependency update && \
	mv Chart.yaml.bk Chart.yaml
