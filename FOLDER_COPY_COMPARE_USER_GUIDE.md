# Folder Copy Compare User Guide

Tested version: **v2.4.9 (Build 1)**. Current development build: **v2.5.0 (Build 4, test)** — CopyTrust-only changes (error classification); Folder Copy Compare behaviour is unchanged.

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

Folder Copy Compare has two modes, selectable from the **Compare | Subfolder Check** control at the top of the window:

- **Compare** — the original full file-by-file comparison. Drop two folders, scan, compare. See all differences down to individual files. Optionally add a **Reference** folder to compare across three locations. Save comparisons as named profiles using the bookmark button.
- **Subfolder Check** — a fast structural sanity check. Drop two folders, get a side-by-side view of their immediate subfolders with match indicators and stub file warnings. Click any row to drill down into a comparison of just that subfolder pair (Quick or Full Scan), then repair missing files or clean up P5 stubs in place.

Use Compare when you want a complete answer. Use Subfolder Check when you want a quick overview first — especially useful after Archiware P5 restores or any operation that works folder-by-folder.

**Switching modes does not clear your drop zones.** Folders loaded in Compare mode are carried over when you switch to Subfolder Check, and vice versa. You can switch freely without re-dropping.

## What’s New in v2.4.9 (Build 1)

### Reference folder compare

- Compare mode now supports an optional **Reference** folder for comparing the same content across three locations.
- Click **Compare against a reference location** below the drop zones. A third purple drop zone appears alongside Source (green) and Target (blue).
- Click **Compare All** to run the comparison. Results merge into a single table showing per-file status across all three locations.
- Statuses include: all identical, all present but different, missing in source/target/reference, only in one location, and two-match-one-differs.
- Filter by status, search by filename, and right-click any row to reveal the file in Finder at any of the three locations.
- Click **Remove Reference** to return to standard two-folder comparison.

### Saved profiles

- Click the **Save as Profile** button (bookmark with plus icon) next to the mode picker to save the current comparison setup (source, target, optional reference, scan mode) as a named profile.
- Open the **profile drawer** using the bookmark toggle button next to the mode picker.
- Click **Load** on any profile to instantly populate the drop zones. Profiles with a reference folder automatically enable the reference drop zone.
- Edit a profile’s name, paths, scan mode, or watch interval via the ⋯ menu.

### Two-phase scan progress

- Scanning now shows two clearly distinct phases: first **"Discovering files… N found"** while file enumeration runs, then **"Scanning/Hashing X% — N of M files"** with exact progress against the known total. No more approximate file counts.

### Folder watch with drift detection

- Toggle the **eye icon** on any saved profile to start watching its folders for changes.
- The watch uses macOS FSEvents (`DispatchSource`) to detect file writes, renames, deletions, and attribute changes.
- When drift is detected, a **macOS notification** is posted and a **red dot** appears on the profile row.
- Watch interval is configurable per profile: 1 min, 5 min, 15 min, 30 min, or 1 hour.
- Clear the drift alert with the **×** button. The bottom bar shows how many profiles are actively watched.

## What’s New in v2.4.1 (Build 7)

### Copy reliability and progress

- **Copy All Missing sorts files smallest-first.** Files are copied smallest-to-largest so the file counter starts moving immediately — even when the batch contains very large files. Applies to both Compare mode and Subfolder Check drill-down.
- **Within-file byte progress.** The Data progress bar and byte counter now update continuously as each file is being written, throttled to 100 ms. A 127 GB file shows real progress from the first buffer flush rather than sitting at 0% until the whole file finishes.
- **NAS / network volume copy fixed.** `Copy All Missing` and per-file `Copy` no longer hang on SMB/NFS destinations. Network volumes now use `fsync` instead of `F_FULLFSYNC`, which blocks indefinitely waiting for a physical media flush the NAS may never promptly acknowledge. Local volumes (APFS, HFS+, exFAT on directly attached drives) still use `F_FULLFSYNC` for stronger durability.
- **Subfolder Check drill-down Refresh fixed.** After copying missing files in a drill-down, clicking **Refresh** (or the automatic recompute that runs after a batch copy) now re-enumerates the target folder from disk. Newly copied files appear immediately rather than still showing as missing.

