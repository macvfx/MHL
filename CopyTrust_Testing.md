# CopyTrust Testing Guide

Active testing version: **2.5.2** — 2.5.1 is the current stable release.

## 2.5.2 testing focus (sorted-copy MHL verify fix)

The headline fix: when **Destination Sort** is enabled, verification could report every file as missing on an otherwise perfect copy ("0 matched", "MHL file not found"), because the copy-time MHL described the pre-sort layout. What to test:

- Run a **sorted** card ingest, then use **Verify Using MHL** / **Re-Verify Destinations** — verification should pass against the sorted layout.
- Confirm the destination root holds a single delivery MHL, with the original source MHL preserved under `CopyTrust_Receipts/… - Source.mhl`, and a `PROVENANCE_*.json` record alongside the receipts.
- Simulate an **unreliable network destination**: let the destination drop and reconnect mid-pipeline — the sort must not re-run (no `…_2` renamed files).
- Confirm **plain (unsorted) copies** are unchanged — the single copy-time MHL at the destination root verifies as before.
- Cover the common workflows: a→b, a→b+c (fan-out), a→b→c (relay), each with destination alias and sort.

Earlier focus areas (still valid):

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
