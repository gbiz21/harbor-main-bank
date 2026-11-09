# ADR-0003: VMs are built through a scoped automation identity, never as root

Date: 2026-11-08
Phase: T1-P0 and onward
Status: accepted

## Context
Phase 0 hosts were being built by hand in the Proxmox UI as root. The plan calls for builds as code, and for an audit trail that names who built what.

## Decision
A dedicated Proxmox user `automation@pve` with an API token is the only identity that creates, clones, configures, starts or stops VMs from code. Its permissions are exactly: VM administration on `/vms`, disk allocation on the two storages it needs, and use of the one bridge. It holds no rights on nodes, users, permissions or the cluster, so it cannot widen its own scope. Privilege Separation is off and the rows live on the user, because one token with one job gains nothing from separation. The secret lives in the password manager and the operator's OS keychain, never in a file or a repo.

## Consequences
Every build appears in the Proxmox task log under `automation@pve`. Image downloads by URL are refused (they need system-level rights); images are verified locally against the publisher's checksum and uploaded instead. Granting or changing the identity's scope is a human action in the UI, recorded in the inventory. Revocation is one click.
