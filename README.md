# Media Trust Tools

Four macOS apps for media integrity — copy, verify, and prove it.

Current release: **v2.1.5 (build 1)**.

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
