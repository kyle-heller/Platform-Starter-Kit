# Kasten K10 - Kubernetes Backup

Backup setup for Kasten K10.

## Installation

```bash
# 1. Create namespace
kubectl apply -f infrastructure/kasten/namespace.yaml

# 2. Install K10 via Helm
helm repo add kasten https://charts.kasten.io/
helm install k10 kasten/k10 \
  --namespace kasten-io \
  --set auth.tokenAuth.enabled=true

# 3. Wait for pods
kubectl rollout status deployment/gateway -n kasten-io --timeout=300s

# 4. Apply VolumeSnapshotClass and backup policy
kubectl apply -f infrastructure/kasten/volume-snapshot-class.yaml
kubectl apply -f infrastructure/kasten/backup-policy.yaml
```

## License

The free starter edition covers clusters with **5 or fewer nodes**, no key needed.

For enterprise, see `license-secret.yaml.example` for three ways to apply a license. Never commit the actual license secret to the repo.

## Location Profile

The `location-profile.yaml` configures export to Azure Blob Storage using managed identity auth. Before applying:

1. Run `terraform output kasten_storage_account` to get the storage account name
2. Replace `STORAGE_ACCOUNT_NAME` in `location-profile.yaml`
3. `kubectl apply -f infrastructure/kasten/location-profile.yaml`

## Dashboard Access

```bash
# Port-forward the K10 gateway
kubectl --namespace kasten-io port-forward service/gateway 8080:8000

# Open http://127.0.0.1:8080/k10/
```

## Dev Cluster Note

K10 needs ~2 CPU cores and 2GB RAM. The dev cluster's B2s nodes don't have enough headroom after system pods, so K10 is prod only. The dev Terraform module is commented out in `terraform/environments/dev/main.tf`.

## Backup Label Requirement

A Gatekeeper policy requires StatefulSets to have a `k10.kasten.io/backup` label, either `enabled` or `opt-out`. Teams have to explicitly opt in or out. See `infrastructure/gatekeeper/templates/require-backup-label.yaml`.
