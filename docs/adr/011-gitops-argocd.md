# ADR-011: GitOps with ArgoCD

**Status:** Accepted
**Date:** 2026-03-07

Been applying manifests manually with kubectl and Helm. As more teams onboard, there needs to be a repeatable, auditable way to deploy, and I don't want the platform engineer to be the bottleneck for every rollout.

ArgoCD for GitOps. Applications are defined as ArgoCD Application resources, each pointing at a Git repo + path. Deployments sync automatically when the repo changes. Git becomes the source of truth (every change is a commit with an author), self-heal catches manual drift, and the UI gives visibility into sync status and rollback.

Still need to figure out the secrets story. Can't commit secrets to Git, so external-secrets or sealed-secrets is next. CI builds images but doesn't update manifests yet either, need an image updater or a CI step to bump tags.
