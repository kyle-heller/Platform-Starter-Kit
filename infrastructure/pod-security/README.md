# Pod Security Standards

Enforces the Kubernetes Pod Security Standards at the cluster and namespace level.

## Cluster-Level Admission

The `admission-configuration.yaml` configures the PodSecurity admission controller to enforce the `restricted` profile by default. System namespaces are exempted.

To apply at the API server level, pass the config file to kube-apiserver:

```
--admission-control-config-file=/etc/kubernetes/admission/admission-configuration.yaml
```

On AKS, this is configured via the cluster security profile.

## Namespace-Level Labels

Each team namespace should include Pod Security labels. These are included in the team-onboarding namespace template:

```yaml
labels:
  pod-security.kubernetes.io/enforce: restricted
  pod-security.kubernetes.io/audit: restricted
  pod-security.kubernetes.io/warn: restricted
```

The `restricted` profile requires:
- Non-root containers
- No privilege escalation
- Drop ALL capabilities
- Read-only root filesystem (recommended)
- Seccomp profile set
