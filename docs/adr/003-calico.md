# ADR-003: Calico for Network Policies

**Status:** Accepted
**Date:** 2026-01-16

AKS supports Azure NPM and Calico for network policy. Went with Azure CNI + Calico. Azure CNI gives pods real VNet IPs which makes debugging much easier (no NAT to trace through), and Calico has full NetworkPolicy support including egress rules. Also supports GlobalNetworkPolicy if I need cluster-wide rules later.

Downside is it burns more IP addresses than kubenet, so the subnet needs to be sized accordingly.
