# ADR-0002: Phase 0 reuses the BKRE estate on VLAN 30; no new VLAN 40

Date: 2026-10-31
Phase: T1-P0
Status: accepted

## Context
The runbook's Phase 0 builds a new estate (HM-DC01 to HM-PAW01) in a new forest `corp.harbormain.local` on a new VLAN 40, `10.40.0.0/24`. The lab already has a domain-joined estate on VLAN 30 (`10.10.30.0/24`): BKR-DC01, BKR-DC02, BKR-FS01, BKR-APP01, BKR-SQL01 and BKR-CL01 in forest `corp.bkre8tive.com`, with departmental groups, shares, GPO and validated DC replication. VLAN 40 is already the Guest Wi-Fi network (`10.10.40.0/24`). The AZ-104 exam is the week of 2027-01-12 and a new job starts 2026-11-27, so the two weekends a rebuild would cost are the two least available. A `.local` forest name is also an anti-pattern: it collides with mDNS and can never carry a public certificate.

## Decision
Harbor & Main's on-prem estate is the existing BKRE build. VLAN 30 is the bank VLAN. The forest stays `corp.bkre8tive.com`. Runbook host names are read as the hosts below.

| Runbook name | Actual host | Address | State on 2026-10-31 |
| --- | --- | --- | --- |
| HM-DC01 | BKR-DC01 | 10.10.30.10 | built: AD DS, DNS, GC, all FSMO roles |
| (second DC) | BKR-DC02 | 10.10.30.11 | built: GC; runs on prox-alien |
| HM-FS01 | BKR-FS01 | 10.10.30.20 | built: departmental shares |
| HM-WEB01 | BKR-APP01 | 10.10.30.30 | IIS installed, no app deployed yet |
| HM-SQL01 | BKR-SQL01 | 10.10.30.31 | domain-joined, no SQL engine yet |
| (staff workstation) | BKR-CL01 | 10.10.30.40 | built, domain-joined |
| HM-OPS01 | HM-OPS01 | 10.10.30.50 | to build: Phase 0 session 2 |
| HM-PAW01 | HM-PAW01 | 10.10.30.51 | to build, optional, after HM-OPS01 |

DHCP stays on OPNsense (Kea); the domain controllers run AD DS and DNS only. The runbook's "network first" step becomes P0, segmentation truth: an allow test and a deny test against the VLAN 30 rules, with the result recorded.

## Consequences
Phase 0 is finishing work, not a rebuild: segmentation proof, SQL engine on SQL01, the web app on APP01, backups, OUs, GPO and service accounts, HM-OPS01. Proxmox display names may be relabelled; Windows host names are not renamed. Any runbook reference to `corp.harbormain.local` or `10.40.0.x` reads as `corp.bkre8tive.com` and `10.10.30.x`. The homelab inventory stays the address source of truth; HM-OPS01 is added to it when built.
