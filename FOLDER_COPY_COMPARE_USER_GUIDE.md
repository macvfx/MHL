# Folder Copy Compare User Guide

Tested version: **v2.3 (Build 7)**.

This guide covers the standalone **Folder Copy Compare** app — the original tool in the suite and the simplest way to answer: *did the copy work?*

## When to Use This App

Use Folder Copy Compare after you have already copied files with **any** tool:

- CopyTrust camera card ingest
- Archiware P5 Sync or P5 Archive restores
- A plain Finder copy or `cp -r`
- rsync, Hedge, ShotPut Pro, YoYotta, or any other copy tool
- Network transfers, NAS migrations, or external drive shuffles

No setup, no session, no artifacts — just drop two folders and compare.

## Two Modes

Folder Copy Compare has two modes, selectable from the **Compare | Subfolder Check** segment control at the top of the window:

- **Compare** — the original full file-by-file comparison. Drop two folders, scan, compare. See all differences down to individual files.
- **Subfolder Check** — a fast structural sanity check. Drop two folders, get a side-by-side view of their immediate subfolders with match indicators and stub file warnings. Click any row to drill down into a comparison of just that subfolder pair (Quick or Full Scan), then repair missing files or clean up P5 stubs in place.

Use Compare when you want a complete answer. Use Subfolder Check when you want a quick overview first — especially useful after Archiware P5 restores or any operation that works folder-by-folder.

**Switching modes does not clear your drop zones.** Folders loaded in Compare mode are carried over when you switch to Subfolder Check, and vice versa. You can switch freely without re-dropping.

## What’s New in v2.3 (Build 7)

- **Folder selections are preserved on mode switch.** Switching between Compare and Subfolder Check no longer clears the drop zones — folders already loaded carry over automatically and a new scan starts immediately.
- **Quick Scan is respected in Subfolder Check drill-down.** Clicking a subfolder pair now uses the active scan mode setting. Quick Scan produces a near-instant size-and-date comparison; Full Scan hashes every file for content accuracy.
- **"Date Only" result status.** After a Quick Scan, files with the same name and size but different modification dates are now shown in their own yellow **Date Only** bucket instead of the red **Different content** bucket. This is a normal artefact of filesystem copies and is almost always harmless.
- **Per-file Hash Check.** From any Date Only row, click the checkmark (✓) in the Actions column to hash just that one file pair. Source and target are hashed concurrently; the result — Identical, Different, or Failed — appears in the file detail panel without triggering a full rescan.
- **Clearer scan progress labels.** The progress bar now shows "Hashing X% — N of ~M files" during a Full Scan and "Scanning X% — N of ~M files" during a Quick Scan. The final message reads "Hash complete — N files" or "Scan complete — N files" accordingly.
- **Reliable cancel behaviour.** Cancelling a scan no longer shows an error alert or removes the folder from the drop zone. The folder stays visible with a "Scan cancelled" label and Reset is immediately available.
- **Compare Folders button hidden in Subfolder Check mode.** The button was previously visible but irrelevant in Subfolder Check mode. Scans now fire automatically when folders are dropped.

## Getting Started

### Compare mode

1. Launch `Folder Copy Compare`.
2. Make sure the mode is set to **Compare** (left segment, default).
3. Drop a **source** folder onto the left side.
4. Drop a **target** folder onto the right side.
5. Choose **Quick Scan** or **Full Scan**.
6. Click **Compare Folders**.

### Subfolder Check mode

1. Launch `Folder Copy Compare`.
2. Select **Subfolder Check** in the segment control.
3. Drop a **source** folder onto the left side.
4. Drop a **target** folder onto the right side.
5. A Phase 1 scan runs automatically — no button needed.
6. Review the subfolder table. Click any matched row to drill down.

**Tip:** If you already dropped folders in Compare mode, switching to Subfolder Check carries those folders over automatically and starts a Phase 1 scan immediately — no need to re-drop.

## Scan Modes

- **Quick Scan** compares by file count, size, and date only — no hashing. Fast but cannot detect content changes where the file size and date are the same. Progress shows "Scanning X% — N of ~M files".
- **Full Scan** hashes every file for content-level comparison. Use xxHash64 (default) for speed and MHL support. Progress shows "Hashing X% — N of ~M files".

The active scan mode applies everywhere: Compare mode, Subfolder Check drill-downs, and per-file Hash Check all use the same setting.

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

