# Kyverno Policy Validation - Audit Report

| Field | Value |
|---|---|
| **Result** | **PASSED** |
| Repository | `meshekar51/two-tier-flask-app-githubactions` |
| Event | push |
| Ref | `main` |
| Commit | `0b2733027e0d284d0b2bcbf7a087629cce782277` |
| Triggered by | meshekar51 |
| Workflow run | https://github.com/meshekar51/two-tier-flask-app-githubactions/actions/runs/38407763434/attempts/1 |
| Generated (UTC) | 2026-10-13T13:47:10Z |
| Kyverno CLI | `ghcr.io/kyverno/kyverno-cli@sha256:ced7b2be0b04250cabfe695f15307f69eb715fe23234816388af4f3812915b2a` |
| Chart | `./helm/two-tier-flask-app` |
| Rendered manifests | 9 resources, sha256 `da10eb0444a6660842a3be0e10f1108808edf75cf8ff1ae3702a5f3e6cc318c2` |

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
