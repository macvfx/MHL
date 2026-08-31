# Media Trust Tools

Four macOS apps and a CLI tool for media integrity — copy, verify, and prove it.

**Stable:** CopyTrust and Drop Verify 2.5.3, mhl-tool 2.7.7.
**Beta:** CopyTrust, Drop Verify and Folder Copy Compare **2.7.8.4 Build 11** — four fixes a day of
testing found, the worst of them an edit made from Settings emptying a preset's destinations.
Build 10's headline feature is still here: a facility can lock a preset in, pinned by name so the
convention itself can still be redeployed as often as testing needs
([CopyTrust_ManagedPresetDeployment.md](CopyTrust_ManagedPresetDeployment.md)).

Earlier in the 2.7.8 line: a delivery gets one receipts folder holding everything, nothing is
written at the root of a destination drive, and a preset can say which destination archives to P5,
which makes proxies, and which P5 server to use. See [RELEASE_2.7.8.md](RELEASE_2.7.8.md) and
[TEST_NOTES_v2.7.8.md](TEST_NOTES_v2.7.8.md).

> **2.7.8 is a beta.** Test it on media you can afford to lose, and keep a separate, verified
> backup made by something else — Archiware P5 or equivalent. This is free software from GitHub
> and it comes with no guarantees.

All three apps share a version and build from one project. MHL Verify 2.6.0.

What each app does is below. What changed in each version is in
[RELEASE_NOTES.md](RELEASE_NOTES.md).

## CopyTrust

Multi-source, multi-destination copy tool designed for camera card ingest but capable of copying any folders and files. Queue multiple cards, walk away, come back to verified results.

**Copying**

- **One Copy switch, one Start button** — with two or more destinations choose `Simultaneously` (every destination at once) or `In series` (an ordered `A -> B -> C` relay chain), then press `Start`
- **Several cards in one run** — cards copy one at a time with **auto-advance** and per-card subfolder naming; every card in the run is listed with its own progress and status
- **Queued sessions** for walk-away staging across different card and destination setups
- **Relay chains** show `Stop 1`, `Stop 2` in order; a queued leg can be pulled back into the workspace with `Edit` to reorder it
- **Resumable ingest** for cancelled or partial runs, when the saved manifest still matches the same source, destinations, and rendered subfolder
- **Pre-copy review** of the whole job — direct, fan-out, relay, or active-plus-queued — with one card per destination showing its verification, sorting, proxy and P5 choices
- Per-destination preflight (free space, write permissions, reachability), and a safe-to-eject flow after transfer

**Verification and evidence**

- Verification levels: **Quick** existence and size, **Full** post-copy xxHash64, or **Inline** hashing during the copy
- **MHL v1.1** hash lists for Full and Inline — compatible with OffShoot, Silverstack, ShotPut Pro, YoYotta
- MHL import verification — drop any `.mhl` to re-verify destination files; reads classic MHL v1.x **and ASC MHL v2.0**
- Session receipts (JSON + TXT), per-ingest logs, optional export to a separate folder, and relay-chain summaries at session close
- Relay chains write an immutable, password-free workflow plan with ordered step and dependency IDs, exported beside every leg's receipts
- The operator is recorded in every session manifest, defaulting to the macOS account
- Verify panel: Deep Compare Files, Compare Browser, Copy Missing, Retry MHL Export

**Setup**

- Volume browser and **Volume Pool** for fast source and destination setup
- **Destination sets** for one-click restore of saved destination groups
- **Presets** — save every Card and Folder setting under one name and load it back in one action; read-only shared presets deploy to a whole facility via `/Users/Shared/CopyTrust/Presets`
- Built-in Help with `Quick Start`, `Advanced Start`, and `Several Cards at Once`

**After the copy**

- **Contact sheet PDF** (row or grid) and **EXIF metadata CSV**, generated as independent background artifacts — ExifTool for richer metadata, ffmpeg for MXF and MPEG-2 family thumbnails, REDline for R3D. Quick mode never invents hashes or an MHL
- **HTML directory tree** — `Project summary index`, `One HTML per top-level folder`, or `Entire project`, all generated natively
- **Proxy media** — optional H.264 High or HEVC Main 10 MOV at 12.5%, 25%, or 50%, with an optional `Final Cut Proxy Media/YYYY-MM-DD` layout and exact-basename relinking. Display rotation and the source's own colour characteristics carry into the encode, and each run writes JSON/TXT/LOG evidence. Real encode tests cover MOV and MXF; broader formats depend on the packaged ffmpeg decoder
- **Archiware P5 archive (testing)** — after Full or Inline verification, submit a verified destination to a P5 server with searchable xxHash64, frame size and other bounded media metadata. `Archive to P5` and `Create proxies` are chosen per destination, and P5 preflight evaluates a whole relay chain
- **Deferred P5 handoff** — a password-free request JSON preserves paths, hashes, metadata, target hints and job state when P5 is offline or automatic archive is off

