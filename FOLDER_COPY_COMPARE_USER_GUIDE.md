# Folder Copy Compare User Guide

Tested version: **v2.1.5 (build 1)**.

This guide covers the standalone **Folder Copy Compare** app — the original tool in the suite and the simplest way to answer: *did the copy work?*

## When to Use This App

Use Folder Copy Compare after you have already copied files with **any** tool:

- CopyTrust camera card ingest
- Archiware P5 Sync or P5 Archive restores
- A plain Finder copy or `cp -r`
- rsync, Hedge, ShotPut Pro, YoYotta, or any other copy tool
- Network transfers, NAS migrations, or external drive shuffles

No setup, no session, no artifacts — just drop two folders and compare.

## Getting Started

1. Launch `Folder Copy Compare`.
2. Drop a **source** folder onto the left side.
3. Drop a **target** folder onto the right side.
4. Choose **Quick Scan** or **Full Scan**.
5. Click **Compare Folders**.

## Scan Modes

- **Quick Scan** compares by file count, size, and date only — no hashing. Fast but cannot detect content changes where the file size and date are the same.
- **Full Scan** hashes every file for content-level comparison. Use xxHash64 (default) for speed and MHL support.

## Settings

Open **Folder Copy Compare > Settings** (`⌘,`) to configure:

- **Exclusions** — file and folder patterns to skip during scanning (grouped by category).
- **Scan Options** — symlink handling, hash algorithm, concurrency, and metadata cache.

### Hash Algorithm

In **Settings > Scan Options > Hash Algorithm**, choose the algorithm used by Full Scan:

| Algorithm | Speed | MHL Support | Notes |
|-----------|-------|-------------|-------|
| **xxHash64** (default) | ~9.6 GB/s on Apple Silicon | Yes | Non-cryptographic and optimized for integrity checking. |
| **SHA-256** | ~200 MB/s | No | Slower cryptographic hash for workflows that require it. |

Switching algorithms invalidates cached hashes, so the next scan re-hashes all files.

## Comparison Results

After the scan completes, click **Compare Folders** to see:

- **Missing in target**: file exists in source but not target
- **Extra in target**: file exists in target but not source
- **Different content**: file exists in both places but hashes differ
- **Identical**: file matches

Use the per-file **Copy** button or **Copy All Missing** to sync differences. Use **Refresh Comparison** to re-scan both folders and update results.

## MHL Menu

After a comparison completes, the **MHL** menu (shield icon) appears in the results bar, to the left of **Export Report**. It contains:

### Generate MHL

Available after a Full Scan with `xxHash64`. Choose one of:

- **Generate MHL — Source**: write an MHL into the source folder root
- **Generate MHL — Target**: write an MHL into the target folder root

The generated file is an **MHL v1.1** manifest with xxHash64 digests, file sizes, modification dates, and tool metadata.

MHL generation always rescans the folder before writing, so the manifest reflects the current state of the folder on disk — including any files copied since the last comparison.

MHL generation is not available when using `SHA-256`, because MHL v1.1 requires xxHash64 digests.

### Verify MHL

Click **Verify MHL...** and select an existing `.mhl` file.

The app determines which scanned folder to verify based on the manifest location and reports:

- **Matched**: file hash matches the MHL entry
- **Mismatched**: file exists but does not match
- **Missing**: file listed in the MHL was not found

This is useful for verifying copies made by other tools or re-checking a previously generated manifest.

## Typical Workflows

### Basic compare and sync

```text
Drop source and target
  -> Full Scan (xxHash64)
  -> Compare Folders
  -> Copy All Missing
  -> Refresh Comparison
```

### Compare, copy, and generate MHL proof

This is the recommended workflow when you need to sync missing files and then prove integrity of the result. You do not need to manually refresh before generating the MHL — the app rescans the folder automatically.

```text
Drop source and target
  -> Full Scan (xxHash64)
  -> Compare Folders
  -> Copy All Missing
  -> MHL > Generate MHL — Target
  -> MHL > Verify MHL (select the MHL just created)
```

### Generate proof-of-integrity manifest

```text
Drop folder as source
  -> Full Scan (xxHash64)
  -> Compare Folders
  -> MHL > Generate MHL — Source
```

### Verify against existing MHL

```text
Drop folder as source
  -> Full Scan (xxHash64)
  -> Compare Folders
  -> MHL > Verify MHL
```

## Help Menu

The **Help** menu contains two built-in workflow guides that open as independent reference windows:

- **Getting Started** — drop folders, scan modes, compare, copy, refresh.
- **MHL & Export Workflow** — MHL generation, the recommended copy-then-MHL order of operations, verification, and export.

## Keyboard Shortcuts

- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
- `⌘,` — Settings
