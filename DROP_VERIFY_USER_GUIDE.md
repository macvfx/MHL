# Drop Verify User Guide

Tested version: **v2.1.8 (Build 6)**. Stable release: **v2.1.7 (Build 5)**.

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

### EXIF camera metadata CSV
- Spreadsheet-friendly export of file path and metadata fields
- Intended for reporting, sorting, and review in Numbers, Excel, or Google Sheets

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

## Notes

- Drop Verify is media-focused and does not generate MHL entries for non-media files.
- Hidden files are excluded by default.
- The app is intended for post-copy verification/reporting, not multi-destination ingest.
