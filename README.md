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

See [COPYTRUST_USER_GUIDE.md](COPYTRUST_USER_GUIDE.md) for the full workflow and settings reference.

## Drop Verify

Single-folder drag-and-drop verification. Drop a folder and generate trust artifacts — no copy, no session, no setup.

- Media-only recursive scan with configurable exclusion patterns
- Generates **MHL**, **contact sheet PDF** (row or grid), and **EXIF metadata CSV**
- Writes artifacts into the folder and/or mirrors them to an export folder

See [DROP_VERIFY_README.md](DROP_VERIFY_README.md) and [DROP_VERIFY_USER_GUIDE.md](DROP_VERIFY_USER_GUIDE.md).

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

See [FOLDER_COPY_COMPARE_README.md](FOLDER_COPY_COMPARE_README.md) and [FOLDER_COPY_COMPARE_USER_GUIDE.md](FOLDER_COPY_COMPARE_USER_GUIDE.md).

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
- Since `v2.1.8`, CopyTrust has evolved from a simpler multi-destination copy tool into a more complete ingest workflow with structured manifests, clearer end-of-run review, stronger cancel handling, and better post-run auditability.
- `v2.1.8` focused on stability and trust records: per-run manifests, improved receipts, better cancel visibility, stronger contact-sheet behavior, and safer handling of unsupported media through placeholders instead of silent drops.
- `v2.1.9` was the major workflow jump: trust-critical `copy + verify + MHL` now finish before PDF / CSV artifacts, cancelled ingests can resume from partial destination contents, queued sessions became real persisted queue objects, naming and file-prefix tools became much stronger, and logging became more useful for real-world troubleshooting.
- `v2.2 (Build 2)` adds the current relay-copy workflow: one source plus ordered destinations, `Queue Relay Chain`, destination-order editing, clearer startup guidance, end-session summaries that reflect the full relay run, mixed-queue reorder fixes, better artifact retry / rebuild across queued runs, simpler post-run review, and a quick `Reveal` action on completed-source rows.
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

### Version History (since v2.1.6)

**v2.2 Build 2**  — CopyTrust now presents relay copy as a progressive-disclosure workflow: load one source and two or more destinations, then use `Queue Relay Chain` to stage an ordered `A -> B -> C` path. Destination order is visible and editable, startup help now focuses on getting the first copy right before explaining heavier tools, and end-session receipts now summarize the full relay run instead of only the last leg. This branch also keeps the current external-codec path for MXF, MPEG-2 family, WMV, and R3D media.

**v2.1.9 Build 7**  — CopyTrust now supports real-world cancel/resume for the same source and destination set by reconciling already copied destination files, not just previously verified manifest entries. Build 7 also cleans up cancelled-session UX with `Resume` / `Close` actions, adds `Stop PDF/CSV` and `End Without PDF/CSV` controls for secondary artifacts, and lets EXIF CSV run independently from contact-sheet generation so a stuck PDF job no longer blocks CSV completion.

**v2.1.9 Build 5**  — the active test branch now includes MXF + R3D real thumbnails, ffmpeg routing for `m2v`, `m2t`, `m2ts`, and `vob`, ExifTool fallback for sparse video metadata such as `wmv`, clearer no-preview reasons, full filenames in contact-sheet placeholders, better Drop Verify progress/log visibility, and MHL generation fixes so new manifests preserve source folder/path metadata and ignore pre-existing `.mhl` receipts as media entries. Recent Build 5 reliability work also serializes unsupported-media preview generation to reduce small-batch `R3D` stalls.

**v2.1.9 Build 2**  — MXF remains working end-to-end, and R3D now routes through REDline for real contact-sheet thumbnails in the active test branch. ExifTool remains the metadata path for both MXF and R3D, so contact sheets and CSV output can show richer unsupported-format metadata while the stable line stays placeholder-only for previews. Recent Build 2 polish also fixes REDline validation, improves R3D thumbnail sizing, trims crowded contact-sheet metadata, and cleans up CopyTrust receipt text branding/output.

**v2.1.9 Build 1**  — MXF now works end-to-end in the active test branch. ExifTool metadata for MXF is validated in both CopyTrust and Drop Verify, ffmpeg now generates real MXF contact-sheet thumbnails, and the CSV output now includes richer ExifTool-backed fields such as timecode and audio details where available. This branch is intentionally MXF-first and is not yet the stable release line.

**v2.1.8 Build 14** (stable) — ExifTool metadata support is validated for unsupported formats such as MXF in both CopyTrust and Drop Verify, with real app/version/build stamping in MHL, manifests, receipts, and contact-sheet footers. Unsupported formats still show `No Preview` placeholders in the stable release until ffmpeg/REDline/BRAW thumbnail decoding is merged forward.

