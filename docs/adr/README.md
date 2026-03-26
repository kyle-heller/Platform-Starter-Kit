# Architecture Decision Records

Decisions for the platform, roughly in order of when they came up.

| ADR | Decision | Status |
|-----|----------|--------|
| [001](001-aks.md) | Azure Kubernetes Service | Accepted |
| [002](002-namespace-per-team.md) | Namespace-per-Team Isolation | Accepted |
| [003](003-calico.md) | Calico for Network Policies | Accepted |
| [004](004-helm.md) | Helm for Application Deployment | Accepted |
| [005](005-default-deny.md) | Default-Deny Network Policies | Accepted |
| [006](006-cert-manager.md) | cert-manager for TLS | Accepted |
| [007](007-terraform.md) | Terraform for Infrastructure | Accepted |
| [008](008-shared-ingress.md) | Shared Ingress Controller | Accepted |
| [009](009-gateway-api.md) | Gateway API for Traffic Routing | Accepted |
| [010](010-gatekeeper.md) | OPA Gatekeeper for Policy Enforcement | Accepted |
| [011](011-gitops-argocd.md) | GitOps with ArgoCD | Accepted |
| [012](012-kasten-backup.md) | Kasten K10 for Kubernetes Backup | Accepted |

## TODO

- **Observability**: Prometheus/Grafana vs Azure Monitor, need to evaluate cost
- **Secrets**: Azure Key Vault integration via CSI driver or external-secrets operator
- **Image Updater**: ArgoCD Image Updater or CI-driven manifest updates for new tags
