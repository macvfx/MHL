# Drop Verify User Guide

Current app version: **v2.5.4 (Build 6)**. Build 6 aligns the shared release number; it contains no Drop Verify behavior change.

## External Codec Setup

The tested unsupported-format setup is:

- `ExifTool` for MXF and R3D metadata
- `ffmpeg` for MXF contact-sheet thumbnails
- `REDline` for R3D contact-sheet thumbnails

Recommended setup:
- Open `Drop Verify > Settings… > External Codecs`
- Turn on `Enable ExifTool metadata extraction`
- Use `Auto-Detect` or `Browse…` for `exiftool`
- Turn on `Enable external thumbnail codecs`
- Enable the `MXF` and `R3D` format toggles you want to test
- Use `Auto-Detect` or `Browse…` for:
  - `ffmpeg` when testing MXF
  - `REDline` when testing R3D

Expected branch behavior:
- ExifTool enriches MXF and R3D metadata in the contact sheet and CSV when enabled.
- HTML directory tree output is generated natively and does not require the external `tree` command.
- ffmpeg provides MXF thumbnails when enabled and valid.
- REDline provides R3D thumbnails when enabled and valid.
- If ffmpeg or REDline fails, Drop Verify falls back to the placeholder behavior and logs the attempt.

## What Drop Verify Does

Drop Verify is a one-folder analysis tool.

You drag a folder into the app, choose the artifacts you want, and Drop Verify does only the work required for those selected outputs:

- `MHL (Media Hash List)`
- `Contact sheet PDF`
- `EXIF camera metadata CSV`
- `HTML directory tree` (optional project index or recursive tree output)

The MHL is the hash-producing trust artifact. If MHL is disabled, Drop Verify can still create CSV, contact sheet, or HTML tree/index outputs without hashing files.

## Basic Workflow

### 1. Open Drop Verify
- Launch the `Drop Verify` app target.

### 2. Review settings
- Open `Drop Verify > Settings…`
- Choose which artifacts should be written in the dropped folder:
  - `MHL (Media Hash List)`
  - `Contact sheet PDF (thumbnails and camera data)`
  - `EXIF camera metadata CSV (Spreadsheet)`
  - `HTML directory tree` (generated natively; no external `tree` command required)
- Choose **Contact sheet layout**: Row (detailed metadata) or Grid (3×4 poster, 12 items per page).
- Optionally enable **Hide unsupported format placeholders** to omit files that cannot generate thumbnails (MXF, R3D, M2V, etc.) from the contact sheet PDF. These files still appear in the EXIF CSV and MHL.
- Optionally set **Split large contact sheets** (v2.5.4): **Off — single PDF** (default), or every **250 / 500 / 1,000** files. Folders over the limit are written as numbered PDFs (`…_part1of3.pdf`, `…_part2of3.pdf`, …), each with a "Part x of y — files a–b" line in the header.
- Optionally enable **ExifTool metadata extraction** and **external thumbnail codecs** for MXF and R3D (see External Codec Setup above).
- Optionally enable export to an extra export folder.
- Leave `Exclude hidden files` enabled unless you explicitly need hidden content scanned.
- In `Settings > Exclusions`, leave generated-artifact exclusions enabled unless you want prior receipt/MHL/report outputs included in a later scan. Camera Card exclusions are optional and are used only when checked.

### 3. Drop a folder
- Drag one folder onto the main Drop Verify window.
- Or click `Choose Folder`.

Drop Verify scans recursively and only includes media files.

Exception: if the only enabled output is `HTML directory tree`, Drop Verify skips media scanning, hashing, and metadata extraction, then generates the requested folder tree/index directly.

### 4. Wait for artifact generation
The app runs only the stages needed for the selected outputs:

- scan media files when MHL, CSV, or contact sheet output is selected
- hash files only when MHL output is selected
- extract image/video metadata when CSV or contact sheet output needs it
- write CSV when enabled
- render contact sheet PDF when enabled
- generate HTML directory tree/index when enabled
- write/export selected artifacts

