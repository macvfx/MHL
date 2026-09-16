# Media Trust Tools 2.6.0 (Build 1) — Beta Testing Notes

Date: 2026-07-28
Status: Public prerelease
Apps: CopyTrust, Drop Verify, Folder Copy Compare

## Beta focus

CopyTrust 2.6.0 adds optional post-copy proxy media with explicit operator
settings, live progress, and an evidence bundle. CopyTrust and Drop Verify also
stop writing receipts inside macOS packages such as Final Cut Pro libraries.

Proxy generation is beta. Test on expendable copies before adopting it in a
production ingest policy. The verified original copy remains the trust result;
proxy generation is a separate, retryable derivative stage.

## Supported proxy choices

- H.264 High in MOV.
- HEVC / H.265 Main 10 in MOV.
- 12.5%, 25%, or 50% of both original frame dimensions.
- Optional `Final Cut Proxy Media/YYYY-MM-DD/…/OriginalFileName.mov` layout.
- Fixed packaged tools: `/usr/local/bin/ffmpeg` and `/usr/local/bin/ffprobe`.

Real automated encodes cover MOV and MXF sources. Other standard media should
work when the packaged ffmpeg build can decode the streams. Do not assume that
extension recognition proves decoder support: proprietary R3D/BRAW and unusual
camera codecs may fail cleanly and remain retryable.

## Operator test matrix

| Test | Expected result |
|---|---|
| Pre-copy confirmation, proxy disabled | Dedicated `Proxy: Off` line |
| H.264, 50% | Confirmation/log state H.264 50%; output dimensions are half each source dimension |
| HEVC, 25% | Confirmation/log state HEVC 25%; output is Main 10 at quarter dimensions |
| Long clip | UI and active log update roughly every five seconds with clip/total, percent, speed, and ETA |
| Final Cut layout | Dated folder and exact original basename with `.mov` |
| FCP relink | Proxy reconnects after using the original basename |
| Proxy evidence | Matching JSON, TXT, and LOG under `CopyTrust_Receipts/Proxy Media` |
| Delete one evidence file and retry missing artifacts | Proxy evidence is regenerated |
| Copy an `.fcpbundle` in Folder mode | `CopyTrust_Receipts` and proxy folders are siblings of the package, never children |
| Drop Verify an `.fcpbundle` | `Drop Verify_Receipts` is beside the package |
| Ordinary folder | Receipt folder remains inside the ordinary folder |
| Cancel during encode | Encoder terminates and no `.partial.mov` remains |

## Evidence review

The TXT summary should identify the operator choice, original path, proxy path,
and PASS/FAIL/N/A results. The JSON contains the full structured ffprobe
snapshots. The LOG contains timestamped encode and percentage heartbeats.

CopyTrust validates only fields it can meaningfully compare. Codec, profile,
pixel format, bitrate, and dimensions are intentional derivative changes.
Missing original metadata is N/A, not a fabricated pass.

## Known beta boundaries

- Software x264/x265 encoding can be slower than real time.
- Percentage and ETA require a usable source duration.
- Decoder availability depends on the CopyTrust-packaged ffmpeg build.
- Proxy generation does not create Final Cut events or automatically attach
  proxies to a library; it creates relinkable media for later placement.
- Proxy success or failure never upgrades or downgrades the original copy's
  verification result.
