# ADR-002: Namespace-per-Team Isolation

**Status:** Accepted
**Date:** 2026-01-16

Multiple teams share the cluster. One namespace per team with RBAC, ResourceQuotas, and NetworkPolicies gives logical isolation without the operational cost of separate clusters. RBAC scoped to namespace keeps teams out of each other's resources, quotas prevent one team from starving others, and NetworkPolicies control east-west traffic.

Considered cluster-per-team but that's way more overhead to manage at this stage. Can revisit if isolation requirements get stricter. Main risk is that RBAC config needs to be correct from day one, and noisy neighbors can still impact node-level resources.
