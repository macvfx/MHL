# Folder Copy Compare

The original tool that started it all.

Current version: **v2.7.2 (Build 14 beta)**, aligned with CopyTrust and Drop Verify.
Version history is in [RELEASE_NOTES.md](RELEASE_NOTES.md).

**Folder Copy Compare** began as a simple idea: after copying a folder, prove that the copy worked. Drop a source folder, drop a target folder, and get a clear answer — do they match?

That core concept — *copy, then prove it* — eventually grew into the shared CopyCore engine and spawned CopyTrust (multi-destination camera card ingest) and Drop Verify (single-folder artifact generation). But Folder Copy Compare remains the simplest, most direct tool in the suite: two folders and an honest answer.

## When to Use It

Use Folder Copy Compare **after** you have already copied files with any tool:

- **CopyTrust** camera card ingest
- **Archiware P5 Sync** or P5 Archive restores
- A plain **Finder copy** or `cp -r`
- **rsync**, **Hedge**, **ShotPut Pro**, **YoYotta**, or any other copy tool
- Network transfers, NAS migrations, or external drive shuffles

If the copy was made by something else and you just want a quick sanity check — this is the right tool.

## What It Does

- Compare a source folder and target folder side by side
- Detect **missing**, **extra**, **different**, and **identical** files
- Detect broken symbolic links, report what they point to, and guide operator-reviewed relinking
- Copy missing or changed files into the target
- Generate an **MHL v1.1** manifest from either compared folder after a full xxHash64 scan
- Verify an existing `.mhl` against the scanned folders — classic MHL v1.x and ASC MHL v2.0 (Silverstack 9+)

## Key Features

- Dual folder drop zones (source + target) — selections preserved when switching modes
- **Reference folder compare** — an optional third folder compares the same content across three locations at once; the results table shows per-file status across all of them (all identical, present but different, missing in one, only in one, two-match-one-differs)
- **Saved profiles with watch** — save a comparison as a named profile and reload folders and settings in one action; an optional watch (1 minute to 1 hour) monitors for filesystem drift and posts a notification with a badge on the profile row
- **Two-phase scan progress** — files are counted first (`Discovering files… N found`), then scanned against that known total (`Scanning/Hashing X% — N of M files`) rather than an approximate count
- **Quick Scan** — name, size, and date comparison (fast, no hashing)
- **Full Scan** — xxHash64 (~9.6 GB/s) or SHA-256 content hashing
- Per-file comparison results with visual status, including **Date Only Difference** for harmless date-difference artefacts
- **Per-file Hash Check** — verify a single file pair from a quick scan without rescanning everything
- **Check All Hashes** — sequentially verify every Date Only Difference pair with a live progress counter and Cancel
- **Copy All Missing** (sorted smallest-first) to sync differences into the target
- Within-file byte progress so the data bar moves throughout large-file copies
- NAS/network volume support — `fsync` fallback avoids indefinite hang on SMB/NFS destinations
- **Clean Windows Files** — moves `$RECYCLE.BIN`, `Desktop.ini`, `Thumbs.db`, and similar artifacts to macOS Trash
- **Subfolder Check** overview with on-demand drill-down that respects the active scan mode
- **Subfolder drill-down repair** with `Copy` and `Copy All Missing`; Refresh re-reads disk after copy
- **Guided symlink recovery** with ranked candidates, Finder reveal, and explicit relink approval
- **P5 stub cleanup** into a same-storage `_P5 Stub Cleanup` folder
- **Refresh Comparison** to re-scan after copying
- MHL v1.1 creation (xxHash64 Full Scan only)
- MHL verification for existing manifests
- **Check for Updates** — automatic GitHub Releases check at launch; manual check via app menu
- Configurable exclusion patterns and hash algorithm in Settings; checked patterns are skipped and unchecked patterns remain included
- Standalone app — no ingest session, no receipts, no artifacts — just a clean comparison

## How It Fits With the Other Apps

| Tool | Purpose |
|------|---------|
| **CopyTrust** | Multi-source, multi-destination camera card ingest with receipts, MHL, and contact sheets |
| **Drop Verify** | Single-folder drag-and-drop artifact generation (MHL + contact sheet + EXIF CSV + optional HTML directory tree) |
| **MHL Verify** | Standalone MHL file verification against any media set |
| **Folder Copy Compare** | Post-copy sanity check — compare two folders, copy missing files, optionally generate or verify MHL |

## Related Docs

- [FOLDER_COPY_COMPARE_USER_GUIDE.md](FOLDER_COPY_COMPARE_USER_GUIDE.md) — full user guide with workflows
- [README.md](README.md) — project overview covering all four tools
