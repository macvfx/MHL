# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

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
- Destination relay-order editing with visible `Stop 1`, `Stop 2`, and move up/down controls
- **Resumable CopyTrust ingest** for cancelled same-source/same-destination runs, including destination reconciliation so partial copies can continue from the last good point
- **Contact sheet PDF** (row or grid layout) and **EXIF metadata CSV** after each ingest — professional formats (MXF, R3D, BRAW, ARRIRAW, M2V, VOB) show placeholders in the stable release, while this branch uses ExifTool for richer metadata, ffmpeg for MXF and MPEG-2 family thumbnails, and REDline for R3D thumbnails. PDF/CSV run as independent background artifacts after trust-critical copy + verify + MHL completion.
- Session receipts (JSON + TXT), per-ingest logs, and optional export to a separate folder, including overall relay-chain summaries at session close
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export
- Safe-to-eject flow after successful transfer
- Built-in Help flow with `Quick Start`, `Advanced Start`, and a Help menu entry to reopen CopyTrust guidance

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

- Quick Scan (name, size, date) or Full Scan (xxHash64 / SHA-256 content hashing)
- Per-file comparison: missing, extra, different, identical
- **Copy All Missing** to sync differences, then **Refresh** to re-verify
- MHL v1.1 generation and verification from either compared folder
- Standalone app — no ingest session, no receipts, no artifacts

## mhl-tool (CLI)

Command-line tool for creating and verifying MHL v1.1 manifests. Same MHL engine as CopyTrust and Drop Verify, built for the terminal.

- `mhl-tool create <folder>` — hash files and write an MHL manifest
- `mhl-tool verify <folder>` — verify files against MHL(s), auto-discovers `_Receipts`
- Media-only (default) or `--all-files` mode
- JSON output for scripting, quiet mode for CI
- Reads MHLs from any tool (OffShoot, Silverstack, ShotPut Pro, YoYotta)
- Signed, notarized `.pkg` installer for distribution


## What Changed Since v2.1.7 / v2.1.8 / v2.1.9

### CopyTrust
- Practical summary: CopyTrust now supports three clearer patterns in one app: direct multi-destination copy, mixed queued sessions, and relay-chain `A -> B -> C` ingest.
- `v2.2 (Build 2)` adds the current relay-copy workflow: one source plus ordered destinations, `Queue Relay Chain`, destination-order editing, clearer startup guidance, end-session summaries that reflect the full relay run, mixed-queue reorder fixes, better artifact retry / rebuild across queued runs, simpler post-run review, and a quick `Reveal` action on completed-source rows.
- `v2.1.9` was the major workflow jump: trust-critical `copy + verify + MHL` now finish before PDF / CSV artifacts, cancelled ingests can resume from partial destination contents, queued sessions became real persisted queue objects, naming and file-prefix tools became much stronger, and logging became more useful for real-world troubleshooting.
- Since `v2.1.8`, CopyTrust has evolved from a simpler multi-destination copy tool into a more complete ingest workflow with structured manifests, clearer end-of-run review, stronger cancel handling, and better post-run auditability.


### Drop Verify
- Practical summary: Drop Verify is now a stronger one-folder trust-artifact generator with better manifests, better logs, and better behavior on difficult media.
- `v2.1.9` improved shared trust plumbing: cleaner MHL metadata, better source-path recording, stronger preview/log visibility, and richer external-codec coverage shared with CopyTrust for formats such as `MXF` and `R3D`.
- Since `v2.1.8`, Drop Verify has become much more reliable about partial results, logging, export behavior, and unsupported-format handling.

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


