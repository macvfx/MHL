# Media Trust Tools

This project now centers on three related macOS tools:

- **MHL Verify**: load an existing MHL and verify whether media files still match it.
- **Drop Verify**: drag one folder in and generate a media MHL, contact sheet PDF, and EXIF metadata CSV.
- **CopyTrust**: offload one or more camera cards/folders to multiple destinations with receipts and MHL support.

Current release: **v2.1.2 (build 1)**.

## Tools

### MHL Verify
- Verify any existing `.mhl` file against a media set
- Useful for re-checking copies, archive restores, and handoff deliveries
- Works alongside MHLs created by Drop Verify, CopyTrust, and other MHL-capable tools

### Drop Verify
- Single-folder drag-and-drop workflow
- Media-only recursive scan
- Hidden files excluded by default
- Configurable exclusion patterns
- Generates:
  - `MHL (Media Hash List)`
  - `Contact sheet PDF`
  - `EXIF camera metadata CSV`
- Can write artifacts into the dropped folder and/or mirror them to an extra export folder
- Uses `Drop Verify_Receipts/` for local output packaging

### CopyTrust
- Source card detection (`DCIM`, camera folder signatures, volume-name hints)
- Volume browser for discovering mounted external drives, camera cards, SMB/NFS/AFP network shares, and FUSE volumes (e.g. LucidLink)
- CopyTrust-only **Volume Pool** setup area for fast pre-copy staging:
  - camera cards, drives, and network volumes in one grid
  - quick add buttons and drag-drop into Sources/Destinations
  - hidden after first copy starts
