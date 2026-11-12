# CopyTrust 3.0.6 Build 80 — beta

2026-11-12 · This release updates CopyTrust. The companion apps retain their existing behaviour, while the shared
suite version/build is 3.0.6 build 80. It includes everything in 3.0.5 build 79.

## Investigation-ready session evidence

- When the external evidence mirror is enabled, CopyTrust creates
  `Receipts/YEAR-MM-DD/Session_<ID>/` before copying. An immutable session plan and initial CSV/JSON copy map show
  the configured sources, destinations, destination roles, P5 choices and pending source-to-destination pairs.
- Logs, receipts, manifests, provenance, MHLs, copy maps, P5 evidence and generated reports are mirrored as the run
  progresses. **End Session** adds the final map and aggregate summary; it is no longer the first external write.
- Source cards added after copying begins are amendments to the same session. Each immediately appends an ordered
  `sourceAdded` event and a pending `CopyMap_SourceAdded_*` snapshot without rewriting the original setup.
- The export destination is frozen when the session begins, so changing a preset or the live export toggle cannot
  silently redirect evidence for an active run.

## P5 and privacy evidence

- A `COPYTRUST_P5_ARCHIVE_REQUEST_*` file proves that an archive was prepared or submitted; it no longer implies
  completion. Only a successful terminal P5 result observed by CopyTrust creates a separate
  `COPYTRUST_P5_ARCHIVE_COMPLETION_*.json/.txt` record.
- **Export Logs…** makes an exact session-log copy. **Export Sanitized Logs…** creates a separate copy that retains
  timestamps, sequence and states while removing paths and common identity-bearing values. Originals are unchanged;
  review sanitized material before sharing it.

## Recommended acceptance check

Use disposable media and two test destinations. Start one source, add another source to the active run, and inspect
the external evidence folder before ending the session. Confirm the initial plan is unchanged, the added-source event
and pending map exist, then finish and verify the final map. For P5, confirm a deferred request produces no completion
file and that only an observed successful disposable archive job creates one.

This remains beta software. Keep a separately verified backup and validate the workflow with expendable media before
using it on production material.
