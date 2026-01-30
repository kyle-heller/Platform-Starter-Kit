# Team Onboarding Guide

Covers getting your team set up on the shared cluster and deploying your first service.

## Prerequisites

Before you begin, ensure you have:

1. **kubectl** installed and configured
2. Access to your team's namespace (e.g., `team-alpha`)
3. Your container image pushed to a registry

## Quick Start

### 1. Verify Access

First, verify you can access your namespace:

```bash
kubectl get pods -n team-alpha
```

If you see "No resources found", that's expected for a new namespace.

### 2. Deploy Using the Web Service Helm Chart

The platform provides a standard Helm chart for web services.

Create a `values.yaml` for your service:

```yaml
image:
  repository: your-registry/your-app
  tag: "1.0.0"

replicaCount: 2

service:
  port: 80
  targetPort: 8080

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi

healthCheck:
  enabled: true
  path: /health
  port: 8080

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: myapp-tls
      hosts:
        - myapp.example.com
```

Deploy with Helm:

```bash
helm install my-app ../helm-charts/web-service \
  -n team-alpha \
  -f values.yaml
```

### 3. Verify Deployment

```bash
# Check pods are running
kubectl get pods -n team-alpha

# Check service is created
kubectl get svc -n team-alpha

# Check ingress (if enabled)
kubectl get ingress -n team-alpha

# View logs
kubectl logs -n team-alpha -l app.kubernetes.io/name=web-service
```

## Resource Limits

Your namespace has resource quotas. Check current usage:

```bash
kubectl describe resourcequota -n team-alpha
```

Default limits per container:
- CPU: 500m (0.5 cores)
- Memory: 512Mi

Maximum per container:
- CPU: 2 cores
- Memory: 4Gi

## Networking

### Internal Communication

Pods within your namespace can communicate freely. To call another service:

```
http://service-name.team-alpha.svc.cluster.local:port
```

### External Access

Use Ingress for external traffic. The platform automatically:
- Routes through the shared load balancer
- Provisions TLS certificates via cert-manager
- Applies rate limiting and security headers

### Cross-Namespace Communication

By default, your pods cannot communicate with other namespaces. If you need cross-namespace access, contact the platform team.

## Secrets Management

Store secrets in Kubernetes Secrets:

```bash
kubectl create secret generic my-secret \
  -n team-alpha \
  --from-literal=API_KEY=your-api-key
```

Reference in your values.yaml:

```yaml
envFrom:
  - secretRef:
      name: my-secret
```

## Troubleshooting

### Pod not starting

```bash
# Check pod status
kubectl describe pod <pod-name> -n team-alpha

# Common issues:
# - ImagePullBackOff: Check image name and registry access
# - CrashLoopBackOff: Check logs for application errors
# - Pending: Check resource quota usage
```

### Can't reach service

```bash
# Check service endpoints
kubectl get endpoints <service-name> -n team-alpha

# Check network policies
kubectl get networkpolicy -n team-alpha
```

### Certificate not issued

```bash
# Check certificate status
kubectl get certificate -n team-alpha

# Check cert-manager logs
kubectl logs -n cert-manager -l app=cert-manager
```

## Getting Help

- Platform team Slack: #platform-support
- Email: platform@company.com
- On-call: PagerDuty escalation

## Next Steps

- [Architecture Decisions](./architecture-decisions.md)
- [Helm Chart Reference](../helm-charts/web-service/README.md)