- Source volumes auto-hidden from the destination picker (can't offload to the same card)
- Finder folder pickers used by **Add Source** and **Add Destination** now allow creating a new folder directly from the picker when needed
- Multiple destinations per ingest
- Destination preset groups (save/load/rename/delete) for one-click destination set restore
- Preflight checks per destination:
  - free space
  - write permissions
  - reachability (network volumes)
- Per-destination progress with four-phase tracking (scanning → copying → verifying → complete)
- Re-openable copy progress window during active copy:
  - opens automatically when copy starts
  - **Close** hides it without stopping copy
  - **Open Progress** restores it from the main action bar
- Main action bar **Cancel Copy** control during active copy
- Activity Log auto-expands when copy starts, remains user-collapsible, and supports inline height resize
- Main action bar live speed badge after **Auto**:
  - fixed-width `speedometer` chip
  - shows aggregate throughput across all active destinations
- Subfolder naming token `{increment}` for multi-card incremental folder names (`{card_index}` still supported for older templates)
- Post-copy verification with xxHash64 (None / Quick / Full)
- MHL v1.1 hash list generation (compatible with OffShoot, Silverstack, ShotPut Pro, YoYotta)
- MHL import verification — drag-and-drop any `.mhl` file to re-verify destination files
- Verify panel actions for operational recovery:
  - **Retry MHL Export** (without recopy)
  - **Deep Compare Files** (verified-file, path-agnostic integrity compare across all copied source/destination pairs)
  - **Open Compare Browser** (full source-vs-destination file table)
  - **Copy Missing** (repair missing copied files directly from the compare browser, then re-run file checks)
- Failed/unreadable MHL handling in the Verify panel:
  - explicit failed file list with path + reason
  - **Reveal** / **Reveal All**
  - **Copy Paths**
  - **Rename Bad MHL** (renames unreadable manifests so they are no longer scanned)
- Inline **Bad MHL Recovery** checklist plus first-detection alert with the recommended order:
  - **Deep Compare Files**
  - **Rename Bad MHL**
  - **Re-Verify Destinations**
- `Retry MHL Export` writes a fresh timestamped MHL filename, so regenerated manifests are clearly newer than archived/stale ones
- Direct **Reset Session** action-bar button, disabled until a copy session has started
- Ghost placeholder slots hinting multi-source and multi-destination support
- Non-destructive **Review & Verify** flow while work remains, then a clear **End & Keep Destinations…** primary action when the ingest queue is complete
- **Auto-advance** multi-source copy — queue cards and walk away; next source starts automatically using its generated per-card subfolder
- **Contact sheet PDF** generated after each ingest — dark-themed, one clip per row with rich metadata (codec, FPS, frame count, resolution, bitrate, audio channels) and thumbnail frames (configurable in CopyTrust Settings → `Post-Copy`)
- Optional **Open contact sheet automatically after creation** setting in CopyTrust Settings → `Post-Copy`
- CopyTrust Settings now includes dedicated tabs for `Card Copy`, `Camera Card Exclusions`, and `Post-Copy`
- Per-ingest trust artifacts:
  - `JSON` receipt
  - `TXT` receipt
  - per-ingest `LOG`
  - contact sheet PDF (when enabled)
- Session-close receipt (`JSON` + `TXT`) with aggregated verification metadata
- Session Summary now includes both per-source totals and aggregated per-destination totals
- First-run and anytime **Help** workflow:
  - `First Steps & Recovery` sheet opens once for onboarding
  - `Help > CopyTrust Help` reopens it at any time
  - includes copy-failure and MHL-recovery step-by-step guidance
- Safe-to-eject flow after successful transfer

## Logs and Receipts

### Card mode runtime log
- Sandboxed app location (default):
  - `~/Library/Containers/com.copytrust.app/Data/Library/Application Support/CopyTrust/logs/<SESSION>/session_<SESSION>.log`
- App menu shortcut: **Help → Reveal Session Log**
- Log file is now scoped to the active ingest session, not one shared rolling file.

### Session receipts
- Destination copy: `<destination>/CopyTrust_Receipts/`
- Local app copy: `~/Library/Application Support/CopyTrust/receipts/`
- Each ingest action now writes its own named receipt set in `CopyTrust_Receipts/`.
- Ending the session still writes the aggregate session-close receipt.

### Contact sheet PDF (Card mode, when enabled)
- Written to: `<destination>/CopyTrust_Receipts/contactsheet_{sourceAlias}_{date}.pdf`
- Dark-themed US Letter PDF, one clip per row: metadata left, thumbnail frames right
- Videos: 3 frames + file type, frame count, duration, resolution, aspect ratio, codec, bitrate, FPS, audio channels
- Photos: single thumbnail + camera make/model, lens, exposure, ISO, resolution
- Header: source alias title, operator, date, session ID, source/destination paths, camera summary, and a summary line (total clips, frames, duration, file size)
- Useful as a quick visual check of the transferred media after copy and verification; integrity proof still comes from verification, receipts, and MHLs
- Supports RAW (CR3, ARW, NEF), HEIF/HEIC, JPEG, and all common video formats natively
- Best-effort: failure does not block receipts or MHL generation

### CopyTrust Settings
- `Card Copy`
  - operator name
  - subfolder naming template (`{increment}` and legacy `{card_index}`)
  - auto-advance and auto-eject behavior
  - verification level
- `Camera Card Exclusions`
  - enable/disable default camera-card exclusion patterns
  - add or remove custom camera-card patterns
- `Post-Copy`
  - generate contact sheet PDF
  - open contact sheet automatically after creation
  - export session receipts, per-copy logs, MHL files, and contact sheets to a separate chosen folder

### CopyTrust Menus
- `CopyTrust > Settings…` opens the dedicated CopyTrust settings sheet
- `Help > CopyTrust Help` opens the operator help / first-steps guide
- `Help > Reveal Session Log` opens the active session log in Finder
- `Help > Reveal Export Folder` opens the configured export folder when one is set
- `About CopyTrust` includes the `code.matx.ca` link

### MHL hash lists (Card mode, Full verification)
- Written to the destination root alongside copied files
- Filename: `CopyTrust - {date} at {time} - {sourceName}.mhl`
- Industry-standard MHL v1.1 XML with xxHash64 digests
- Re-importable: drag an MHL onto the Post-Copy Verification section to re-check destination files at any time
- If an MHL becomes unreadable, CopyTrust can now list it and archive it in place as `.mhl.unreadable*` so future re-verify runs ignore it
- Archiving uses the destination folder's existing access grant, so the rename works without requiring a separate manual cleanup step


## Keyboard Shortcuts

- Toggle mode: `⌘⇧C`
- Compare folders (Folder mode): `⌘K`
- Refresh comparison (Folder mode): `⌘R`
- Reset folders (Folder mode): `⌘⇧N`

## Disclaimer

This software is provided as-is, without warranty of any kind, express or implied. Use at your own risk. No guarantee is made regarding correctness, completeness, fitness for a particular purpose, or suitability for critical data-handling workflows. Always independently verify copies, checksums, manifests, and archival results before relying on them. The author is not responsible for data loss, corruption, downtime, or other damages arising from use of this software.