### UI enhancements

- **"Date Only Difference" label.** The Quick Scan status for same-size, different-date pairs is now labelled **Date Only Difference** throughout the UI for clarity.
- **Check All Hashes.** A **Check All (N)** link appears in the Date Only Difference sidebar group whenever there are unchecked pairs. Hashing runs sequentially — one pair at a time — with a live "N of M" counter and a **Cancel** button. Partial results are preserved if you cancel.
- **Clean Windows Files.** A **Clean Windows Files (N)** toolbar button appears when the comparison contains Windows system artifacts: `$RECYCLE.BIN` entries, `Desktop.ini`, `Thumbs.db`, `ehthumbs.db`, or `AUTORUN.INF`. A confirmation dialog is shown before anything moves; files go to the macOS Trash and are fully recoverable.

### App-level — Check for Updates (v2.4 Build 1)

- All three apps (FolderCopyCompare, CopyTrust, Drop Verify) now check GitHub Releases automatically at launch, at most once every 24 hours, silently. No alert unless an update is found.
- A **Check for Updates…** menu item appears under the app name after About. Clicking it always checks immediately and reports the result.
- When a newer release is available, an alert shows current and latest version numbers, release notes, and a **Download** button that opens the GitHub release page.
- No analytics, no file download — only the version tag is fetched from GitHub.

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

### Reference compare

1. In **Compare** mode, drop a source and target folder.
2. Click **Compare against a reference location** below the drop zones.
3. Drop a third folder onto the purple **Reference** zone.
4. Click **Compare All**.
5. Review the merged results table showing status across all three locations.

### Saving and loading profiles

1. Set up a comparison (with or without a reference folder) and run it.
2. Click the **Save as Profile** button (bookmark with plus icon) next to the mode picker.
3. Give it a name and save.
4. To reload later: open the profile drawer (bookmark toggle), click **Load** on the saved profile.
5. To watch for drift: click the **eye icon** on any profile. You'll receive a macOS notification when files change.

## Scan Modes

- **Quick Scan** compares by file count, size, and date only — no hashing. Fast but cannot detect content changes where the file size and date are the same. Progress shows "Discovering files… N found" during enumeration, then "Scanning X% — N of M files" during processing.
- **Full Scan** hashes every file for content-level comparison. Use xxHash64 (default) for speed and MHL support. Progress shows "Discovering files… N found" during enumeration, then "Hashing X% — N of M files" during processing.

The active scan mode applies everywhere: Compare mode, Subfolder Check drill-downs, and per-file Hash Check all use the same setting.

## Settings

Open **Folder Copy Compare > Settings** (`⌘,`) to configure:

- **Exclusions** — file and folder patterns to skip during scanning (grouped by category: Coding, File Storage, System, Media Files, Camera Card). Every visible checkbox is respected: checked patterns are skipped and unchecked patterns remain included. The **System** group is enabled by default and excludes OS-generated directories (`.Spotlight-V100`, `.fseventsd`, `.Trashes`, `@eaDir`, `System Volume Information`, etc.). Camera Card patterns such as `MISC`, `THMBNL`, `.THM`, and `.LRV` are optional and are not silently forced on. All pattern matching is case-insensitive.
- **Scan Options** — hidden files, symlink handling, hash algorithm, concurrency, and metadata cache. **Skip hidden files and folders** is enabled by default, excluding dot-prefixed items (e.g. `.git`, `.ssh`) from scans.

Scanner tests cover this behavior: enabled file/folder-name matches are skipped, unchecked patterns such as `.tmp` and `THMBNL` remain included, and hidden files are controlled only by the hidden-file toggle.

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
| **Date Only Difference** | Yellow | File exists in both places, sizes match, but modification dates differ (Quick Scan only) |
| **Identical** | Green | File matches exactly |
| **Symlink** | Grey | Symbolic link — shown for reference, not included in difference counts |