| Status | Colour | Meaning |
|--------|--------|---------|
| **Missing in target** | Red | File exists in source but not in target |
| **Extra in target** | Blue | File exists in target but not in source |
| **Different content** | Orange | File exists in both places but content hashes differ |
| **Date Only** | Yellow | File exists in both places, sizes match, but modification dates differ (Quick Scan only) |
| **Identical** | Green | File matches exactly |
| **Symlink** | Grey | Symbolic link — shown for reference, not included in difference counts |

Use the per-file **Copy** button or **Copy All Missing** to sync differences. Use **Refresh Comparison** to re-scan both folders and update results.

### Broken Symlink Recovery

Broken symlinks are common after archive restores, NAS migrations, and Final Cut Pro library moves. FCC now includes a guided recovery workflow that helps you identify those links, search likely replacement storage, and relink only after review.

Use **Recover Symlinks...** in the results toolbar when the current comparison contains one or more broken symbolic links.

1. Click **Recover Symlinks...**.
2. Choose one or more recovery roots to search. These can be restored media folders, archive targets, NAS shares, or any other location where the original files may now live.
3. FCC scans those roots recursively and groups the results by broken link path.
4. Review the ranked candidates:
   - **High** = exact filename match plus strong parent-path suffix match
   - **Medium** = exact filename match
   - **Low** = weaker extension-only resemblance
5. Use **Reveal Candidate** if you want to inspect a candidate in Finder first.
6. Click **Relink** on one row, or review several rows and use **Apply Selected**.
7. FCC rewrites only the broken symlink entry itself, then refreshes the active comparison so you can confirm the row clears.

### Recovery guardrails

- FCC does **not** mass-relink silently.
- FCC does **not** auto-apply low-confidence matches.
- FCC only relinks rows you explicitly approve.
- If a link cannot be rewritten, the row is left unchanged and the error is recorded in the recovery report/export fields.

### Recovery reporting

After running the recovery workflow, broken-symlink exports include:

- broken link path
- recorded target path
- selected candidate path
- confidence label
- recovery status
- recovery error, if any

### "Date Only" — understanding filesystem-copy date differences

When a file is copied between filesystems (Finder copy, rsync, Archiware P5 restore, or any other tool), the modification date is often reset to the current time rather than preserved. A Quick Scan embeds the modification timestamp in its comparison hash, so two copies of the same file on different filesystems hash differently even though the content is byte-for-byte identical.

**Date Only** surfaces this pattern as its own status instead of lumping it into **Different content**. An operator can immediately see that these pairs have matching sizes — a strong indicator of a harmless artefact — rather than investigating them as genuine data integrity issues.

Date Only only appears in Quick Scan results. A Full Scan hashes content directly, so a Full Scan result of Identical means the files are provably identical, and Different means the content genuinely differs regardless of dates.

### Per-file Hash Check

If you want to confirm that a Date Only pair is actually identical without running a full rescan of the entire folder, click the checkmark (✓) in the **Actions column** on that row.

- Source and target are hashed concurrently using the algorithm selected in Settings (xxHash64 or SHA-256).
- A spinner appears in the row while hashing. The result appears in the file detail panel:
  - **Identical** (green shield): content confirmed identical. The date difference is harmless.
  - **Different** (red shield): hashes differ — the files are genuinely different and warrant investigation.
  - **Failed** (grey): one or both files could not be read.
- The Hash Check button only appears on Date Only rows. Rows that already carry full-scan hashes are already content-verified and do not need an additional check.

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

## Subfolder Check Mode

### What it does

Subfolder Check examines the **immediate subfolders** of the source and target folder, aligns them by name, and gives you a quick side-by-side view of whether each pair looks right — before you spend time doing a full hash scan.

For each subfolder it shows:

| Column | What it means |
|--------|---------------|
| **Folder name** | The subfolder name. Shown on both sides if it exists on both; flagged as one-side-only if missing. |
| **Source / Target — Files** | Recursive file count inside that subfolder (not counting hidden files). |
| **Source / Target — Size** | Total size of all files in that subfolder. |
| **Source / Target — Stubs** | Count of `.p5a` and `.p5c` files — Archiware P5 archive stubs. If shown in orange, files in that folder may not be fully restored. |
| **Match** | Green = exact, Yellow = close, Red = different, Grey = exists only on one side. |

A summary bar above the table shows overall counts: Matched / Close / Different / One-side-only / Has-stubs.

### Match thresholds

Thresholds are intentionally loose to allow for legitimate differences (metadata files, receipts, logs added by a copy tool):

