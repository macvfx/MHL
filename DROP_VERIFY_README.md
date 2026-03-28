# Drop Verify

Current version: **v2.1.8 (Build 3)**. Stable release: **v2.1.7 (Build 5)**.

`Drop Verify` is a lightweight macOS app target for one-folder trust reporting.

Drop a folder onto the app and it will recursively scan media files, then generate:

- `MHL (Media Hash List)`
- `Contact sheet PDF`
- `EXIF camera metadata CSV`

It is designed as a simpler sibling to `CopyTrust`, for situations where you want trust artifacts and metadata reports without the full multi-destination ingest workflow.

## What It Scans

- Media files only
- Recursive folder scan
- Hidden files excluded by default
- User-configurable exclusion patterns

## Outputs

By default, Drop Verify can write artifacts into the dropped folder inside:

- `Drop Verify_Receipts/`

It can also mirror generated artifacts to a separate export folder if enabled in Settings.

## Settings

Drop Verify includes settings for:

- `MHL (Media Hash List)`
- `Contact sheet PDF (thumbnails and camera data)` — row or grid layout
- `EXIF camera metadata CSV (Spreadsheet)`
- contact sheet layout style (Row or Grid 3×4)
- export generated artifacts to an extra export folder
- exclude hidden files
- manage exclusion patterns
- open locally written artifacts after completion
- operator name

## Documentation

- [Drop Verify User Guide](DROP_VERIFY_USER_GUIDE.md)
- [Project Changelog](CHANGELOG.md)