Use the per-file **Copy** button or **Copy All Missing** to sync differences. **Copy All Missing** copies files in smallest-to-largest order so the file counter starts moving immediately. Use **Refresh Comparison** to re-scan both folders and update results.

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

### "Date Only Difference" — understanding filesystem-copy date differences

When a file is copied between filesystems (Finder copy, rsync, Archiware P5 restore, or any other tool), the modification date is often reset to the current time rather than preserved. A Quick Scan embeds the modification timestamp in its comparison hash, so two copies of the same file on different filesystems hash differently even though the content is byte-for-byte identical.

**Date Only Difference** surfaces this pattern as its own status instead of lumping it into **Different content**. An operator can immediately see that these pairs have matching sizes — a strong indicator of a harmless artefact — rather than investigating them as genuine data integrity issues.

Date Only Difference only appears in Quick Scan results. A Full Scan hashes content directly, so a Full Scan result of Identical means the files are provably identical, and Different means the content genuinely differs regardless of dates.

### Per-file Hash Check

If you want to confirm that a Date Only Difference pair is actually identical without running a full rescan, click the checkmark (✓) in the **Actions column** on that row.

- Source and target are hashed concurrently using the algorithm selected in Settings (xxHash64 or SHA-256).
- A spinner appears in the row while hashing. The result appears in the file detail panel:
  - **Identical** (green shield): content confirmed identical. The date difference is harmless.
  - **Different** (red shield): hashes differ — the files are genuinely different and warrant investigation.
  - **Failed** (grey): one or both files could not be read.
- The Hash Check button only appears on Date Only Difference rows. Rows that already carry full-scan hashes are already content-verified and do not need an additional check.

### Check All Hashes (Date Only Difference group)

To verify the entire Date Only Difference group without clicking each row individually, use **Check All (N)** — the link that appears below the Date Only Difference filter in the sidebar.

- Hashing runs **sequentially** — one file pair at a time — so disk I/O stays focused. Results appear row by row as each pair completes.
- Progress is shown inline as "N of M checked" with a spinner while running.
- A **Cancel** button stops the sequence after the current pair finishes. Partial results are preserved — the button reappears for the remaining unchecked items.

### Clean Windows Files

When a folder was previously used on Windows, it may contain system artifacts that are meaningless on macOS: `$RECYCLE.BIN` entries, `Desktop.ini`, `Thumbs.db`, `ehthumbs.db`, or `AUTORUN.INF`.

When any of these appear in the comparison, a **Clean Windows Files (N)** button appears in the compare toolbar.

- A confirmation dialog is shown before any files are moved.
- Files are sent to the **macOS Trash** (not permanently deleted — they can be recovered from Trash if needed).
- The comparison list refreshes automatically after cleanup. The button is hidden when no artifacts are present.

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

Both manifest generations are supported (v2.5.1): classic **MHL v1.x** (CopyTrust, Drop Verify, OffShoot, ShotPut Pro, YoYotta) and **ASC MHL v2.0** — the default output of Pomfort Silverstack 9+. For ASC MHL files stored in an `ascmhl/` subfolder, paths resolve against that folder's parent automatically.

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
  -> For any Date Only Difference rows, click Hash Check (shield) to confirm content
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

## Check for Updates

Folder Copy Compare checks GitHub Releases automatically at launch, at most once every 24 hours. The check is silent — no alert appears unless a newer release is found.

To check manually at any time, choose **Folder Copy Compare > Check for Updates…** from the menu bar.

- When a newer release is available, an alert shows the current and latest version numbers, release notes, and a **Download** button that opens the GitHub release page in your browser.
- When already up to date, the alert confirms the current version matches the latest release.
- No analytics or file download — only the version tag is fetched from GitHub.

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
