.PHONY: help init plan apply destroy lint validate clean

# Default environment
ENV ?= dev

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Terraform commands
init: ## Initialize Terraform
	cd terraform/environments/$(ENV) && terraform init

plan: ## Plan Terraform changes
	cd terraform/environments/$(ENV) && terraform plan

apply: ## Apply Terraform changes
	cd terraform/environments/$(ENV) && terraform apply

destroy: ## Destroy Terraform resources
	cd terraform/environments/$(ENV) && terraform destroy

# Validation
lint: ## Lint all configuration files
	@echo "Linting Terraform..."
	cd terraform && terraform fmt -check -recursive
	@echo "Linting Helm chart..."
	helm lint helm-charts/web-service
	@echo "Validating Kubernetes manifests..."
	kubectl apply --dry-run=client -f team-onboarding/

validate: ## Validate Terraform configuration
	cd terraform/environments/$(ENV) && terraform validate

# Helm commands
helm-template: ## Render Helm templates locally
	helm template test-release helm-charts/web-service

helm-lint: ## Lint Helm chart
	helm lint helm-charts/web-service

# Team management
onboard-team: ## Onboard a new team (usage: make onboard-team TEAM=alpha)
ifndef TEAM
	$(error TEAM is not set. Usage: make onboard-team TEAM=alpha)
endif
	./scripts/onboard-team.sh $(TEAM) $(ENV)

# Kubernetes commands
get-kubeconfig: ## Get kubeconfig for the cluster
	az aks get-credentials --resource-group platform-$(ENV)-rg --name platform-$(ENV)

# Cleanup
clean: ## Clean up generated files
	rm -rf terraform/environments/*/terraform.tfstate*
	rm -rf terraform/environments/*/.terraform
	rm -rf terraform/environments/*/.terraform.lock.hcl
