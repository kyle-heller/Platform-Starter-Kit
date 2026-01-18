# web-service

Standard Helm chart for deploying web services on the platform.

## Usage

```bash
helm install my-app ./helm-charts/web-service \
  -n team-alpha \
  -f values.yaml
```

## Configuration

See [values.yaml](values.yaml) for all available options. Key settings:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image | `nginx` |
| `image.tag` | Image tag | `1.25` |
| `replicaCount` | Number of replicas | `2` |
| `service.port` | Service port | `80` |
| `service.targetPort` | Container port | `8080` |
| `ingress.enabled` | Enable ingress | `false` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `healthCheck.path` | Liveness probe path | `/health` |
| `gateway.enabled` | Use Gateway API instead of Ingress | `false` |

## Security defaults

The chart enforces security best practices out of the box:

- Runs as non-root (UID 1000)
- Read-only root filesystem
- Drops all Linux capabilities
- No privilege escalation

Override `writablePaths` if your app needs to write to specific directories.

## Example

See [values-example.yaml](values-example.yaml) for a complete working configuration.
