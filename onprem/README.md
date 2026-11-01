# On-prem estate (Phase 0)

The estate is the BKRE build already running on VLAN 30 (`10.10.30.0/24`, forest `corp.bkre8tive.com`). See `docs/decisions/0002-reuse-bkre-estate-vlan30.md` for why. Runbook names on the left, real hosts on the right.

| Runbook name | Host | Role | IP | State |
| --- | --- | --- | --- | --- |
| HM-DC01 | BKR-DC01 | AD DS, DNS, GC, all FSMO | 10.10.30.10 | built |
| (second DC) | BKR-DC02 | AD DS, DNS, GC | 10.10.30.11 | built, on prox-alien |
| HM-FS01 | BKR-FS01 | File shares, backups | 10.10.30.20 | shares built; backups to do |
| HM-WEB01 | BKR-APP01 | IIS online banking app | 10.10.30.30 | IIS only; app to deploy |
| HM-SQL01 | BKR-SQL01 | SQL Server, HarborMainCore | 10.10.30.31 | engine to install |
| (workstation) | BKR-CL01 | Domain-joined staff client | 10.10.30.40 | built |
| HM-OPS01 | HM-OPS01 | Linux admin box | 10.10.30.50 | to build |
| HM-PAW01 | HM-PAW01 | Windows admin box | 10.10.30.51 | optional, later |

DHCP is served by OPNsense, not the DCs. `scripts/` holds the per-VM build scripts; `seed/` holds the database schema and seed data.
