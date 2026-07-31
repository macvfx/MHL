# CopyTrust 2.7.0 (Build 8) — P5 Archive, Queue, and Sentry Integration Testing Notes

Date: 2026-07-31
Status: Public prerelease for controlled testing
App: CopyTrust

Use expendable fixtures and a non-deleting P5 plan. Confirm both CopyTrust's
request and P5 Web; archive submission alone is not acceptance proof.

| Test | Expected result |
|---|---|
| Test Connection & Load | Live indexes, clients, and plans populate |
| Password storage | Password is in Keychain, never request JSON/preferences |
| Source-deleting plan | Visibly blocked from automatic submission |
| Full/Inline copy | Complete verified hashes; archive request can submit |
| Quick/copy-only | Deferred `needs_hash_verification`; no auto-submit |
| P5 path mismatch | Actionable deferred/error state, not false success |
| Metadata keys | `CT_*` fields are visible and searchable in P5 Web |
| Missing required metadata keys | Submission is blocked; explicit install action provisions the selected index |
| Destination selection | Only the destination with **Archive to P5** checked is submitted |
| Pre-copy summary | P5 On/Off plus selected index, client, and plan are visible before copying |
| Mixed queue | Each job retains its artifact/P5 settings and the queue advances while P5 work completes |
| Artifact status | Each artifact independently reaches completed, skipped, or failed; unrelated rows do not keep spinning |
| P5 polling | Routine polls stay quiet; periodic progress and terminal success/failure remain visible |
| Successful P5 completion | No session-teardown crash; destination/archive status remains inspectable |
| P5 offline | Verified copy stays successful; request records retry details |
| Restore | P5 restores expected files; MHL verification matches every hash |
| Sentry integration test | Event ID arrives in `apple-macos`; exception value is `Redacted by CopyTrust privacy filter` |

The private source repository contains the optional deferred-submission helper.
The request file must remain password-free.

The live Sentry test confirms delivery and on-device filtering. It does not by
itself confirm release-crash persistence or dSYM symbolication.
