.PHONY: help init plan apply destroy lint validate clean gateway-install gatekeeper-install argocd-install kasten-install

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

# Infrastructure components
gateway-install: ## Install Gateway API CRDs and NGINX Gateway Fabric
	kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
	helm repo add nginx-gateway https://nginx.org/charts
	helm install nginx-gateway nginx-gateway/nginx-gateway-fabric \
		--namespace gateway-system --create-namespace \
		--set service.type=LoadBalancer
	kubectl apply -f infrastructure/gateway-api/

argocd-install: ## Install ArgoCD and apply Application manifests
	kubectl apply -f infrastructure/argocd/namespace.yaml
	helm repo add argo https://argoproj.github.io/argo-helm
	helm install argocd argo/argo-cd \
		--namespace argocd \
		--set server.service.type=LoadBalancer
	kubectl rollout status deployment/argocd-server -n argocd
	kubectl apply -f infrastructure/argocd/applications/

kasten-install: ## Install Kasten K10 and apply backup manifests
	kubectl apply -f infrastructure/kasten/namespace.yaml
	helm repo add kasten https://charts.kasten.io/
	helm install k10 kasten/k10 \
		--namespace kasten-io \
		--set auth.tokenAuth.enabled=true
	kubectl rollout status deployment/gateway -n kasten-io --timeout=300s
	kubectl apply -f infrastructure/kasten/volume-snapshot-class.yaml
	kubectl apply -f infrastructure/kasten/backup-policy.yaml

gatekeeper-install: ## Install OPA Gatekeeper and apply constraints
	helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
	helm install gatekeeper gatekeeper/gatekeeper \
		--namespace gatekeeper-system --create-namespace \
		--set replicas=2
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/requiredlabels/template.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/containerresourcelimits/template.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/allowedrepos/template.yaml
	kubectl apply -f infrastructure/gatekeeper/constraints/

# Cleanup
clean: ## Clean up generated files
	rm -rf terraform/environments/*/terraform.tfstate*
	rm -rf terraform/environments/*/.terraform
	rm -rf terraform/environments/*/.terraform.lock.hcl
