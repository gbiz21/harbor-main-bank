# On-prem estate (Phase 0)

The estate is the BKRE build already running on VLAN 30 (`10.10.30.0/24`, forest `corp.bkre8tive.com`). See `docs/decisions/0002-reuse-bkre-estate-vlan30.md` for why. Runbook names on the left, real hosts on the right.

| Runbook name | Host | Role | VLAN · IP | VMID · node | Size (vCPU / RAM / disk) | OS | State | Built at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| HM-DC01 | BKR-DC01 | AD DS, DNS, GC, all FSMO | 30 · 10.10.30.10 | 300 · prox-main | 2 / 8 GB / 100 GB | Windows Server 2025 | built | before the project |
| (second DC) | BKR-DC02 | AD DS, DNS, GC | 30 · 10.10.30.11 | 301 · prox-alien | 2 / 8 GB / 100 GB | Windows Server 2025 | built | before the project |
| HM-FS01 | BKR-FS01 | File shares, DFS, backup target | 30 · 10.10.30.20 | 310 · prox-main | 2 / 8 GB / 100 GB | Windows Server 2025 | shares built; DFS, backups to do | P0-6 |
| HM-WEB01 | BKR-APP01 | IIS online banking app | 30 · 10.10.30.30 | 320 · prox-main | 2 / 8 GB / 100 GB | Windows Server 2025 | IIS only; app to deploy | P0-5 |
| HM-SQL01 | BKR-SQL01 | SQL Server, HarborMainCore | 30 · 10.10.30.31 | 330 · prox-main | 2 / 8 GB / 100 GB | Windows Server 2025 | engine to install | P0-4 |
| (workstation) | BKR-CL01 | Domain-joined staff client | 30 · 10.10.30.40 | 340 · prox-alien | 2 / 6 GB / 64 GB | Windows client | built | before the project |
| HM-OPS01 | HM-OPS01 | Linux admin box: tooling, SFTP landing for the HR feed | 30 · 10.10.30.50 | 352 · prox-main | 2 / 4 GB / 40 GB | Ubuntu 24.04 cloud image | built 2026-11-08 via API (`automation@pve`); Twingate, bootstrap, SFTP chroot to do | P0-2 |
| HM-PAW01 | HM-PAW01 | Windows admin workstation: RSAT, SSMS, only path to RDP | 30 · 10.10.30.51 | 353 · prox-alien | 2 / 4 GB / 100 GB | Windows Server 2025 (template) | to build | P0-7 |
| (new) | HM-SYNC01 | Entra Connect Sync only, Tier 0 member server | 30 · 10.10.30.52 | 350 · prox-main | 2 / 6 GB / 100 GB | Windows Server 2025 Desktop Experience (template) | cloned and started 2026-11-08 via API; OS config and domain join to do | HR-feed step 3 |
| (new) | HM-AUTO01 | HR-feed processor as a gMSA scheduled task; later Hybrid Runbook Worker | 30 · 10.10.30.53 | 351 · prox-main | 2 / 4 GB / 100 GB | Windows Server 2025 (template) | cloned and started 2026-11-08 via API; OS config and domain join to do | HR-feed step 2 |
| HM-MIG01 | HM-MIG01 | Azure Migrate appliance (physical-server discovery of the estate) | 30 · 10.10.30.54 | 354 · prox-main | 8 / 16 GB / 80 GB | Windows Server 2022 (Microsoft image) | to build | Phase 1 |
| (vendor) | hris-01 | mock ADP, the HRIS stand-in | 60 · 10.10.60.20 | 120 · prox-main | 2 / 2 GB / 20 GB | Ubuntu 24.04 cloud image | built 2026-11-03, app live 2026-11-07 | HR-feed step 0 |
| (vendor) | itsm-01 | mock TeamDynamix, the ITSM stand-in | 60 · 10.10.60.21 | 121 · prox-main | 2 / 2 GB / 20 GB | Ubuntu 24.04 cloud image | built 2026-11-03, app live 2026-11-07 | HR-feed step 0 |

VMIDs: `3xx` are bank guests, `1xx` are lab services. The vendor VMs sit on VLAN 60 on purpose: outside the bank, one firewall hole in (SFTP to HM-OPS01), nothing else. Later, not on-prem estate: the GPU model VM on prox-main (Track 2 A0, after the exam) and the Phase 3 pipeline runner (GitHub-hosted at first).

DHCP is served by OPNsense, not the DCs. `scripts/` holds the per-VM build scripts; `seed/` holds the database schema and seed data.