- **File count:** exact = Match; within ±5% = Close; beyond ±5% = Different.
- **Size:** exact = Match; within 2% or within 10 MB = Close; beyond = Different.
- Both must be exact for a pair to show as Match. If either is only Close, the pair shows as Close.

### Archiware P5 stub files

When Archiware P5 archives a file to tape, it can replace the file on disk with a low-size **stub** — a placeholder that indicates the file is stored on tape but is not currently accessible. Stubs have `.p5a` (archive stub) or `.p5c` (cache stub) extensions.

Subfolder Check counts these separately and shows an orange warning badge when any are found. A high stub count means a folder has not been fully restored from the archive. Use this to catch cases where a P5 restore job completed with errors or was interrupted — the restored folder will have the right subfolder structure but some or all files will still be stubs rather than the real content.

A `Clean` action appears beside any side that contains stubs. `Clean` does not send files to Trash. Instead, it moves only `.p5a` and `.p5c` files into a same-storage cleanup root named `_P5 Stub Cleanup`, then places each cleanup run into its own timestamped session folder. The moved files keep their relative paths inside that session folder so they can be reviewed or restored later if needed.

While the move is in progress a spinner and "Moving stubs…" label appear in the summary bar. A confirmation alert appears when the operation finishes.

The `_P5 Stub Cleanup` folder itself appears in the overview after a clean run. The `Clean` button is intentionally not shown for that folder — stubs already moved there do not need to be cleaned again.

### Drill-down: compare one subfolder pair on demand

Clicking a row where both sides exist launches a **Phase 2 drill-down** — a comparison of just that subfolder pair.

- Phase 2 uses the file list captured during Phase 1 (no re-enumeration), so no extra disk scan is needed. On a fast local drive the comparison starts within a second.
- Results appear in the standard comparison view (missing, extra, different, date only, identical) with a **← Subfolder Overview** back button in the toolbar.
- The result is cached per scan mode. Navigating back and clicking the same row again is instant (unless you switch scan mode, which forces a fresh result).
- **Drill-down respects the active scan mode.** Quick Scan produces a near-instant size-and-date comparison using the metadata already captured in Phase 1 — no hashing required. Full Scan hashes every file for content accuracy. Use Quick Scan for a fast sanity check; switch to Full Scan when you need a verified answer.
- Switching scan mode (Quick ↔ Full) and clicking the same row again always runs a fresh comparison — the cache key encodes the mode.
- Only rows where both sides exist can be drilled into. One-side-only rows have no counterpart to compare against.

From the drill-down results you can:

- use per-file **Copy** for one missing item
- use **Copy All Missing** to repair all missing files in that subfolder pair
- click **Hash Check** on any Date Only row to verify content without a full rescan
- run **Recover Symlinks...** when the drill-down contains broken links and relink them without leaving Subfolder Check
- return to the overview after repair and see refreshed counts without manually resetting the mode

### What Subfolder Check does not do

- It only looks at **immediate subfolders** — one level deep. Files sitting directly in the root folder are not shown in the table.
- MHL generation is not available in Subfolder Check mode.
- Cleanup only moves `.p5a` and `.p5c` stub files. It does not delete non-stub files and does not permanently remove anything.

### Typical Subfolder Check workflow (Quick Scan triage)

```text
Drop source and target (e.g. a P5 restore job folder and its origin)
  -> Subfolder Check mode auto-scans (fast, no hashing)
  -> Review table for any red rows, missing subfolders, or stub warnings
  -> Click a suspicious row to drill down (Quick Scan — near-instant)
  -> Review missing, different, date-only, and identical file counts
  -> For any Date Only rows, click Hash Check (shield) to confirm content
  -> Use Copy / Copy All Missing to repair missing files in that subfolder pair
  -> Use Clean on any side with P5 stubs to move them into _P5 Stub Cleanup
  -> Switch to Full Scan and re-drill if you need content-level verification
```

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

The **Help** menu contains three built-in workflow guides that open as independent reference windows:

- **Getting Started** — drop folders, scan modes, compare, copy, refresh, cancel behaviour.
- **Subfolder Check** — full guide to Subfolder Check mode: match indicators, P5 stubs, drill-down, Date Only, repair, and typical workflow.
- **MHL & Export Workflow** — MHL generation, the recommended copy-then-MHL order of operations, verification, and export.

## Keyboard Shortcuts

- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
- `⌘,` — Settings
