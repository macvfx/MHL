# Folder Copy Compare

The original tool that started it all.

Current documented release: **v2.4.9 (Build 1)**. Current development build: **v2.5.0 (Build 4, test)** — CopyTrust error classification; no Folder Copy Compare changes (see `CHANGELOG.md`).

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

## What’s New in v2.4.9 (Build 1)

### Reference folder compare
- Compare mode now supports an optional third folder — **Reference** — for comparing the same content across three locations simultaneously.
- Click **Compare against a reference location** below the drop zones to add a Reference folder. The Reference drop zone appears in purple alongside Source (green) and Target (blue).
- The comparison engine merges pairwise comparisons into a single results table showing per-file status: all identical, all present but different, missing in one location, only in one location, or two-match-one-differs.
- Filter, search, and "Reveal in Finder" context menus work across all three locations.

### Saved profiles with watch
- Save any comparison as a named profile using the **Save as Profile** button (bookmark icon) next to the mode picker in Compare mode.
- Manage profiles via the **sidebar drawer** (bookmark toggle button). Load a profile to instantly restore folders and settings — profiles with a reference folder automatically enable the reference drop zone.
- **Watch** toggle per profile monitors folders for filesystem changes (FSEvents). On drift, a macOS notification is posted and a red badge appears on the profile row.
- Configurable watch interval (1 min to 1 hour). Clear drift with the × button.

### Two-phase scan progress
- Scanning now shows two distinct phases: **"Discovering files… N found"** counts files first, then **"Scanning/Hashing X% — N of M files"** reports exact progress against the known total. No more approximate counts.

## What’s New in v2.4.8 (Build 1)

### Exclusion verification
- Folder Copy Compare now has scanner-level tests proving enabled and disabled exclusion checkboxes are respected.
- Checked file/folder-name patterns are skipped during scans.
- Unchecked patterns remain included, including Camera Card folders such as `THMBNL`.
- The hidden-file toggle is covered separately, so hidden files are skipped only when that setting is enabled.

### Packaging
- Folder Copy Compare no longer links or initializes Sentry. Sentry remains scoped to CopyTrust.

## What’s New in v2.4.1 (Build 7)

### Copy reliability and progress
- **Copy All Missing sorts smallest-first**: files are now copied smallest-to-largest so the file counter starts moving immediately — even when the batch contains very large files.
- **Within-file byte progress**: the Data progress bar and byte counter update continuously as each file is being written, throttled to 100 ms. A 127 GB file now shows real progress from the first buffer flush rather than sitting at 0% until the whole file finishes.
- **NAS / network volume copy fixed**: `Copy All Missing` and per-file `Copy` no longer hang on SMB/NFS destinations. Network volumes now use `fsync` instead of `F_FULLFSYNC`, which blocks indefinitely waiting for a physical media flush the NAS never promptly acknowledges.
- **Subfolder Check drill-down Refresh fixed**: clicking Refresh (or the automatic recompute after a batch copy) now re-enumerates the target folder from disk, so newly copied files appear immediately rather than still showing as missing.

### UI enhancements
- **"Date Only Difference"**: the Quick Scan status for same-size, different-date pairs is now labelled **Date Only Difference** throughout the UI for clarity.
- **Check All Hashes**: a **Check All (N)** link appears in the Date Only Difference group in the sidebar. Hashing runs sequentially — one file pair at a time — with a live N of M counter and a Cancel button.
- **Clean Windows Files**: a **Clean Windows Files (N)** toolbar button appears when the comparison contains Windows system artifacts (`$RECYCLE.BIN`, `Desktop.ini`, `Thumbs.db`, `ehthumbs.db`, `AUTORUN.INF`). A confirmation dialog is shown; files are sent to the macOS Trash, not permanently deleted.

### App-level (v2.4 Build 1)
- **Check for Updates**: all three apps (FolderCopyCompare, CopyTrust, Drop Verify) now check GitHub Releases automatically at launch (at most once every 24 hours, silently). A **Check for Updates…** item in the app menu allows a manual check at any time. When a newer release is available, an alert shows version numbers, release notes, and a Download button linking to the GitHub release page.

## Key Features

- Dual folder drop zones (source + target) — selections preserved when switching modes
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
| **Drop Verify** | Single-folder drag-and-drop artifact generation (MHL + contact sheet + EXIF CSV) |
| **MHL Verify** | Standalone MHL file verification against any media set |
| **Folder Copy Compare** | Post-copy sanity check — compare two folders, copy missing files, optionally generate or verify MHL |

## Related Docs

- [FOLDER_COPY_COMPARE_USER_GUIDE.md](FOLDER_COPY_COMPARE_USER_GUIDE.md) — full user guide with workflows
- [README.md](README.md) — project overview covering all four tools