**v2.1.8 Build 13** (testing) — External tool test build: app sandboxing is disabled on the branch so ExifTool and future ffmpeg integration can be exercised in real app runs. ExifTool path detection/selection now works in-app, unsupported formats such as MXF can use ExifTool metadata for contact-sheet metadata columns and CSV output, and Drop Verify keeps unsupported formats in the artifact pipeline. Unsupported formats still show `No Preview` placeholders until ffmpeg/REDline/BRAW thumbnail decoding lands.

**v2.1.8 Build 12** — Drop Verify logger follow-up: `Reveal Logs` is now exposed in-app, logger failures surface as a non-fatal warning in Run Status, and log-path documentation now matches the sandboxed container location. Includes Build 11's M2V crash fix, branding fix, grid caption improvements, and hide-placeholder option.

**v2.1.8 Build 10** — Contact sheet robustness: professional camera formats (MXF, R3D, BRAW, ARRIRAW, CinemaDNG) now appear on contact sheets with "No Preview" placeholders instead of being silently dropped. Failed thumbnails show placeholder rows with error reasons. Blank pages eliminated. Header shows skipped file count by format. Affects CopyTrust and Drop Verify.

**v2.1.8 Build 9** — Contact sheet header layout fix (long folder names no longer overlap metadata). Folder compare symlink fix.

**v2.1.8 Build 8** — Post-cancel UX: "Reveal Receipts" and "Reveal Manifest" buttons appear in the action bar after a cancelled copy. Inline subfolder prefix field on the main view for quick tagging (e.g. "2.1.8_b6") without opening Settings.

**v2.1.8 Build 6** — Fixed CopyTrust cancellation discarding partial file counts from session manifest. Manifest now also written to local logs folder. Drop Verify export-only UI: artifact rows show exported files with "Exported" badge, auto-reveal on completion, "Reveal Manifest" button after cancel. JSON keys differentiated: CopyTrust uses `filesCopied`, Drop Verify uses `filesVerified`.

**v2.1.8 Build 5** — Session manifest persistence: structured JSON manifest written after every CopyTrust ingest and Drop Verify run, recording all verified, skipped, and failed files with reasons. Partial manifests saved on cancellation. New `SkippedFileEntry` / `FailedFileEntry` types in CopyCore with structured error capture in the copy loop.

**v2.1.8 Build 4** — Drop Verify: read-only media detection with automatic export fallback. Cancel button and determinate progress bar during scanning/hashing.

**v2.1.8 Build 3** — Volume Pool stays visible during copy sessions (collapsible disclosure triangle instead of hidden). Sources panel also collapsible. "End Session…" button renamed to "Review Summary…" for clarity.

**v2.1.8 Build 1** — UI and receipt improvements.
- Smart video thumbnail frame selection — samples at ~17%/50%/83% instead of 0%/33%/66% to avoid black lead-in frames. Grid contact sheets sample at 50% (mid-point). Applies to both CopyTrust and Drop Verify.
- Phase timing in receipts — copy, verification, and artifact durations per destination with throughput (e.g. `Copy: 04:32 @ 620 MB/s`). JSON and plaintext.
- Collapsible panels — verification, completed sources, and log panels collapse with disclosure triangles. State persists across sessions.

**v2.1.7** — Critical memory reduction across 5 builds. A 168 GB camera card that previously crashed the Mac at 118 GB RAM now copies at under 400 MB. Validated with a 4-hour, 390+ GB stress test.
- Build 5: Root cause fix — `autoreleasepool` in `FileHandle.read` copy loop and `XXHasher` hash loop. O(N^2) to O(1) file size lookup in verification.
- Build 4: `F_NOCACHE` on all copy I/O (bypasses page cache), 4 MB copy buffer, per-file fsync removed, concurrent 2-file verification hashing, 1 MB hash buffer.
- Build 3: Streaming batch enumeration in `FolderScanner` (eliminated O(N) URL array), hash cache release after verification, amortized log trimming, App Nap prevention during ingest.
- Build 2: Page-at-a-time contact sheet rendering (constant memory vs O(N) thumbnails), file-backed PDF context (eliminated in-memory buffer), progress callback throttling (100K to ~1K MainActor tasks).
- Build 1: `autoreleasepool` in all file enumeration loops, MHL XML streaming (eliminated O(N^2) string concat), log line cap, tracked/cancellable preflight tasks.

**v2.1.6** — Xsan (Fibre Channel SAN) volume detection in volume browser. Fixed network volume free space underreporting on SMB/NFS by cross-checking `statfs`, `statvfs`, and FileManager resource keys.
