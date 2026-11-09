# ADR-0004: The HR feed is pulled from the vendor's transfer area, not pushed into the bank

Date: 2026-11-08
Phase: HR-feed lab, step 1
Status: accepted

## Context
The first design had the payroll vendor push its nightly report by SFTP into a landing host inside the bank, which required an inbound firewall hole and a vendor-held key to a bank system. Real ADP contracts place the scheduled report in ADP's own secure file transfer area and the customer pulls it.

## Decision
The bank's transfer host (HM-OPS01) runs a scheduled, idempotent pull: it connects out to the vendor's read-only SFTP queue with a bank-owned key and a pinned host key, downloads only files it has not landed before, writes each as `.part` and renames on completion, and logs one JSON line per action with a run id. The vendor never initiates a connection to the bank. The processor host reads the landed files through a separate read-only account.

## Consequences
No inbound rule exists for the vendor. One outbound allow, transfer host to vendor on TCP 22, is the entire network exposure. The credential at risk is the bank's key to the vendor, which the bank can rotate unilaterally. In the lab the vendor queue is a read-only bind mount of the mock HRIS's outbox behind an SFTP-only chroot; the same shape is what a managed file transfer tool provides at work. The design draft, the runbook's HR-feed step and the firewall rules are updated to match.
