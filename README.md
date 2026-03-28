# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

Current stable: **v2.1.7** (Build 5). Testing: **v2.1.8 Build 3**.

### Version History (since v2.1.6)

**v2.1.8 Build 3** (testing) — Volume Pool stays visible during copy sessions (collapsible disclosure triangle instead of hidden). Sources panel also collapsible. "End Session…" button renamed to "Review Summary…" for clarity.

**v2.1.8 Build 1** — UI and receipt improvements.
- Smart video thumbnail frame selection — samples at ~17%/50%/83% instead of 0%/33%/66% to avoid black lead-in frames. Grid contact sheets sample at 50% (mid-point). Applies to both CopyTrust and Drop Verify.
- Phase timing in receipts — copy, verification, and artifact durations per destination with throughput (e.g. `Copy: 04:32 @ 620 MB/s`). JSON and plaintext.
- Collapsible panels — verification, completed sources, and log panels collapse with disclosure triangles. State persists across sessions.

**v2.1.7** (stable) — Critical memory reduction across 5 builds. A 168 GB camera card that previously crashed the Mac at 118 GB RAM now copies at under 400 MB. Validated with a 4-hour, 390+ GB stress test.
- Build 5: Root cause fix — `autoreleasepool` in `FileHandle.read` copy loop and `XXHasher` hash loop. O(N^2) to O(1) file size lookup in verification.
- Build 4: `F_NOCACHE` on all copy I/O (bypasses page cache), 4 MB copy buffer, per-file fsync removed, concurrent 2-file verification hashing, 1 MB hash buffer.
- Build 3: Streaming batch enumeration in `FolderScanner` (eliminated O(N) URL array), hash cache release after verification, amortized log trimming, App Nap prevention during ingest.
- Build 2: Page-at-a-time contact sheet rendering (constant memory vs O(N) thumbnails), file-backed PDF context (eliminated in-memory buffer), progress callback throttling (100K to ~1K MainActor tasks).
- Build 1: `autoreleasepool` in all file enumeration loops, MHL XML streaming (eliminated O(N^2) string concat), log line cap, tracked/cancellable preflight tasks.

**v2.1.6** — Xsan (Fibre Channel SAN) volume detection in volume browser. Fixed network volume free space underreporting on SMB/NFS by cross-checking `statfs`, `statvfs`, and FileManager resource keys.

## CopyTrust

Multi-source, multi-destination copy tool designed for camera card ingest but capable of copying any folders and files. Queue multiple cards, walk away, come back to verified results.

- Volume browser and **Volume Pool** for fast source/destination setup
- Destination preset groups for one-click restore of saved destination sets
- Per-destination preflight checks (free space, write permissions, reachability)
- Post-copy verification with xxHash64 (None / Quick / Full)
- **MHL v1.1** hash list generation — compatible with OffShoot, Silverstack, ShotPut Pro, YoYotta
- MHL import verification — drag-and-drop any `.mhl` to re-verify destination files
- **Auto-advance** multi-source copy with per-card subfolder naming
- **Contact sheet PDF** (row or grid layout) and **EXIF metadata CSV** after each ingest
- Session receipts (JSON + TXT), per-ingest logs, and optional export to a separate folder
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export
- Safe-to-eject flow after successful transfer

See [CopyTrust_UserGuide.md](CopyTrust_UserGuide.md) for the full workflow and settings reference.

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

See [MHLToolPackage/README.md](MHLToolPackage/README.md) for command reference and [MHLToolPackage/docs/USER_GUIDE.md](MHLToolPackage/docs/USER_GUIDE.md) for workflows.

## Keyboard Shortcuts

### Folder Copy Compare
- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
