# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

CopyTrust: **v2.3 (Build 7)** 
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
- **Build 5**: contact sheet PDFs now auto-open through AppKit's asynchronous workspace API so Preview launch does not stall session completion
- **Build 5**: failed partial runs can expose `Resume` when the saved manifest still matches the same source, destination set, and rendered subfolder
- **Build 5**: verify-start diagnostics and verify-abort logs now capture clearer file-count, stage, and failing-path context
- **Build 3**: fixed Sentry-detected 2000 ms app hangs during contact sheet generation on large cards; all session-state persistence and receipt writes now happen off the main thread
- **Build 3**: thumbnail cache — contact sheets for relay chains and multi-destination sessions are faster; thumbnails generated for the first destination are cached and reused for each subsequent destination

### Drop Verify
- Since `v2.1.8`, Drop Verify has become much more reliable about partial results, logging, export behavior, and unsupported-format handling.
- `v2.1.8` brought stronger cancel/export behavior, clearer logs, and better contact-sheet handling for professional and unsupported formats.
- `v2.1.9` improved shared trust plumbing: cleaner MHL metadata, better source-path recording, stronger preview/log visibility, and richer external-codec coverage shared with CopyTrust for formats such as `MXF` and `R3D`.
- Practical summary: Drop Verify is now a stronger one-folder trust-artifact generator with better manifests, better logs, and better behavior on difficult media.

### MHL Verify (2.3 build 7)
- Scrolling through an MHL's content in the Reader tab did not work. The scroll bar was visible but unresponsive.
- MHL files created by production tools that generate their own file-type metadata are now recognised by MHL Verify.
- The Quick Look extension now also previews `.mhl` files stamped with alternate type identifiers, consistent with the main app changes above.
- The biggest gains since `v2.1.8` and `v2.1.9` are shared MHL correctness and interoperability rather than large UI changes.
- MHLs written by the suite now preserve source path and source identity more accurately and no longer treat pre-existing `.mhl` receipts as media entries.
- Practical summary: MHL verification across suite-generated manifests should now be more trustworthy and easier to compare with other MHL-capable tools.

### Folder Copy Compare (2.3 build 7)
- **Folder selections preserved on mode switch**: switching from Compare to Subfolder Check (or back) no longer clears the drop zones. Folders already loaded are carried over automatically.
- **Quick Scan respected in Subfolder Check drill-down**: clicking a subfolder pair now uses the active scan mode. Quick Scan produces a near-instant size-and-date comparison; Full Scan still hashes every file for content-level accuracy.
- **"Date Only" result status**: files with the same name and size but a different modification date are now classified as **Date Only** (yellow) rather than **Different content** (red). This is a normal filesystem-copy artefact and almost always harmless.
- **Per-file Hash Check**: after a Quick Scan, click the checkmark (✓) in the Actions column on any Date Only row to hash just that file pair and confirm whether the content is actually identical — no full rescan needed.
- **Clearer scan progress labels**: the progress label now reads "Hashing X% — N of ~M files" during a Full Scan and "Scanning X% — N of ~M files" during a Quick Scan. The final message reads "Hash complete" or "Scan complete" accordingly.
- **Reliable cancel behaviour**: cancelling a scan no longer shows an error or clears the folder from the drop zone. The folder stays visible with a "Scan cancelled" label and Reset is immediately available.
- Since `v2.1.8`, Folder Copy Compare has picked up shared trust fixes plus a newer usability pass in `v2.2`.
- `v2.2 (Build 1)` is the major recent step here: true `Quick Scan` default behavior, better scan-mode consistency, separate source / target rescans, safer replace-copy behavior, reveal actions for selected files, and more reliable `Copy All Missing` flow.
- `v2.2 (Build 14)` adds **Subfolder Check mode** — a new segment-control mode alongside the existing Compare mode. Drop two folders and get an instant side-by-side table of immediate subfolders: file count, total size, and Archiware P5 stub file counts (`.p5a` / `.p5c`). Each row is colour-coded as exact / close / different / one-side-only. Click any matched pair to drill down into a full hash comparison of just that subfolder — Phase 1 file enumeration is reused, so only hashing is needed. Results are cached per-session; navigating back and drilling in again is instant.
- Practical summary: Folder Copy Compare is now a cleaner and faster sanity-check and repair tool for confirming whether a copy worked and fixing obvious gaps — and Subfolder Check gives you a structural overview first so you know where to look before running a full scan.

### mhl-tool (CLI)
- The main changes since `v2.1.8` and `v2.1.9` are shared `CopyCore` MHL improvements rather than a large CLI workflow redesign.
- The CLI now benefits from the same cleaner source metadata handling and `.mhl` entry filtering used by the apps.
- Practical summary: `mhl-tool` now produces cleaner, more interoperable manifests that better match the current app-side trust workflow.

