# Media Trust Tools 2.6.0 (Build 1)

## Proxy media beta with proof

CopyTrust can now create H.264 or HEVC / H.265 MOV proxies after a verified
copy, at 12.5%, 25%, or 50% of the original frame dimensions.

This is a **beta**. Test with expendable copies before adopting it in a
production ingest workflow. Proxy generation is separate from the trust chain:
the verified original remains authoritative, and a proxy failure never changes
the copy-verification result.

### Final Cut Pro-friendly output

- Optional `Final Cut Proxy Media/YYYY-MM-DD/…/OriginalFileName.mov` layout.
- Exact original basename retained for Final Cut relinking.
- H.264 High or HEVC Main 10.
- Uses CopyTrust's packaged `/usr/local/bin/ffmpeg` and `ffprobe`, not unrelated
  Homebrew or MacPorts installations.

Field testing reconnected both H.264 and HEVC proxies in Final Cut Pro after
their basenames matched the originals.

### Live progress and operator evidence

- UI and active-log updates show clip/total, percentage, speed, and ETA.
- Pre-copy confirmation explicitly shows **Proxy Off** or the selected codec,
  scale, and Final Cut folder choice.
- Every proxy batch writes JSON evidence, a readable TXT summary, and a progress
  LOG comparing original/proxy paths, dimensions, format, frame rate, duration,
  timecode, color metadata, and audio streams.

Automated real encodes cover MOV and MXF. Other formats depend on whether the
packaged ffmpeg can decode their streams; proprietary formats are not promised
by this beta.

## Package-safe receipts

CopyTrust and Drop Verify no longer write receipt folders inside macOS package
directories. When a Final Cut `.fcpbundle` or another recognized package is the
copied/analyzed root, receipts and generated proxy folders are placed beside
the package. Ordinary folders keep the existing internal receipt layout.

## Testing requested

Please test both codecs and multiple scales, long-clip progress, Final Cut
relinking, evidence files, cancellation, artifact retry, and `.fcpbundle`
receipt placement. See `TEST_NOTES_v2.6.0.md` for the complete matrix.
