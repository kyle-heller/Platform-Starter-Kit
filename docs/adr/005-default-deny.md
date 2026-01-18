# ADR-005: Default-Deny Network Policies

**Status:** Accepted
**Date:** 2026-01-16

Default-deny. Deny all ingress and egress per namespace, then explicitly allow what's needed. Limits blast radius if a pod gets compromised, forces teams to declare dependencies upfront, matches zero-trust model.

More config required. Every namespace needs DNS, ingress, and external HTTPS allows at minimum. Will break things if I miss an allow rule (teams hit this during onboarding sometimes).
