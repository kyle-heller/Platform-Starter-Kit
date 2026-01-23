# ADR-006: cert-manager for TLS

**Status:** Accepted
**Date:** 2026-01-22

Straightforward decision. cert-manager with Let's Encrypt handles certificate lifecycle automatically. Free certs, auto-renewal, works with Ingress annotations. The alternative was manual cert management which nobody wants to do.

Only real risk is Let's Encrypt rate limits during testing, that's why there's a staging issuer.
