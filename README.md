# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

**Stable version: 2.5.1** — ASC MHL v2.0 (Silverstack 9+) support across the suite and a new Verify action in MHL Verify. **CopyTrust 2.5.3 is in testing** — it includes the sorted-copy MHL verification fix, per-copy provenance records, and safer HTML tree/index output. **Drop Verify 2.5.2 is in testing** for safer HTML tree/index modes and exact output-toggle behavior. One-line history in [RELEASE_NOTES.md](RELEASE_NOTES.md); detailed changes in each app's docs.

## CopyTrust

Multi-source, multi-destination copy tool designed for camera card ingest but capable of copying any folders and files. Queue multiple cards, walk away, come back to verified results.

- Volume browser and **Volume Pool** for fast source/destination setup
- Destination preset groups for one-click restore of saved destination sets
- Per-destination preflight checks (free space, write permissions, reachability)
- Post-copy verification with xxHash64 (None / Quick / Full)
- **MHL v1.1** hash list generation — compatible with OffShoot, Silverstack, ShotPut Pro, YoYotta
- MHL import verification — drag-and-drop any `.mhl` to re-verify destination files; reads classic MHL v1.x **and ASC MHL v2.0** (Silverstack 9+, OffShoot, YoYotta, ShotPut Pro) as of v2.5.1
- **Auto-advance** multi-source copy with per-card subfolder naming
- **Queued sessions** for walk-away ingest staging across different card/destination setups
- **Relay-chain copy** for `A -> B -> C` workflows using one source plus ordered destinations and `Queue Relay Chain`
- Destination relay-order staging with visible `Stop 1`, `Stop 2`; queued relay legs can be pulled back into the workspace with `Edit` for reordering
- **Resumable CopyTrust ingest** for cancelled same-source/same-destination runs and failed partial runs when the saved manifest still matches the same source, destinations, and rendered subfolder
- **Contact sheet PDF** (row or grid layout) and **EXIF metadata CSV** after each ingest — professional formats (MXF, R3D, BRAW, ARRIRAW, M2V, VOB) show placeholders in the stable release, while this branch uses ExifTool for richer metadata, ffmpeg for MXF and MPEG-2 family thumbnails, and REDline for R3D thumbnails. PDF/CSV run as independent background artifacts after trust-critical copy + verify + MHL completion.
- Optional **HTML directory tree** artifact after copy + verify; enable in Settings > Post-Copy with `Project summary index`, `One HTML per top-level folder`, or `Entire project`, all generated natively
- Session receipts (JSON + TXT), per-ingest logs, and optional export to a separate folder, including overall relay-chain summaries at session close
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export
- Safe-to-eject flow after successful transfer
- Built-in Help flow with `Quick Start`, `Advanced Start`, and a Help menu entry to reopen CopyTrust guidance
- Asynchronous contact-sheet auto-open and richer verify-start / verify-abort diagnostics for easier troubleshooting

Docs: [Operator Field Guide](COPYTRUST_OPERATOR_FIELD_GUIDE.md) (short — features + 2-minute field test), [User Guide](CopyTrust_UserGuide.md) (full), [Workflow Guide](CopyTrust_WorkflowGuide.md) (relay strategy), [Quick Start](CopyTrust_QuickStart.md).


## Drop Verify

Single-folder drag-and-drop verification. Drop a folder and generate trust artifacts — no copy, no session, no setup.

- Media-focused recursive scan with configurable exclusion patterns when media artifacts are selected
- Generates selected outputs only: **MHL**, **contact sheet PDF** (row or grid), **EXIF metadata CSV**, and optional native **HTML directory tree/index**
- MHL output is what triggers hashing and session manifest creation; CSV/contact-sheet-only modes can run without hashes, and HTML-tree-only mode skips media analysis entirely
- Writes artifacts into the folder and/or mirrors them to an export folder
- Built-in **Help > Drop Verify Help** with setup guides for external codecs, HTML tree, and output options

## MHL Verify

Standalone MHL reader and verifier. Load any `.mhl` file, review it, and verify whether the media files still match.

- **Verify** action (new in 2.5.1): re-hashes every file listed in the MHL and reports matched / mismatched / missing with digests
- Reads classic MHL v1.x **and ASC MHL v2.0** (Silverstack 9+ default, incl. `ascmhl/` folder layouts) — fixes [#1](https://github.com/macvfx/MHL/issues/1)
- Re-check copies, archive restores, and handoff deliveries
- Works with MHLs from Drop Verify, CopyTrust, OffShoot, Silverstack, YoYotta, ShotPut Pro, or any MHL-capable tool
- Requires macOS 14+ as of 2.5.1 (2.4.1 remains for macOS 13, but cannot read ASC MHL v2.0)

See [MHL_VERIFY_README.md](MHL_VERIFY_README.md), [MHL_VERIFY_USER_GUIDE.md](MHL_VERIFY_USER_GUIDE.md), and [MHL_VERIFY_CHANGELOG.md](MHL_VERIFY_CHANGELOG.md).

## Folder Copy Compare

The original tool that started the suite — a simple "did the copy work?" sanity check. Drop two folders and get an honest answer.

Use after copying with CopyTrust, Archiware P5 Sync, a Finder copy, `rsync`, Hedge, ShotPut Pro, or any other tool.

- **Compare mode** — Quick Scan (name, size, date) or Full Scan (xxHash64 / SHA-256 content hashing); per-file comparison: missing, extra, different, identical; **Copy All Missing** to sync differences, then **Refresh** to re-verify; MHL v1.1 generation and verification (reads MHL v1.x and ASC MHL v2.0 as of v2.5.1) from either compared folder
- **Subfolder Check mode** — fast structural sanity check: aligns immediate subfolders side-by-side with file counts, total sizes, and Archiware P5 stub file detection (`.p5a` / `.p5c`); colour-coded match indicators (exact / close / different / one-side-only); click any matched row to drill down using the active Quick / Full Scan setting
- **Date Only** quick-scan status plus per-file **Hash Check** for same-size, different-date pairs without forcing a full rescan
- Folder selections persist across Compare / Subfolder Check mode switches; scan cancel is non-destructive; stub cleanup now shows progress and hides `Clean` on the `_P5 Stub Cleanup` folder
- Standalone app — no ingest session, no receipts, no artifacts

## mhl-tool (CLI)

Command-line tool for creating MHL v1.1 manifests and verifying both classic MHL v1.x and ASC MHL v2.0 manifests (v2.5.1). Same MHL engine as CopyTrust and Drop Verify, built for the terminal.

- `mhl-tool create <folder>` — hash files and write an MHL manifest
- `mhl-tool verify <folder>` — verify files against MHL(s), auto-discovers `_Receipts` and `ascmhl` folders
- Media-only (default) or `--all-files` mode
- JSON output for scripting, quiet mode for CI
- Reads MHLs from any tool (OffShoot, Silverstack, ShotPut Pro, YoYotta), including ASC MHL v2.0 hashlists — the Silverstack 9+ default
- Signed, notarized `.pkg` installer for distribution

## Keyboard Shortcuts

### Folder Copy Compare
- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders
