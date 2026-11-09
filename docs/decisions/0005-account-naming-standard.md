# ADR-0005: One person token, `flast`, for every account kind

Date: 2026-11-07
Phase: identity, all tracks
Status: accepted

## Context
Seeded accounts in the lab used role names (`iam.engineer`), which cannot be tied to one person in an audit. AD's older account name is limited to 20 characters, and the HR-feed processor must derive names deterministically.

## Decision
Standard accounts are `flast` (first initial plus last name, lowercase, ASCII). Collisions append the lowest free digit. Admin accounts are `adm.` plus the same token, live in their own OU, have no mailbox or licence, and sit outside the processor's delegated scope. Service accounts are `svc-` plus the function. Cloud-only administrators keep the tenant's existing pattern. The processor derives the token from the feed's legal name, truncates to fit 20 characters, and refuses to touch anything outside the staff OU or anything starting `adm.` or `svc-`. The ticketing system's seeded users follow the same tokens so a ticket's technician matches the directory login.

## Consequences
Every login in AD, Entra, the ITSM and the run logs refers to the same person the same way. The employee identifier from HR, never the username, is the key the processor matches on, so renames and collisions never break the link to the person.
