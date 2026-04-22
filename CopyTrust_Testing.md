# CopyTrust Testing Guide

Active testing version: **v2.2 (Build 8)** 

Current CopyTrust focus:
- accurate card detection in UI
- Queue sessions: load up and walk away workflow
- Destination of copy #1 can be source for copy #2 (aka relay-chain)
- relay-chain copy workflow with ordered destinations and
- real-world resumable CopyTrust ingests, cancel, adjust and restart
- external-codec previews, richer metadata, and trust-first background artifacts

## External Codec Test Setup

For the active `v2.2 (Build 8)` testing:

- Enable `ExifTool metadata extraction` if you want richer metadata for unsupported/professional formats (Note: requires exiftool installed).
- Enable `External thumbnail codecs` only if you want real preview thumbnails for formats the built-in AVFoundation path cannot decode. (Note: requires ffmpeg or RedCineX (aka redline) installed).
- Typical tested setup:
  - `ExifTool` for MXF, R3D, MPEG-2 family, and sparse-video metadata
  - `ffmpeg` for MXF, `m2v`, `m2t`, `m2ts`, and `vob` contact-sheet thumbnails
  - `REDline` for R3D contact-sheet thumbnails
- Typical operator flow in Settings:
  - open `Settings > External Codecs`
  - enable `ExifTool metadata extraction`
  - use `Auto-Detect` or `Browse…` to select `exiftool`
  - enable `External thumbnail codecs`
  - use `Auto-Detect` or `Browse…` to select `ffmpeg` and/or `REDline`
  - leave other tools off unless you are explicitly testing them

Current tested expectations on this branch:
- MXF: ExifTool metadata + ffmpeg thumbnails
- MPEG-2 family (`m2v`, `m2t`, `m2ts`, `vob`): ExifTool metadata + ffmpeg thumbnails
- R3D: ExifTool metadata + REDline thumbnails
- WMV and other sparse/no-preview formats: better metadata and clearer no-preview reasons even when no thumbnail is created
- Stable `v2.1.8 Build 14`: ExifTool metadata only, unsupported-format placeholders still expected
