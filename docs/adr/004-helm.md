# ADR-004: Helm for Application Deployment

**Status:** Accepted
**Date:** 2026-01-18

Teams need a standardized way to deploy services without writing their own manifests from scratch. Helm is what most teams already know, values files let me bake in sane defaults (resource limits, health checks, security context) while still letting teams override, and versioned releases make rollback easy.

I own the chart so I need to keep it updated and handle feature requests. Less flexible than raw manifests, but that's kind of the point.