Use the **Cancel** button in the header bar to stop at any time without quitting the app. When a hashing run is cancelled, a partial session manifest is saved recording which files were verified before the cancellation. A **Reveal Manifest** button appears in the status card to open it. Runs that do not produce hashes do not write a session manifest.

**Read-only media:** If the dropped folder is on read-only media (locked SD card, encrypted drive, write-protected volume), Drop Verify detects this before scanning and prompts you to choose an export folder. If an export folder is already configured in Settings, artifacts are written there automatically — the export folder is revealed in Finder when done, and artifact rows show an "Exported" badge with clickable links to the exported files.

### 5. Review artifacts
If local output is enabled, artifacts are written into:

- `Drop Verify_Receipts/`

You can open individual artifacts from the app after generation.

## What Each Artifact Is For

### MHL (Media Hash List)
- Industry-standard manifest of file hashes
- Useful for later verification and handoff records
- Enabling MHL is what makes Drop Verify hash media files and write a session manifest

### Contact sheet PDF
- Quick visual summary of media found in the dropped folder
- Includes thumbnails and camera/media metadata
- Two layout styles: **Row** (one clip per row with detailed metadata) or **Grid** (3×4 poster, 12 items per page with single thumbnail + caption per item)
- In the stable release, professional and legacy formats (MXF, R3D, BRAW, ARRIRAW, CinemaDNG, M2V, M2T, M2TS, VOB) appear with "No Preview" placeholders and the file type name unless hidden.
- When external codecs are configured, MXF can show real ffmpeg thumbnails and R3D can show real REDline thumbnails while still using ExifTool-backed metadata.
- Recent Build 2 polish: REDline validation now better recognizes working installs, R3D contact-sheet thumbnails render at a more practical size, and crowded unsupported-format metadata blocks are trimmed back in the PDF.
- Header shows a summary when files could not be previewed (e.g. "2 files without preview (MXF: 1, R3D: 1)")
- Footer shows "Drop Verify" branding (CopyTrust contact sheets show "CopyTrust")
- **Split large contact sheets** (v2.5.4): when a split limit is set and the folder exceeds it, output is multiple numbered PDFs instead of one very large one. Each part's header identifies its part number and file range; the extra export folder receives every part. The header's total-size figure is the size of the scanned media, not of the PDF itself.

### EXIF camera metadata CSV
- Spreadsheet-friendly export of file path and metadata fields
- Intended for reporting, sorting, and review in Numbers, Excel, or Google Sheets
- When ExifTool is configured, CSV output also includes richer ExifTool-backed fields such as start timecode, audio sample rate, audio bit depth, and firmware/application version where available for MXF and R3D
- The current testing build can also populate fields such as `VideoFormat`, `ReelNumber`, `CameraSerialNumber`, `StorageModel`, and `StorageSerialNumber` where ExifTool provides them.
- CSV can be generated without MHL. In that mode Drop Verify indexes media and reads metadata, but does not hash files.

### HTML directory tree
- HTML view of the folder's directory structure
- Opens in any web browser — self-contained, no external dependencies
- **Project summary index** generates a lightweight top-level project index directly in Drop Verify.
- **One HTML per top-level folder** generates an index plus one recursive HTML tree for each immediate subfolder. This is the recommended recursive mode for very large projects and network shares.
- **Entire project** generates one recursive HTML tree for the whole dropped folder. Use it only when a single complete tree file is required.
- Recursive modes use native file enumeration and render collapsible `<details>` elements for directories. No HTML tree mode requires the external `tree` command.
- For very large project folders or slow network shares, use **Project summary index** or **One HTML per top-level folder** rather than **Entire project** unless a single complete tree file is required.
- If HTML directory tree is the only enabled output, Drop Verify skips media hashing and metadata analysis entirely. This is the fastest way to create a project folder summary.

## Exclusions

Drop Verify excludes:

- hidden files by default
- generated receipt/artifact folders
- built-in or custom patterns enabled in Drop Verify Settings

