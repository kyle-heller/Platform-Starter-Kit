# ADR-007: Terraform for Infrastructure

**Status:** Accepted
**Date:** 2026-01-16

Need to codify the AKS cluster and networking setup. Terraform with Azure backend for state, industry standard, good Azure provider support. State file tracks what's deployed vs what's in code, and separate environments via directory structure keeps dev and prod cleanly isolated.

State locking is critical once multiple people touch infra. Remote backend handles this. Pinned to >= 1.5 to avoid version drift issues.
