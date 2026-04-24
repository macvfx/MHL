# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

Current version: **v2.2 (Build 14)** 

Current CopyTrust focus on this branch:
- relay-chain copy workflow with ordered destinations and `Queue Relay Chain`
- inline relay-chain callout with speed-ordering tip; right-click context menu on destination rows
- real drive names in relay queue rows; volume name auto-populated for new destinations
- read-only volumes blocked from destination role in volume browser and pool
- inline expand panel on queued rows for alias editing and path reveal without loading
- edit relay chain via `Edit` button — removes all legs and restores workspace for reordering
- done button in progress sheet after cancel (alongside resume); MHL write failure guidance
- `Review & Verify` promoted to primary after a cancelled session; `End Session` in main window
- `Reset Session` always wipes the full queue; `Return to Queue` button for loaded sessions
- camera card source detection hardening (Canon, RED, Arri, read-only badge)
- copy speed summary in session receipts with per-leg comparison and JSON speed fields
- persistent per-volume device speed history with trend tracking
- reliable artifact writes to exFAT, SMB, and NFS destinations
- session and per-copy log provenance headers (app, macOS, hostname, session ID)
- hostname in all artifact formats: session manifest JSON, receipt JSON, and plaintext receipt


## External Codec Test Setup

For the active `v2.2 (Build 8)` branch:

- Enable `ExifTool metadata extraction` if you want richer metadata for unsupported/professional formats.
- Enable `External thumbnail codecs` only if you want real preview thumbnails for formats the built-in AVFoundation path cannot decode.
- Typical tested setup:
  - `ExifTool` for MXF, R3D, MPEG-2 family, and sparse-video metadata
  - `ffmpeg` for MXF, `m2v`, `m2t`, `m2ts`, and `vob` contact-sheet thumbnails
  - `REDline` for R3D contact-sheet thumbnails
- Typical operator flow in Settings:
  - open `Settings > External Codecs`
  - enable `ExifTool metadata extraction`
  - use `Auto-Detect` or `Browse…` to select `exiftool`
  - enable `External thumbnail codecs`
  - use `Auto-Detect` or `Browse…` to select `ffmpeg` and/or `REDline`
  - leave other tools off unless you are explicitly testing them

Current tested expectations on this branch:
- MXF: ExifTool metadata + ffmpeg thumbnails
- MPEG-2 family (`m2v`, `m2t`, `m2ts`, `vob`): ExifTool metadata + ffmpeg thumbnails
- R3D: ExifTool metadata + REDline thumbnails
- WMV and other sparse/no-preview formats: better metadata and clearer no-preview reasons even when no thumbnail is created
- Stable `v2.1.8 Build 14`: ExifTool metadata only, unsupported-format placeholders still expected

### Version History 

### CopyTrust
**v2.2 Build 14** (active feature-test branch: `codex/v2.2`) — Edit Relay Chain: each relay chain queue row now shows an `Edit` button instead of up/down arrows. Clicking `Edit` on any leg removes all legs from the queue and restores the source and destinations to the workspace in their original order for reordering. Reorder destinations with the up/down arrows and click `Queue Relay Chain` again. `Edit` is disabled once any leg has started.

**v2.2 Build 13** — `Reset Session` now unconditionally clears all queued sessions with no exceptions for loaded sessions. A new `Return to Queue` button appears when a queued session is loaded but copy has not started — it puts the session back in the queue and clears the workspace without touching other queued items.

**v2.2 Build 11** — `Review & Verify` is now the primary blue button after a cancelled session; `Start This Session` is demoted to grey. `End Session` now appears directly in the main action bar after any run (completed or cancelled) so operators can close without being forced to open the summary sheet first.

**v2.2 Build 10** — `Done` button added to the progress sheet after cancel, alongside `Resume`. When MHL writing fails but file data was copied and hash-verified, the destination row now shows a green "Hash Verified" header and an orange warning ("Files are safe. Use Drop Verify to create a new MHL.") rather than a red Failed state.

**v2.2 Build 9** — Inline relay-chain callout appears above destination rows when one source and two or more destinations are loaded. Right-click context menu on destination rows (`Queue Relay Chain`, `Reveal in Finder`, `Remove Destination`). Relay queue rows show actual card and volume names and `Step N of M` labels. Destination alias auto-populated from macOS volume name. Read-only volumes blocked from destination role in volume browser and pool. Inline expand panel on queued rows for alias editing and path reveal. `Load → review` bug fixed to prevent accidental queue duplication.

**v2.2 Build 8** (branch: `codex/v2.2`) — Hostname is now present in all three artifact formats: `"hostname"` added as a top-level field in both `SESSION_MANIFEST_*.json` and `ingest_*.json`, and a `Host    :` line added to the plaintext `ingest_*.txt` receipt. All three formats (session log, manifest JSON, receipt JSON + plaintext) now carry a consistent provenance block: app name, version, build, macOS version, hostname, and session ID. Drop Verify manifests receive hostname through the same code path.

### Drop Verify
- Since `v2.1.8`, Drop Verify has become much more reliable about partial results, logging, export behavior, and unsupported-format handling.
- `v2.1.8` brought stronger cancel/export behavior, clearer logs, and better contact-sheet handling for professional and unsupported formats.
- `v2.1.9` improved shared trust plumbing: cleaner MHL metadata, better source-path recording, stronger preview/log visibility, and richer external-codec coverage shared with CopyTrust for formats such as `MXF` and `R3D`.
- Practical summary: Drop Verify is now a stronger one-folder trust-artifact generator with better manifests, better logs, and better behavior on difficult media.

### MHL Verify
- The biggest gains since `v2.1.8` and `v2.1.9` are shared MHL correctness and interoperability rather than large UI changes.
- MHLs written by the suite now preserve source path and source identity more accurately and no longer treat pre-existing `.mhl` receipts as media entries.
- Practical summary: MHL verification across suite-generated manifests should now be more trustworthy and easier to compare with other MHL-capable tools.

### Folder Copy Compare
- Since `v2.1.8`, Folder Copy Compare has picked up shared trust fixes plus a newer usability pass in `v2.2`.
- `v2.2 (Build 1)` is the major recent step here: true `Quick Scan` default behavior, better scan-mode consistency, separate source / target rescans, safer replace-copy behavior, reveal actions for selected files, and more reliable `Copy All Missing` flow.
- Practical summary: Folder Copy Compare is now a cleaner and faster sanity-check and repair tool for confirming whether a copy worked and fixing obvious gaps.

### mhl-tool (CLI)
- The main changes since `v2.1.8` and `v2.1.9` are shared `CopyCore` MHL improvements rather than a large CLI workflow redesign.
- The CLI now benefits from the same cleaner source metadata handling and `.mhl` entry filtering used by the apps.
- Practical summary: `mhl-tool` now produces cleaner, more interoperable manifests that better match the current app-side trust workflow.