## CopyTrust

Multi-source, multi-destination copy tool designed for camera card ingest but capable of copying any folders and files. Queue multiple cards, walk away, come back to verified results.

- Volume browser and **Volume Pool** for fast source/destination setup
- Destination preset groups for one-click restore of saved destination sets
- Per-destination preflight checks (free space, write permissions, reachability)
- Post-copy verification with xxHash64 (None / Quick / Full)
- **MHL v1.1** hash list generation — compatible with OffShoot, Silverstack, ShotPut Pro, YoYotta
- MHL import verification — drag-and-drop any `.mhl` to re-verify destination files
- **Auto-advance** multi-source copy with per-card subfolder naming
- **Queued sessions** for walk-away ingest staging across different card/destination setups
- **Relay-chain copy** for `A -> B -> C` workflows using one source plus ordered destinations and `Queue Relay Chain`
- Destination relay-order staging with visible `Stop 1`, `Stop 2`; queued relay legs can be pulled back into the workspace with `Edit` for reordering
- **Resumable CopyTrust ingest** for cancelled same-source/same-destination runs and failed partial runs when the saved manifest still matches the same source, destinations, and rendered subfolder
- **Contact sheet PDF** (row or grid layout) and **EXIF metadata CSV** after each ingest — professional formats (MXF, R3D, BRAW, ARRIRAW, M2V, VOB) show placeholders in the stable release, while this branch uses ExifTool for richer metadata, ffmpeg for MXF and MPEG-2 family thumbnails, and REDline for R3D thumbnails. PDF/CSV run as independent background artifacts after trust-critical copy + verify + MHL completion.
- Session receipts (JSON + TXT), per-ingest logs, and optional export to a separate folder, including overall relay-chain summaries at session close
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export
- Safe-to-eject flow after successful transfer
- Built-in Help flow with `Quick Start`, `Advanced Start`, and a Help menu entry to reopen CopyTrust guidance
- Asynchronous contact-sheet auto-open and richer verify-start / verify-abort diagnostics for easier troubleshooting


## Drop Verify

Single-folder drag-and-drop verification. Drop a folder and generate trust artifacts — no copy, no session, no setup.

- Media-only recursive scan with configurable exclusion patterns
- Generates **MHL**, **contact sheet PDF** (row or grid), and **EXIF metadata CSV**
- Writes artifacts into the folder and/or mirrors them to an export folder

## MHL Verify

Standalone MHL verification. Load any `.mhl` file and verify whether the media files still match.

- Re-check copies, archive restores, and handoff deliveries
- Works with MHLs from Drop Verify, CopyTrust, OffShoot, Silverstack, or any MHL-capable tool

## Folder Copy Compare

The original tool that started the suite — a simple "did the copy work?" sanity check. Drop two folders and get an honest answer.

Use after copying with CopyTrust, Archiware P5 Sync, a Finder copy, `rsync`, Hedge, ShotPut Pro, or any other tool.

- **Compare mode** — Quick Scan (name, size, date) or Full Scan (xxHash64 / SHA-256 content hashing); per-file comparison: missing, extra, different, identical; **Copy All Missing** to sync differences, then **Refresh** to re-verify; MHL v1.1 generation and verification from either compared folder
- **Subfolder Check mode** — fast structural sanity check: aligns immediate subfolders side-by-side with file counts, total sizes, and Archiware P5 stub file detection (`.p5a` / `.p5c`); colour-coded match indicators (exact / close / different / one-side-only); click any matched row to drill down using the active Quick / Full Scan setting
- **Date Only** quick-scan status plus per-file **Hash Check** for same-size, different-date pairs without forcing a full rescan
- Folder selections persist across Compare / Subfolder Check mode switches; scan cancel is non-destructive; stub cleanup now shows progress and hides `Clean` on the `_P5 Stub Cleanup` folder
- Standalone app — no ingest session, no receipts, no artifacts

## mhl-tool (CLI)

Command-line tool for creating and verifying MHL v1.1 manifests. Same MHL engine as CopyTrust and Drop Verify, built for the terminal.

- `mhl-tool create <folder>` — hash files and write an MHL manifest
- `mhl-tool verify <folder>` — verify files against MHL(s), auto-discovers `_Receipts`
- Media-only (default) or `--all-files` mode
- JSON output for scripting, quiet mode for CI
- Reads MHLs from any tool (OffShoot, Silverstack, ShotPut Pro, YoYotta)
- Signed, notarized `.pkg` installer for distribution

## Keyboard Shortcuts

### Folder Copy Compare
- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
