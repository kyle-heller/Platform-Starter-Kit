# Platform Starter Kit

Kubernetes platform setup for onboarding development teams. Handles:

1. **Infrastructure** - Terraform modules for AKS with Azure AD RBAC
2. **Team onboarding** - Namespace isolation with RBAC, quotas, network policies, PSS
3. **Application deployment** - Helm chart with sane defaults
4. **Security** - Gatekeeper policies, Gateway API, cert-manager

## Quick Start

### Prerequisites

- Terraform >= 1.5
- kubectl >= 1.28
- Helm >= 3.12
- Azure CLI
- An Azure subscription

### 1. Provision the Cluster

```bash
az login
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl

```bash
az aks get-credentials --resource-group platform-dev-rg --name platform-dev
```

### 3. Install Infrastructure Components

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set installCRDs=true

kubectl apply -f infrastructure/cert-manager/cluster-issuer.yaml
```

### 4. Onboard a Team

```bash
./scripts/onboard-team.sh alpha dev

# or manually
kubectl apply -k team-onboarding/
```

### 5. Deploy an Application

```bash
helm install my-app helm-charts/web-service \
  -n team-alpha \
  -f helm-charts/web-service/values-prod.yaml \
  --set image.repository=myregistry.azurecr.io/myapp
```

## Repo Structure

```
terraform/
  modules/aks-cluster/         # AKS module with Azure AD RBAC
  modules/acr/                 # Azure Container Registry module
  environments/{dev,prod}/     # Per-environment configs + remote state
team-onboarding/               # Namespace templates (RBAC, quotas, netpol, PSS labels)
helm-charts/web-service/       # Helm chart with dev/prod value overrides
infrastructure/
  cert-manager/                # ClusterIssuers for Let's Encrypt
  ingress-nginx/               # Shared ingress controller
  gateway-api/                 # GatewayClass + Gateway (HTTPRoute in Helm chart)
  pod-security/                # PSS admission config (restricted profile)
  gatekeeper/                  # OPA policy constraints
  argocd/                      # ArgoCD install + Application manifests
scripts/
  onboard-team.sh              # Automates namespace + RBAC + quota setup
docs/
  architecture-decisions.md    # ADRs
  onboarding-guide.md          # For dev teams
```

## Make Targets

```
make init                      # terraform init
make plan                      # terraform plan
make apply                     # terraform apply
make lint                      # terraform fmt + helm lint + kubectl dry-run
make onboard-team TEAM=alpha   # run onboarding script
make gateway-install           # install Gateway API + NGINX Gateway Fabric
make argocd-install            # install ArgoCD + apply Applications
make gatekeeper-install        # install Gatekeeper + apply constraints
```

Dev cluster runs about ~$80/month (2x B2s nodes + LB). Run `terraform destroy` when not using it.

## Docs

- [Team Onboarding Guide](docs/onboarding-guide.md)
- [Architecture Decisions](docs/architecture-decisions.md)

## License

MIT
