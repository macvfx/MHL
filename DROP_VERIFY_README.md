# Drop Verify

Current release: **v2.3 (Build 5)**.

`Drop Verify` is a lightweight macOS app target for one-folder trust reporting.

Drop a folder onto the app and it will recursively scan media files, then generate:

- `MHL (Media Hash List)`
- `Contact sheet PDF`
- `EXIF camera metadata CSV`

It is designed as a simpler sibling to `CopyTrust`, for situations where you want trust artifacts and metadata reports without the full multi-destination ingest workflow.

Drop Verify can also use:
- `ExifTool` for richer unsupported and sparse-video metadata
- `ffmpeg` for real MXF and MPEG-2 family contact-sheet thumbnails
- `REDline` for real R3D contact-sheet thumbnails

## External Codec Setup

Recommended operator setup:

- Open `Drop Verify > Settings… > External Codecs`
- Enable `ExifTool metadata extraction`
- Use `Auto-Detect` or `Browse…` to select `exiftool`
- Enable `External thumbnail codecs`
- Enable `MXF`, `M2V`, `M2T`, `M2TS`, `VOB`, and/or `R3D`
- Use:
  - `ffmpeg` for MXF and MPEG-2 family thumbnails
  - `REDline` for R3D thumbnails

Current expected results:
- `MXF` = ExifTool metadata + ffmpeg thumbnails
- `M2V`, `M2T`, `M2TS`, `VOB` = ExifTool metadata + ffmpeg thumbnails
- `R3D` = ExifTool metadata + REDline thumbnails
- `WMV` and similar sparse/no-preview formats = better metadata, full filename display, and clearer no-preview reasons
- if an external thumbnail tool fails, Drop Verify falls back to placeholders and logs the attempt

## What It Scans

- Media files only
- Recursive folder scan
- Hidden files excluded by default
- User-configurable exclusion patterns

## Outputs

By default, Drop Verify writes artifacts into the dropped folder inside:

- `Drop Verify_Receipts/`

It can also mirror generated artifacts to a separate export folder if enabled in Settings.

**Read-only media:** If the dropped folder is on read-only media (e.g. a locked SD card, encrypted external drive, or write-protected volume), Drop Verify detects this automatically and prompts you to choose an export folder. If an export folder is already configured, artifacts are written there without prompting.

## Settings

Drop Verify includes settings for:

- `MHL (Media Hash List)`
- `Contact sheet PDF (thumbnails and camera data)` — row or grid layout
- `EXIF camera metadata CSV (Spreadsheet)`
- `ExifTool metadata extraction` for unsupported/professional formats and sparse video formats such as MXF, R3D, MPEG-2 family files, and WMV
- `External thumbnail codecs` (currently branch-tested for MXF and MPEG-2 family via ffmpeg and R3D via REDline)
- contact sheet layout style (Row or Grid 3×4)
- hide unsupported format placeholders from contact sheet (MXF, R3D, M2V, etc. omitted from PDF; still in CSV and MHL)
- export generated artifacts to an extra export folder
- exclude hidden files
- manage exclusion patterns
- open locally written artifacts after completion
- operator name

## Session Logs

Drop Verify writes per-session logs to:

- the app's Application Support folder
- sandboxed builds use a containerized path such as `~/Library/Containers/com.dropverify.app/Data/Library/Application Support/Drop Verify/logs/{SESSION_TAG}/session_{SESSION_TAG}.log`

Logs capture the full timeline: folder path, scan results, file counts, artifact URLs, errors, and completion status. Use the in-app `Reveal Logs` button to open the current run's log folder.

If the app cannot create or write the session log, Drop Verify now shows a non-fatal warning in the `Run Status` card instead of failing the whole run. The `Reveal Logs` button appears in the `Artifacts` area whenever a log directory is available.

## What's New in v2.3 (Build 5)

- **Hash-prefetch pipeline**: The file analysis loop now kicks off the next file's hash before EXIF extraction begins on the current file, keeping card I/O continuously busy. Eliminates the per-file idle gap between hashing and metadata extraction. File ordering and progress reporting are fully preserved; cancellation explicitly stops the prefetch task.
- **FileIntegrityHasher buffer 1 MB**: SHA-256, SHA-1, and MD5 read buffer increased from 256 KB to 1 MB, matching the xxHash64 pipeline. Reduces syscall count by ~4× for SHA-based integrity checks.

## External Codec Status

On `v2.3 (Build 5)`:

- MXF metadata is populated through ExifTool when enabled
- MXF contact sheets use ffmpeg for real thumbnails when enabled
- `m2v`, `m2t`, `m2ts`, and `vob` contact sheets use ffmpeg for real thumbnails when enabled
- R3D metadata is populated through ExifTool when enabled
- R3D contact sheets use REDline for real thumbnails when enabled
- sparse/no-preview formats such as `wmv` can still show better metadata through ExifTool fallback
- Drop Verify shows live preview progress during longer external-codec runs
- Drop Verify session logs now include more detailed per-file preview-step logging
- generated MHL files now preserve source folder name and full source path in the top info block
- generated MHL files no longer hash pre-existing `.mhl` receipts as media entries
- If ffmpeg fails, Drop Verify falls back to the existing placeholder behavior and logs the attempt details
- If REDline fails, Drop Verify falls back to the existing placeholder behavior and logs the attempt details
- Build 5 reliability work serializes unsupported-media preview generation to reduce small-batch `R3D` stalls
- When external codec tools are not installed, Drop Verify falls back to placeholder-only previews for unsupported formats

## Documentation

- [Drop Verify User Guide](DROP_VERIFY_USER_GUIDE.md)
- [Project Changelog](CHANGELOG.md)
