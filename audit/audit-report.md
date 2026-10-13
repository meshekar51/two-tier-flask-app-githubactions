# Kyverno Policy Validation - Audit Report

| Field | Value |
|---|---|
| **Result** | **PASSED** |
| Repository | `meshekar51/two-tier-flask-app-githubactions` |
| Event | push |
| Ref | `main` |
| Commit | `78f0c198029d41e65dc265164677099ad68d4e69` |
| Triggered by | meshekar51 |
| Workflow run | https://github.com/meshekar51/two-tier-flask-app-githubactions/actions/runs/38369987456/attempts/1 |
| Generated (UTC) | 2026-10-13T08:33:06Z |
| Kyverno CLI | `ghcr.io/kyverno/kyverno-cli@sha256:ced7b2be0b04250cabfe695f15307f69eb715fe23234816388af4f3812915b2a` |
| Chart | `./helm/two-tier-flask-app` |
| Rendered manifests | 9 resources, sha256 `f9c305ef5ad90c8676d9f2b12ea2894bf5dd3e39cef6e5f1d0cc4b78ddbed5a3` |

## Summary

| Pass | Fail | Warn | Error | Skip |
|---|---|---|---|---|
| 1 | 0 | 0 | 0 | 0 |

## Policies evaluated

| File | SHA-256 |
|---|---|
| `./kyverno/policies/rendered-manifests.yaml` | `163f1784e334e083775895dc939e5e63a19ddd28ee3eb5db678c70b3bc436416` |

## Findings

| Result | Policy | Rule | Resource | Message |
|---|---|---|---|---|
| PASS | require-labels | check-for-flask-replicas | Deployment/default/app-two-tier-flask-app | validation rule 'check-for-flask-replicas' passed. |
