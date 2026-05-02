# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

**v2.4.1 Build 7** — 
- Folder Copy Compare copy reliability and progress sprint.
-  Copy All Missing now sorts files smallest-to-largest so the file counter starts moving immediately even on batches containing very large files. The Data progress bar updates continuously as each file is being written — for a 127 GB file the progress bar moves from the first buffer flush rather than sitting at 0% until the whole file finishes.
-  Also in this sprint: NAS/network copy hangs fixed (network volumes now use `fsync` instead of `F_FULLFSYNC`, which blocks indefinitely waiting for physical NAS flush);
-  single-file copy on NAS fixed; Refresh in Subfolder Check drill-down now correctly reflects newly copied files by re-enumerating the target directory from disk;
-  `Date Only Difference` replaces the earlier "Date Only" label throughout the UI;
-  sequential Check All Hashes for the Date Only Difference group; and
-  Windows artifact cleanup (`$RECYCLE.BIN`, `Desktop.ini`, `Thumbs.db`, etc.) moved to Trash in one operation.
-  App hang fixes (Sentry-detected): `statusCounts` replaced with a single-pass `ItemCounts` struct; progress callbacks throttled to 100 ms.

**v2.4 Build 1**  — All three apps now check for new releases on GitHub automatically at launch (at most once every 24 hours, silently). A **Check for Updates…** menu item appears under the app name after About. When a newer release is found, an alert shows version numbers, release notes, and a Download button linking to the GitHub release page. Powered by the `GitHubUpdateChecker` Swift package — no analytics, no file download, just the version tag.


### MHL Verify (2.3 build 7)
- Scrolling through an MHL's content in the Reader tab did not work. The scroll bar was visible but unresponsive.
- MHL files created by production tools that generate their own file-type metadata are now recognised by MHL Verify.
- The Quick Look extension now also previews `.mhl` files stamped with alternate type identifiers, consistent with the main app changes above.
- The biggest gains since `v2.1.8` and `v2.1.9` are shared MHL correctness and interoperability rather than large UI changes.
- MHLs written by the suite now preserve source path and source identity more accurately and no longer treat pre-existing `.mhl` receipts as media entries.
- Practical summary: MHL verification across suite-generated manifests should now be more trustworthy and easier to compare with other MHL-capable tools.

### mhl-tool (CLI)
- The main changes since `v2.1.8` and `v2.1.9` are shared `CopyCore` MHL improvements rather than a large CLI workflow redesign.
- The CLI now benefits from the same cleaner source metadata handling and `.mhl` entry filtering used by the apps.
- Practical summary: `mhl-tool` now produces cleaner, more interoperable manifests that better match the current app-side trust workflow.

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
- Destination relay-order staging with visible `Stop 1`, `Stop 2`; queued relay legs can be pulled back into the workspace with `Edit` for reordering
- **Resumable CopyTrust ingest** for cancelled same-source/same-destination runs and failed partial runs when the saved manifest still matches the same source, destinations, and rendered subfolder
- **Contact sheet PDF** (row or grid layout) and **EXIF metadata CSV** after each ingest — professional formats (MXF, R3D, BRAW, ARRIRAW, M2V, VOB) show placeholders in the stable release, while this branch uses ExifTool for richer metadata, ffmpeg for MXF and MPEG-2 family thumbnails, and REDline for R3D thumbnails. PDF/CSV run as independent background artifacts after trust-critical copy + verify + MHL completion.
- Session receipts (JSON + TXT), per-ingest logs, and optional export to a separate folder, including overall relay-chain summaries at session close
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export
- Safe-to-eject flow after successful transfer
- Built-in Help flow with `Quick Start`, `Advanced Start`, and a Help menu entry to reopen CopyTrust guidance
- Asynchronous contact-sheet auto-open and richer verify-start / verify-abort diagnostics for easier troubleshooting


## Drop Verify

Single-folder drag-and-drop verification. Drop a folder and generate trust artifacts — no copy, no session, no setup.

- Media-only recursive scan with configurable exclusion patterns
- Generates **MHL**, **contact sheet PDF** (row or grid), and **EXIF metadata CSV**
- Writes artifacts into the folder and/or mirrors them to an export folder

## MHL Verify

Standalone MHL verification. Load any `.mhl` file and verify whether the media files still match.

- Re-check copies, archive restores, and handoff deliveries
- Works with MHLs from Drop Verify, CopyTrust, OffShoot, Silverstack, or any MHL-capable tool

## Folder Copy Compare

The original tool that started the suite — a simple "did the copy work?" sanity check. Drop two folders and get an honest answer.

Use after copying with CopyTrust, Archiware P5 Sync, a Finder copy, `rsync`, Hedge, ShotPut Pro, or any other tool.

- **Compare mode** — Quick Scan (name, size, date) or Full Scan (xxHash64 / SHA-256 content hashing); per-file comparison: missing, extra, different, identical; **Copy All Missing** to sync differences, then **Refresh** to re-verify; MHL v1.1 generation and verification from either compared folder
- **Subfolder Check mode** — fast structural sanity check: aligns immediate subfolders side-by-side with file counts, total sizes, and Archiware P5 stub file detection (`.p5a` / `.p5c`); colour-coded match indicators (exact / close / different / one-side-only); click any matched row to drill down using the active Quick / Full Scan setting
- **Date Only** quick-scan status plus per-file **Hash Check** for same-size, different-date pairs without forcing a full rescan
- Folder selections persist across Compare / Subfolder Check mode switches; scan cancel is non-destructive; stub cleanup now shows progress and hides `Clean` on the `_P5 Stub Cleanup` folder
- Standalone app — no ingest session, no receipts, no artifacts

## mhl-tool (CLI)

Command-line tool for creating and verifying MHL v1.1 manifests. Same MHL engine as CopyTrust and Drop Verify, built for the terminal.

- `mhl-tool create <folder>` — hash files and write an MHL manifest
- `mhl-tool verify <folder>` — verify files against MHL(s), auto-discovers `_Receipts`
- Media-only (default) or `--all-files` mode
- JSON output for scripting, quiet mode for CI
- Reads MHLs from any tool (OffShoot, Silverstack, ShotPut Pro, YoYotta)
- Signed, notarized `.pkg` installer for distribution

## Keyboard Shortcuts

### Folder Copy Compare
- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
