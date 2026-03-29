# OPA Gatekeeper

Policy enforcement for the platform using OPA Gatekeeper constraint templates.

## Installation

```bash
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm install gatekeeper gatekeeper/gatekeeper \
  --namespace gatekeeper-system --create-namespace \
  --set replicas=2

# Install the community constraint template library
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/requiredlabels/template.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/containerresourcelimits/template.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/allowedrepos/template.yaml

# Install custom constraint templates
kubectl apply -f infrastructure/gatekeeper/templates/
```

## Applying Constraints

```bash
kubectl apply -f infrastructure/gatekeeper/constraints/
```

## Policies

### Community Templates

| Constraint | Description |
|-----------|-------------|
| require-labels | Require `team` and `environment` labels on namespaces |
| block-privileged | Block privileged containers |
| require-resource-limits | Require CPU and memory limits on containers |
| allowed-repos | Restrict image pulls to approved registries |

### Custom Templates

| Constraint | Template | Description |
|-----------|----------|-------------|
| block-latest-tag | K8sBlockLatestTag | Block `:latest` or untagged images - forces pinned versions |
| require-seccomp | K8sRequireSeccomp | Require a seccomp profile (RuntimeDefault or Localhost) |
| block-host-path | K8sBlockHostPath | Block hostPath volume mounts - prevents container escape |
| require-backup-label | K8sRequireBackupLabel | Require a backup label on StatefulSets (`enabled` or `opt-out`) |