Use the `Exclusions` tab in Settings to add or remove patterns. Every visible checkbox is respected: checked patterns are skipped, unchecked patterns remain included.

The Camera Card group includes optional patterns for common card-side folders and sidecar/proxy files: `MISC`, `THMBNL`, `BACKUP`, `CLIPINF`, `.THM`, `.LRV`, `.SCR`, `.db`, and `.Db`. These are disabled by default. For example, if `THMBNL` is unchecked, Drop Verify scans matching media normally; if `THMBNL` is checked, matching folders are skipped.

## Expected Artifact Filenames

New artifacts use the subject-first pattern `<folderName>_<date-time>_dropverify_<type>.<ext>`:

| Artifact | Filename example |
|----------|-----------------|
| MHL | `Drop Verify - 2026-06-07 at 15.19.19 - LiveCam.mhl` |
| Contact Sheet | `LiveCam_2026-06-07-151919_dropverify_contactsheet.pdf` |
| EXIF CSV | `LiveCam_2026-06-07-151919_dropverify_exif.csv` |
| HTML Tree / Index | `LiveCam_2026-06-07-151919_dropverify_tree_index.html` or `LiveCam_2026-06-07-151919_dropverify_tree.html` |
| Session Manifest | `SESSION_MANIFEST_LiveCam_2026-06-07-151919.json` |

When "One HTML per top-level folder" mode is selected, each immediate subfolder produces its own HTML tree file and the generated subject-first index links to those files. The index file is shown as the clickable HTML artifact in the Artifacts card. Legacy pre-Build-5 filenames are still recognized.

## Output Locations

### Write in dropped folder
When enabled, Drop Verify writes selected outputs into the dropped folder under:

- `Drop Verify_Receipts/`

### Extra export folder
When enabled, the app also copies generated artifacts to a separate export folder you choose in Settings.

### Session manifest
When MHL/hash output is enabled, Drop Verify writes a session manifest:

- `Drop Verify_Receipts/SESSION_MANIFEST_{folderName}_{timestamp}.json`

The manifest records every verified file with path, size, and xxHash64 hash. On cancellation during a hashing run, it captures which files were verified before the cancel (`"status": "cancelled"`). The JSON uses `filesVerified` / `bytesVerified` keys (distinct from CopyTrust's `filesCopied` / `bytesCopied`).

If MHL is disabled, Drop Verify skips file hashing and does not write a session manifest. The session log records `Manifest skipped - MHL/hash output is disabled.`

## Session Logs

Drop Verify writes per-session log files to:

- the app's Application Support folder
- sandboxed builds use a containerized path such as `~/Library/Containers/com.dropverify.app/Data/Library/Application Support/Drop Verify/logs/{SESSION_TAG}/session_{SESSION_TAG}.log`

Each log captures the full timeline of a run: session start, folder path, scan results, file counts, artifact paths, errors, cancellation, and completion. Use the in-app `Reveal Logs` button to open the current run's log folder when troubleshooting.

If Drop Verify cannot create or write the session log, the run can still finish normally. In that case the app shows a non-fatal warning in the `Run Status` card so logging problems are visible without being confused with artifact-generation failures. The `Reveal Logs` button lives in the `Artifacts` section whenever a log directory is available.

For stuck or ambiguous runs, see [Drop Verify Troubleshooting](DROP_VERIFY_TROUBLESHOOTING.md). It includes the process, child-command, sample, `lsof`, log-tail, and artifact-check commands used to distinguish a still-running job from a stuck optional artifact.

## In-App Help

Use the **Help > Drop Verify Help** menu to open a built-in help sheet covering quick start, artifact descriptions, HTML tree setup, external codec configuration, and output options. The Help menu also includes a link to **code.matx.ca**.

## Notes

- Drop Verify is media-focused and does not generate MHL entries for non-media files.
- Tree-only runs are folder-focused and do not require media files or hashes.
- Hidden files are excluded by default.
- Exclusion checkboxes are operator-controlled; Camera Card patterns are not silently forced on.
- The app is intended for post-copy verification/reporting, not multi-destination ingest.
