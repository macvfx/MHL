# Drop Verify User Guide

Current release: **v2.3 (Build 5)**.

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
- ffmpeg provides MXF thumbnails when enabled and valid.
- REDline provides R3D thumbnails when enabled and valid.
- If ffmpeg or REDline fails, Drop Verify falls back to the placeholder behavior and logs the attempt.

## What Drop Verify Does

Drop Verify is a one-folder analysis tool.

You drag a folder into the app, and it generates three artifact types for media files found inside that folder:

- `MHL (Media Hash List)`
- `Contact sheet PDF`
- `EXIF camera metadata CSV`

## Basic Workflow

### 1. Open Drop Verify
- Launch the `Drop Verify` app target.

### 2. Review settings
- Open `Drop Verify > Settings…`
- Choose which artifacts should be written in the dropped folder:
  - `MHL (Media Hash List)`
  - `Contact sheet PDF (thumbnails and camera data)`
  - `EXIF camera metadata CSV (Spreadsheet)`
- Choose **Contact sheet layout**: Row (detailed metadata) or Grid (3×4 poster, 12 items per page).
- Optionally enable **Hide unsupported format placeholders** to omit files that cannot generate thumbnails (MXF, R3D, M2V, etc.) from the contact sheet PDF. These files still appear in the EXIF CSV and MHL.
- Optionally enable **ExifTool metadata extraction** and **external thumbnail codecs** for MXF and R3D (see External Codec Setup above).
- Optionally enable export to an extra export folder.
- Leave `Exclude hidden files` enabled unless you explicitly need hidden content scanned.

### 3. Drop a folder
- Drag one folder onto the main Drop Verify window.
- Or click `Choose Folder`.

Drop Verify scans recursively and only includes media files.

### 4. Wait for artifact generation
The app runs through these stages:

- scan media files
- hash files for MHL generation
- extract image/video metadata
- write CSV
- render contact sheet PDF
- write/export artifacts

Use the **Cancel** button in the header bar to stop at any time without quitting the app. On cancel, a partial session manifest is saved recording which files were verified before the cancellation. A **Reveal Manifest** button appears in the status card to open it.

**Read-only media:** If the dropped folder is on read-only media (locked SD card, encrypted drive, write-protected volume), Drop Verify detects this before scanning and prompts you to choose an export folder. If an export folder is already configured in Settings, artifacts are written there automatically — the export folder is revealed in Finder when done, and artifact rows show an "Exported" badge with clickable links to the exported files.

### 5. Review artifacts
If local output is enabled, artifacts are written into:

- `Drop Verify_Receipts/`

You can open individual artifacts from the app after generation.

## What Each Artifact Is For

### MHL (Media Hash List)
- Industry-standard manifest of file hashes
- Useful for later verification and handoff records

### Contact sheet PDF
- Quick visual summary of media found in the dropped folder
- Includes thumbnails and camera/media metadata
- Two layout styles: **Row** (one clip per row with detailed metadata) or **Grid** (3×4 poster, 12 items per page with single thumbnail + caption per item)
- In the stable release, professional and legacy formats (MXF, R3D, BRAW, ARRIRAW, CinemaDNG, M2V, M2T, M2TS, VOB) appear with "No Preview" placeholders and the file type name unless hidden.
- When external codecs are configured, MXF can show real ffmpeg thumbnails and R3D can show real REDline thumbnails while still using ExifTool-backed metadata.
- Recent Build 2 polish: REDline validation now better recognizes working installs, R3D contact-sheet thumbnails render at a more practical size, and crowded unsupported-format metadata blocks are trimmed back in the PDF.
- Header shows a summary when files could not be previewed (e.g. "2 files without preview (MXF: 1, R3D: 1)")
- Footer shows "Drop Verify" branding (CopyTrust contact sheets show "CopyTrust")

### EXIF camera metadata CSV
- Spreadsheet-friendly export of file path and metadata fields
- Intended for reporting, sorting, and review in Numbers, Excel, or Google Sheets
- When ExifTool is configured, CSV output also includes richer ExifTool-backed fields such as start timecode, audio sample rate, audio bit depth, and firmware/application version where available for MXF and R3D
- The active Build 2 branch can also populate fields such as `VideoFormat`, `ReelNumber`, `CameraSerialNumber`, `StorageModel`, and `StorageSerialNumber` where ExifTool provides them.

## Exclusions

Drop Verify excludes:

- hidden files by default
- generated receipt/artifact folders
- any custom patterns enabled in Drop Verify Settings

Use the `Exclusions` tab in Settings to add or remove patterns.

## Output Locations

### Write in dropped folder
When enabled, Drop Verify writes selected outputs into the dropped folder under:

- `Drop Verify_Receipts/`

### Extra export folder
When enabled, the app also copies generated artifacts to a separate export folder you choose in Settings.

### Session manifest
After every run (including cancelled ones), Drop Verify writes a session manifest:

- `Drop Verify_Receipts/SESSION_MANIFEST_{folderName}_{timestamp}.json`

The manifest records every verified file with path, size, and xxHash64 hash. On cancellation, it captures which files were verified before the cancel (`"status": "cancelled"`). The JSON uses `filesVerified` / `bytesVerified` keys (distinct from CopyTrust's `filesCopied` / `bytesCopied`).

## Session Logs

Drop Verify writes per-session log files to:

- the app's Application Support folder
- sandboxed builds use a containerized path such as `~/Library/Containers/com.dropverify.app/Data/Library/Application Support/Drop Verify/logs/{SESSION_TAG}/session_{SESSION_TAG}.log`

Each log captures the full timeline of a run: session start, folder path, scan results, file counts, artifact paths, errors, cancellation, and completion. Use the in-app `Reveal Logs` button to open the current run's log folder when troubleshooting.

If Drop Verify cannot create or write the session log, the run can still finish normally. In that case the app shows a non-fatal warning in the `Run Status` card so logging problems are visible without being confused with artifact-generation failures. The `Reveal Logs` button lives in the `Artifacts` section whenever a log directory is available.

## Notes

- Drop Verify is media-focused and does not generate MHL entries for non-media files.
- Hidden files are excluded by default.
- The app is intended for post-copy verification/reporting, not multi-destination ingest.
