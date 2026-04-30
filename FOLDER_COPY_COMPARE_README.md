# Folder Copy Compare

The original tool that started it all.

Current documented release: **v2.3 (Build 7)**.

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
- Verify an existing `.mhl` against the scanned folders

## What’s New in v2.3 (Build 7)

- **Folder selections preserved on mode switch**: switching from Compare to Subfolder Check (or back) no longer clears the drop zones. Folders already loaded are carried over automatically.
- **Quick Scan respected in Subfolder Check drill-down**: clicking a subfolder pair now uses the active scan mode. Quick Scan produces a near-instant size-and-date comparison; Full Scan still hashes every file for content-level accuracy.
- **"Date Only" result status**: files with the same name and size but a different modification date are now classified as **Date Only** (yellow) rather than **Different content** (red). This is a normal filesystem-copy artefact and almost always harmless.
- **Per-file Hash Check**: after a Quick Scan, click the checkmark (✓) in the Actions column on any Date Only row to hash just that file pair and confirm whether the content is actually identical — no full rescan needed.
- **Clearer scan progress labels**: the progress label now reads "Hashing X% — N of ~M files" during a Full Scan and "Scanning X% — N of ~M files" during a Quick Scan. The final message reads "Hash complete" or "Scan complete" accordingly.
- **Reliable cancel behaviour**: cancelling a scan no longer shows an error or clears the folder from the drop zone. The folder stays visible with a "Scan cancelled" label and Reset is immediately available.

## Key Features

- Dual folder drop zones (source + target) — selections preserved when switching modes
- **Quick Scan** — name, size, and date comparison (fast, no hashing)
- **Full Scan** — xxHash64 (~9.6 GB/s) or SHA-256 content hashing
- Per-file comparison results with visual status, including **Date Only** for harmless date-difference artefacts
- **Per-file Hash Check** — verify a single file pair from a quick scan without rescanning everything
- **Copy All Missing** to sync differences into the target
- **Subfolder Check** overview with on-demand drill-down that respects the active scan mode
- **Subfolder drill-down repair** with `Copy` and `Copy All Missing`
- **Guided symlink recovery** with ranked candidates, Finder reveal, and explicit relink approval
- **P5 stub cleanup** into a same-storage `_P5 Stub Cleanup` folder
- **Refresh Comparison** to re-scan after copying
- MHL v1.1 creation (xxHash64 Full Scan only)
- MHL verification for existing manifests
- Configurable exclusion patterns and hash algorithm in Settings
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
