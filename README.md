# Platform Starter Kit

Kubernetes platform setup for onboarding development teams. Handles:

1. **Infrastructure** - Terraform modules for AKS
2. **Team onboarding** - Namespace isolation with RBAC, quotas, network policies
3. **Application deployment** - Helm chart with sane defaults
4. **Infra components** - cert-manager and ingress-nginx

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
  --set image.repository=nginx \
  --set image.tag=latest
```

## Repo Structure

```
terraform/
  modules/aks-cluster/         # AKS module
  environments/{dev,prod}/     # Per-environment configs
team-onboarding/               # Namespace templates (RBAC, quotas, netpol)
helm-charts/web-service/       # Standard web service Helm chart
infrastructure/
  cert-manager/                # ClusterIssuers for Let's Encrypt
  ingress-nginx/               # Shared ingress controller
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
```

Dev cluster runs about ~$80/month (2x B2s nodes + LB). Run `terraform destroy` when not using it.

## Docs

- [Team Onboarding Guide](docs/onboarding-guide.md)
- [Architecture Decisions](docs/architecture-decisions.md)

## License

MIT
