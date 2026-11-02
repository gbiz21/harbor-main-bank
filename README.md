# Harbor & Main Bank

A fictional small bank built end to end as a learning platform: an on-prem data center on Proxmox, a migration plan, a Terraform Azure landing zone, a gated GitHub Actions pipeline, a private AKS workload, and the compliance evidence a regulated institution needs.

Status: Phase 0, building the on-prem estate.

## Map
| Folder | Holds |
| --- | --- |
| `docs/` | Design docs per phase, decisions (ADRs), diagrams as code, post-mortems, compliance evidence |
| `onprem/` | Build scripts and the seed database for the Proxmox estate |
| `platform/` | Terraform roots for the landing zone (mgmt, network, security, monitoring) per environment |
| `workloads/` | Terraform roots for the bank's application spoke |
| `app/` | The online-banking app, Dockerfile, Helm chart |
| `labs/` | Side labs (certificate rotation, drift detection) |
| `tools/` | Admin-box bootstrap and helper scripts |

## Phases
See `docs/` for one design doc per phase. The master plan and runbook live in Claude Docs; this repo is the source of truth for what exists.


