# Folder Copy Compare

The original tool that started it all.

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
- Copy missing or changed files into the target
- Generate an **MHL v1.1** manifest from either compared folder after a full xxHash64 scan
- Verify an existing `.mhl` against the scanned folders

## Key Features

- Dual folder drop zones (source + target)
- **Quick Scan** — name, size, and date comparison (fast, no hashing)
- **Full Scan** — xxHash64 (~9.6 GB/s) or SHA-256 content hashing
- Per-file comparison results with visual status
- **Copy All Missing** to sync differences into the target
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
