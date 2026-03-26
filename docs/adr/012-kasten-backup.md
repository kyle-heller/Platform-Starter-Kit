# ADR-012: Kasten K10 for Kubernetes Backup

**Status:** Accepted
**Date:** 2026-03-25

No backup or disaster recovery story right now. If a team loses a PVC or someone deletes a namespace, there's no recovery path.

Velero was the other option but K10's application-aware snapshots are a better fit - it understands that a StatefulSet + PVCs + ConfigMaps are one unit, not separate resources. Built-in scheduling and retention tiers (daily/weekly/monthly) without needing to wire up CronJobs. Free tier covers up to 5 nodes, no key needed.

Auth uses the kubelet managed identity (same as ACR) to write exports to an Azure Blob storage account. Separate Terraform module for the storage, GRS in prod for cross-region durability.

Added a Gatekeeper policy that requires StatefulSets to carry a `k10.kasten.io/backup` label, either `enabled` or `opt-out`. Teams have to explicitly decide. Stateless Deployments are excluded since they redeploy from Git anyway.

K10 needs ~2 cores and 2GB RAM so it won't fit on the dev cluster's B2s nodes. Dev Terraform module is commented out.
