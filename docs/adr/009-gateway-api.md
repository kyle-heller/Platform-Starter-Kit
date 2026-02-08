# ADR-009: Gateway API for Traffic Routing

**Status:** Accepted
**Date:** 2026-02-08

Ingress works fine but Gateway API is now GA and gives better separation between infra routing (Gateway, managed by platform team) and app routing (HTTPRoute, managed by each team). Wanted to get ahead of this since Ingress is effectively in maintenance mode upstream. More expressive routing too: header matching, traffic splitting, portable across controller implementations.

Teams can use either during transition. HTTPRoute template is in the Helm chart behind a `gateway.enabled` flag. Downside is supporting two routing mechanisms until I can deprecate Ingress, and Gateway API CRDs need to be installed separately.
