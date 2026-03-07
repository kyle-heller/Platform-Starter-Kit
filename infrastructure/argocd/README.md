# ArgoCD

GitOps continuous delivery for Kubernetes.

## Install

```bash
# Create namespace
kubectl apply -f infrastructure/argocd/namespace.yaml

# Install ArgoCD via Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.service.type=LoadBalancer

# Wait for rollout
kubectl rollout status deployment/argocd-server -n argocd

# Get initial admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d
```

## Applications

Application manifests live in `applications/`. Apply them after ArgoCD is running:

```bash
kubectl apply -f infrastructure/argocd/applications/
```

## Access

Port-forward for local access:

```bash
kubectl port-forward svc/argocd-server -n argocd 8443:443
```

Then open https://localhost:8443 (username: `admin`, password from above).