Docs: [Why and How](CopyTrust_WhyAndHow.md) ([PDF](CopyTrust_WhyAndHow.pdf)) — the short case for it, a page per topic, [First Run](CopyTrust_FirstRun.md) ([PDF](CopyTrust_FirstRun.pdf)) — one page, fan-out to every destination, [Operator Field Guide](COPYTRUST_OPERATOR_FIELD_GUIDE.md) (short — features + 2-minute field test), [User Guide](CopyTrust_UserGuide.md) (full), [Workflow Guide](CopyTrust_WorkflowGuide.md) (relay strategy), [Illustrated Workflow Guide](CopyTrust_Illustrated_Workflow_Guide.md) ([PDF](CopyTrust_Illustrated_Workflow_Guide.pdf)), [P5 Restore & Verify](CopyTrust_P5_Restore_and_Verify_Workflow.md), [Workflow QA Matrix](COPYTRUST_WORKFLOW_QA_MATRIX.md), and [Quick Start](CopyTrust_QuickStart.md).

The illustrated guide images are stored in
[`assets/copytrust_workflows/`](assets/copytrust_workflows/), so they render
directly on GitHub as well as in a local checkout.


## Drop Verify

- MHL output hashes every included regular file, including camera XML sidecars, databases, support files and thumbnail folders; contact-sheet, metadata CSV and proxy processing remains media-focused
- Active Camera Card exclusions trigger a mandatory pre-run confirmation naming patterns that can omit files or complete folders from the MHL

Single-folder drag-and-drop verification. Drop a folder and generate trust artifacts — no copy, no session, no setup.

- Media-focused recursive scan with configurable exclusion patterns when media artifacts are selected
- Generates selected outputs only: **MHL**, **contact sheet PDF** (row or grid), **EXIF metadata CSV**, and optional native **HTML directory tree/index**
- MHL output is what triggers hashing and session manifest creation; CSV/contact-sheet-only modes can run without hashes, and HTML-tree-only mode skips media analysis entirely
- **Proxy media** — edit-friendly HEVC/H.264 copies with per-clip progress and their own evidence, using the same codecs, sizes and Final Cut layout as CopyTrust. Only verified files get a proxy, and proxies stay beside the media rather than going to the export folder
- Writes artifacts into the folder and/or mirrors them to an export folder
- For package roots such as `.fcpbundle`, writes its `Receipts` folder beside
  the package; ordinary folders retain their existing internal receipt layout.
  Since 2.7.7 that folder is shared with CopyTrust rather than a separate
  `Drop Verify_Receipts`
- Built-in **Help > Drop Verify Help** with setup guides for external codecs, HTML tree, and output options

## MHL Verify

Standalone MHL reader and verifier. Load any `.mhl` file, review it, and verify whether the media files still match.

- **Side-by-side compare** — `Side A` and `Side B` are picked separately, so the two MHL files can live on different volumes; each side shows its volume, file count and total size before you compare
- **A verdict on every comparison** — match, timing-differs-only, different-layout, or differs. A **Destination Sort**ed copy is paired with its pre-sort source by name, size and hash and reported as `Moved`
- **Verify** — re-hashes every file listed in the MHL and reports matched / mismatched / missing with digests
- Reads classic MHL v1.x **and ASC MHL v2.0** (Silverstack 9+ default, incl. `ascmhl/` folder layouts)
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
- Folder selections persist across a mode switch, and cancelling a scan is non-destructive
- Standalone app — no ingest session, no receipts, no artifacts

## mhl-tool (CLI)

Command-line tool for creating MHL v1.1 manifests and verifying both classic MHL v1.x and ASC MHL v2.0 manifests (v2.7.7). Same MHL engine as CopyTrust and Drop Verify, built for the terminal.

- `mhl-tool create <folder>` — hash files and write an MHL manifest **into that folder**, beside the files it describes, where every reader resolves its paths from (`--output` to put it elsewhere)
- `mhl-tool verify <folder>` — verify files against MHL(s); finds the manifest in the folder, and still in a `Receipts`, `*_Receipts` or `ascmhl` subfolder, so manifests from earlier versions keep verifying
- Media-only (default) or `--all-files` mode
- JSON output for scripting, quiet mode for CI
- Reads MHLs from any tool (OffShoot, Silverstack, ShotPut Pro, YoYotta), including ASC MHL v2.0 hashlists — the Silverstack 9+ default
- Signed, notarized `.pkg` installer for distribution

## Keyboard Shortcuts

### Folder Copy Compare
- `⌘K` — Compare Folders
- `⌘R` — Refresh Comparison
- `⌘⇧N` — Reset both folders

## More Documentation

- Drop Verify: [README](DROP_VERIFY_README.md), [User Guide](DROP_VERIFY_USER_GUIDE.md),
  [Troubleshooting](DROP_VERIFY_TROUBLESHOOTING.md), and
  [Drop Verify / MHL Verify Workflow](DROP_VERIFY_AND_MHL_VERIFY_WORKFLOW.md)
- Folder Copy Compare: [README](FOLDER_COPY_COMPARE_README.md) and
  [User Guide](FOLDER_COPY_COMPARE_USER_GUIDE.md)
- Testing and operations: [CopyTrust 2.6 Beta Test Notes](TEST_NOTES_v2.6.0.md)
  and [CopyTrust Sentry Observability](SENTRY_OBSERVABILITY.md)
- Background: [What Is MHL and Why Use It?](WHAT_IS_MHL_AND_WHY_USE_IT.md)
- Release history: [Media Trust Tools Release Notes](RELEASE_NOTES.md) and
  [MHL Verify Changelog](MHL_VERIFY_CHANGELOG.md)
