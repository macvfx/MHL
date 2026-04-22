# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

Current version: **v2.2 (Build 8)** 

Current CopyTrust focus on this branch:
- relay-chain copy workflow with ordered destinations and `Queue Relay Chain`
- destination reordering for `A -> B -> C` style copies
- startup guidance that stays out of the way until needed
- real-world resumable CopyTrust ingests
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


## What Changed Since v2.1.7 / v2.1.8 / v2.1.9

### CopyTrust
- Since `v2.1.8`, CopyTrust has evolved from a simpler multi-destination copy tool into a more complete ingest workflow with structured manifests, clearer end-of-run review, stronger cancel handling, and better post-run auditability.
- `v2.1.8` focused on stability and trust records: per-run manifests, improved receipts, better cancel visibility, stronger contact-sheet behavior, and safer handling of unsupported media through placeholders instead of silent drops.
- `v2.1.9` was the major workflow jump: trust-critical `copy + verify + MHL` now finish before PDF / CSV artifacts, cancelled ingests can resume from partial destination contents, queued sessions became real persisted queue objects, naming and file-prefix tools became much stronger, and logging became more useful for real-world troubleshooting.
- `v2.2 (Build 2)` adds the current relay-copy workflow: one source plus ordered destinations, `Queue Relay Chain`, destination-order editing, clearer startup guidance, end-session summaries that reflect the full relay run, mixed-queue reorder fixes, better artifact retry / rebuild across queued runs, simpler post-run review, and a quick `Reveal` action on completed-source rows.
- `v2.2 Builds 5–8` complete the current sprint: Build 5 adds `COPY SPEED SUMMARY` blocks to session receipts with per-leg copy/verify speed side by side. Build 6 adds persistent per-volume device speed history with trend analysis. Build 7 fixes artifact writes on exFAT destinations (the F_FULLFSYNC fallback), fixes `dest=""` in log lines, and adds structured provenance headers to all logs. Build 8 adds hostname to all artifact formats so every output carries a consistent provenance block.
- Practical summary: CopyTrust now supports three clearer patterns in one app: direct multi-destination copy, mixed queued sessions, and relay-chain `A -> B -> C` ingest.

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
