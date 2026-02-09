# ADR-010: OPA Gatekeeper for Policy Enforcement

**Status:** Accepted
**Date:** 2026-02-10

PSS handles pod security but I need broader policy enforcement: required labels, image registry restrictions, resource limits. OPA Gatekeeper with constraints from the gatekeeper-library.

Started with four constraints (required labels, no privileged containers, resource limits, allowed registries). Using audit mode initially so I can see violations without blocking deployments.

Another component to run and upgrade. Rego has a learning curve if I need custom policies beyond the library. Some overlap with PSS on the security side. PSS for pod security baseline, Gatekeeper for everything else.
