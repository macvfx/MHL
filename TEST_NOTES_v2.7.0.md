# CopyTrust 2.7.0 (Build 1) — P5 Archive Beta Testing Notes

Date: 2026-07-29  
Status: Public prerelease  
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
| P5 offline | Verified copy stays successful; request records retry details |
| Restore | P5 restores expected files; MHL verification matches every hash |

The private source repository contains the optional deferred-submission helper.
The request file must remain password-free.
