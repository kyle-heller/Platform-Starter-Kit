# cert-manager

Automatic TLS certificate management for Kubernetes.

## Installation

Install cert-manager using Helm:

```bash
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install cert-manager with CRDs
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```

## Apply ClusterIssuers

After cert-manager is running, apply the cluster issuers:

```bash
kubectl apply -f cluster-issuer.yaml
```

## Usage

Add these annotations to your Ingress to get automatic TLS:

```yaml
annotations:
  cert-manager.io/cluster-issuer: letsencrypt-prod
```

And add a TLS section:

```yaml
tls:
  - hosts:
      - app.example.com
    secretName: app-example-com-tls
```

## Testing

Use `letsencrypt-staging` first to avoid rate limits:

```yaml
annotations:
  cert-manager.io/cluster-issuer: letsencrypt-staging
```

Once working, switch to `letsencrypt-prod`.
