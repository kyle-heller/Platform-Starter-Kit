# Gateway API

Gateway API resources for the platform. Replaces traditional Ingress with the more expressive Gateway API model.

## Prerequisites

Install the Gateway API CRDs and a supported controller:

```bash
# Install Gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml

# Install NGINX Gateway Fabric
helm repo add nginx-gateway https://nginx.org/charts
helm install nginx-gateway nginx-gateway/nginx-gateway-fabric \
  --namespace gateway-system --create-namespace \
  --set service.type=LoadBalancer
```

## Usage

Apply the GatewayClass and Gateway:

```bash
kubectl apply -f infrastructure/gateway-api/
```

Teams create HTTPRoute resources in their namespaces to route traffic through the gateway. The web-service Helm chart includes an HTTPRoute template - enable it with `gateway.enabled=true`.
