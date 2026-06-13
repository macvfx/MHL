# CopyTrust Testing Guide

Active testing version: **2.5.2** — 2.5.1 is the current stable release.

## New in 2.5.2 — features to test

The headline fix is MHL verification on **sorted** copies: when Destination Sort is on, verification used to report every file as missing ("0 matched", "MHL file not found") because the copy-time MHL described the pre-sort layout.

1. **Sorted-copy verification** — run a sorted card ingest, then **Verify Using MHL** and **Re-Verify Destinations**; both should pass against the sorted layout (not "0 matched / all missing").
2. **Delivery MHL + archived source MHL** — the destination root holds exactly one `.mhl` (the sorted delivery MHL); the original source MHL is preserved at `CopyTrust_Receipts/… - Source.mhl`.
3. **Review Summary "Verify"** — open Review Summary after a sorted copy and click Verify on the listed MHL; it should resolve and pass (not "MHL file not found").
4. **Retry MHL Export** after a sorted copy — regenerates the sorted MHL; re-verify passes.
5. **Provenance record** — `CopyTrust_Receipts/PROVENANCE_<source>_<timestamp>.json` exists, listing the settings used (naming, sort categories, folder mode) and a per-file source→destination mapping (identity for a plain copy).
6. **Reconnect during a sorted copy** (unreliable network destination) — let the destination drop and reconnect mid-pipeline; the sort must **not** re-run — no `…_2` renamed files, no duplicate `- Source.mhl`.
7. **Multi-destination (a→b+c) sorted** — each destination independently gets its own verifiable sorted MHL, archived source MHL, and provenance.

## Regression checklist — existing features that must not break

The 2.5.2 changes are app-layer and scoped to the sort / MHL / receipt path; CopyCore is unchanged. Confirm the common, non-sorted flows still behave exactly as in 2.5.1:

**Copy + verify**
- Plain (unsorted) copy a→b — the single copy-time MHL at the destination root verifies.
- Fan-out a→b+c and relay a→b→c **without** sort — each leg copies and verifies; the relay intermediate behaves as before.
- Inline / Quick / Full verification levels.
- Resumable ingest — cancel, adjust, restart a same-source/same-destination run; verified files are reused, not recopied.

**Naming & layout**
- Subfolder alias naming (`{alias}_{date}`, custom prefixes) and Preserve Original Folder Names.
- File-prefix (copy-time) renaming — files copy and verify under the renamed names. *(Known 2.5.2 limitation: provenance records the renamed path as the source; copy/verify itself is unaffected.)*
- Destination Sort produces the expected type folders for the configured categories.

**MHL & verify tools**
- MHL v1.1 generation; ASC MHL v2.0 read/verify (Silverstack 9+, OffShoot, YoYotta, ShotPut Pro).
- Drag-and-drop external `.mhl` verification.
- Deep Compare Files, Compare Browser, Copy Missing.
- Unreadable-MHL recovery flow (Rename Bad MHL → Re-Verify).

**Workflow & UI**
- Queue sessions / walk-away staging; Auto-advance multi-source.
- Volume browser / Volume Pool; destination preset groups; per-destination preflight checks.
- Card vs Folder presets keep independent settings; exclusions per mode.
- Contact sheet PDF, EXIF CSV, and HTML tree artifacts generate after copy + verify + MHL — and a reconnect still completes the unfinished artifacts.
- Session receipts (JSON + TXT), per-ingest logs, optional export folder.
- Safe-to-eject flow; Session Health Report verdicts.

Earlier focus areas (still valid): accurate card detection; queue/walk-away; relay-chain; resumable ingests; external-codec previews and richer metadata.

## External Codec Test Setup

For 2.5.2 testing:

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
