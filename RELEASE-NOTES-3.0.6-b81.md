# 3.0.6 Build 81 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-11-13 · One release carries three apps, all at 3.0.6 build 81, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. It includes everything in 3.0.5 build 79. Build 80 was
built for CopyTrust alone and never published; what it contained ships here.

**Drop Verify**

## The whole run's evidence, in one export folder

- **Where a run exports is fixed when the run starts.** With the extra export folder on, turning it off or choosing a
  different folder while a run is in progress used to drop or redirect that run's export without saying so. A change now
  applies to the next run.
- **The session log is exported** with the artifacts and the manifest, as `session_<ID>.log`. The export folder,
  `Receipts/<folder>_<timestamp>/`, is created with the log in it before hashing starts.
- **A cancelled or failed run still leaves evidence there**: the session log always, and the partial manifest when a
  hashing run was cancelled. Before, such a run exported nothing.
- **On read-only media the session manifest sits with the other artifacts** in the run's own folder, not loose in
  `Receipts/`.
- The timestamp in the export folder's name is now the moment the run started. Retry and Rebuild export into the folder
  the run used.

**CopyTrust**

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

**Folder Copy Compare** has no change of its own.

## Recommended acceptance check

In Drop Verify, turn on the extra export folder and drop a folder. While it is hashing, confirm the export folder already
holds the run's folder and session log; turn the export off before the run ends and confirm the artifacts, manifest and
finished log still arrive. Cancel a second run mid-hash and confirm its log and partial manifest are exported.

In CopyTrust, use disposable media and two test destinations. Start one source, add another source to the active run, and inspect
the external evidence folder before ending the session. Confirm the initial plan is unchanged, the added-source event
and pending map exist, then finish and verify the final map. For P5, confirm a deferred request produces no completion
file and that only an observed successful disposable archive job creates one.

This remains beta software. Keep a separately verified backup and validate the workflow with expendable media before
using it on production material.
