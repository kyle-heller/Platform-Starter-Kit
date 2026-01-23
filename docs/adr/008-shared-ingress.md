# ADR-008: Shared Ingress Controller

**Status:** Accepted (may be superseded by ADR-009)
**Date:** 2026-01-22

Teams share a single ingress-nginx deployment. One LoadBalancer, centralized TLS termination.

Cost savings vs per-team ingress controllers. Tradeoff is shared capacity and a single point of failure (mitigated by running multiple replicas). Teams can't customize controller-level settings but that's acceptable, they configure routing via Ingress resources.
