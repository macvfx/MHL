# User Guide

Tested version: **v2.1.5 (build 1)**.

This guide covers the **CopyTrust** app — a multi-source, multi-destination copy tool designed for camera card ingest but capable of copying any folders and files. Tuned for media workflows.

For the other app-specific guides, see:

- [DROP_VERIFY_README.md](DROP_VERIFY_README.md) / [DROP_VERIFY_USER_GUIDE.md](DROP_VERIFY_USER_GUIDE.md) — single-folder artifact generation
- [FOLDER_COPY_COMPARE_README.md](FOLDER_COPY_COMPARE_README.md) / [FOLDER_COPY_COMPARE_USER_GUIDE.md](FOLDER_COPY_COMPARE_USER_GUIDE.md) — post-copy folder comparison

---

## Workflow

### 1. Add destinations
- In CopyTrust, use the **Volume Pool** before first copy starts for faster setup:
  - click **Add Dest** on a visible drive/network volume tile, or drag a tile into the Destinations box
  - drag-drop now uses the same permission-grant flow as the add buttons
  - after the first copy starts, the Volume Pool hides and the normal **Volumes** picker remains available
- Use **Add Destination**, drag/drop folders, or use the **Volume Browser**.
- The **Add Destination** folder picker lets you create a new folder directly from the Finder dialog if needed.
- The Volume Browser discovers all mounted external drives, camera cards, SMB/NFS/AFP network shares, and FUSE volumes (e.g. LucidLink). Any volume already added as a source is automatically hidden from the destination picker.
- Empty state shows two ghost slots hinting that multiple destinations are supported.
- After adding one, a persistent **"+ Add another destination…"** row stays visible.
- Optionally set a role label per destination (e.g. "Primary SSD", "Backup NAS").
- Use the **Presets** menu to:
  - save current destinations as a named preset
  - load a preset in one click
  - rename/delete presets
  - note: replace confirmation appears only when destinations are already loaded

### 2. Add source card/folder
- In CopyTrust, the **Volume Pool** also shows camera card and source-capable volume tiles:
  - click **Add Source** or drag a tile into the Sources box
  - tiles show status badges when already added to Sources or Destinations
- Use **Add Source**, drag/drop, or pick from the **Volume Browser**.
- The **Add Source** folder picker also allows creating a new folder directly from the Finder dialog.
- The Volume Browser lists all external and network-mounted volumes, including those connected via Thunderbolt docks.
- Empty state shows two ghost slots hinting that multiple source cards can be queued.
- Camera cards are auto-detected via `DCIM` folders, volume-name hints, and folder signatures.
- Edit source alias inline (used for subfolder naming, receipts, and MHL filenames).
- If the scan returns **0 files** (e.g. security software interference), an orange warning and **Rescan** button appear inline.

### 3. Review preflight
Before copy starts, each destination is checked for:
- available space
- write permission
- reachability

Fix any red (fail) states before copying.

### 4. Configure verification (optional)
Open **Settings → Card Copy** in the CopyTrust settings sheet, then use **Post-Copy Verification** to choose a level:

| Level | What it does | Speed |
|-------|-------------|-------|
| **None** | No post-copy check | Fastest |
| **Quick** | File count + size comparison | Fast |
| **Full** (default) | xxHash64 hash of every source and destination file, compared byte-for-byte | ~9.6 GB/s on Apple Silicon |

Full verification also generates an **MHL v1.1** hash list at each destination — compatible with Hedge OffShoot, Pomfort Silverstack, ShotPut Pro, and YoYotta.

You can also set an **Operator Name** in **Settings → Card Copy → Session**. This name is embedded in MHL files and session receipts.

### 5. Configure auto-advance (optional)
For multi-card workflows where you want to walk away:
- Open **Settings → Card Copy → Copy Behaviour** and enable **Auto-advance to next source**.
- Or toggle the inline **Auto** checkbox in the action bar.
- When enabled, the next queued source starts automatically after the current one finishes successfully.
- CopyTrust now always uses the generated per-card subfolder name automatically. There is no naming popup in the copy flow.
- Queue all your cards/sources first, then click **Start Copy** once. Each source copies in turn.
- Come back later and click **Review & Verify** to inspect all results.

### 6. Start copy
- Click **Start Copy**.
- A **Copy Progress** window opens automatically when the copy starts.
- The progress window shows source percent, live copy speed, and per-destination progress/verify state.
- Click **Close** if you want to hide that window. Copy continues in the background.
- While the copy is still running, use **Open Progress** in the main action bar to bring the live progress window back.
- The main action bar also shows a fixed-width `speedometer` badge after **Auto** so live copy speed stays visible even when the progress window is closed.
- Use **Cancel Copy** in the action bar at any time during active copy. Partially copied files remain on disk.
- Activity Log auto-expands when copy starts and can be manually collapsed.
- Use the `-` and `+` controls in the Activity Log header to reduce or increase the log panel height.
- On first use, a **First Steps & Recovery** help sheet opens automatically.
- After that, use **Help → CopyTrust Help** any time to reopen the same operator guide.

### 7. Review verification results
- **Full**: status shows "Hash Verified" with the xxHash64 algorithm name. An MHL file is saved to the destination root.
- **Quick**: status shows "Verified" (count + size matched).
- **None**: status shows completion without verification.
- If any hash mismatches are detected, they are logged and MHL generation is skipped.
- If the source card is ejected during verification, the app falls back to a destination-file-existence check and notes the incomplete verification.

### 7.1 Contact sheet PDF
After each ingest completes (copy + verification), CopyTrust automatically generates a **contact sheet PDF** if enabled in **Settings → Post-Copy**.

- **Layout**: two styles available in **Settings → Post-Copy → Contact Sheet → Layout style**:
  - **Row (detailed metadata)** (default): one clip per row — metadata on the left, thumbnail frames on the right.
  - **Grid (photo poster, 3×4)**: 12 items per page in a 3-column × 4-row grid. Each cell shows a single thumbnail with a 2-line caption (filename + EXIF summary). Videos show a play/duration badge. Best for photo-heavy ingests.
- **Header**: source alias (large title), operator name, date, session ID, verification status, source and destination paths, optional camera summary, and a summary line showing total clips, frames, duration, and file size.
- **Video rows**: 3 thumbnail frames extracted at even intervals, plus metadata: file type, frame count, duration, resolution, aspect ratio, codec, bitrate, FPS, and audio channel count.
- **Photo rows**: single thumbnail with camera make/model, lens, focal length, aperture, shutter speed, ISO, and resolution.
- Output: `CopyTrust_Receipts/contactsheet_{sourceAlias}_{date}.pdf` at each destination.
- It can be used as a quick visual check of the transferred media after copy and verification, but the actual integrity proof still comes from verification, receipts, and MHLs.
- Supported formats: JPEG, HEIF/HEIC, RAW (CR3, ARW, NEF), MP4, MOV, and all macOS-native image/video types.
- Data-only ingests (no media files) skip contact sheet generation silently.
- Contact sheet failure is non-fatal — it never blocks receipts, MHL, or session close.
- Optional: in **Settings → Post-Copy**, enable **Open contact sheet automatically after creation** if you want each generated PDF to open as soon as it is written.

To disable contact sheet generation, open **Settings → Post-Copy** and uncheck **Generate contact sheet PDF**.

### 7.2 EXIF / media metadata CSV
CopyTrust can also generate a **CSV file** with EXIF and media metadata for all images and videos in each ingest, using the same 23-column format as Drop Verify.

- **Columns**: SourceFile, RelativePath, FileName, FileType, MediaKind, FileSizeBytes, FileSizeReadable, Camera, Make, Model, Lens, DateTaken, Resolution, DurationSeconds, FPS, FrameCount, Codec, AudioChannels, BitrateMBps, FocalLength, ShutterSpeed, Aperture, ISO.
- Output: `CopyTrust_Receipts/exif_{sourceAlias}_{timestamp}.csv` at each destination.
- Toggle in **Settings → Post-Copy → EXIF / Media Metadata CSV** → `Generate EXIF CSV after each ingest` (default off).
- Data-only ingests (no media files) skip CSV generation silently.
- CSV generation failure is non-fatal — it never blocks receipts, MHL, or session close.
- When receipt export is enabled, the CSV is included in the export folder alongside receipts, logs, MHL files, and contact sheets.

### 8. Review & Verify
After at least one source has been copied, a **Review & Verify** button appears in the action bar.

Click **Review & Verify** to open the **Session Summary** sheet. This is **non-destructive** — your session stays intact so you can continue adding and copying more sources.

Once all queued sources are finished, that action changes to **End Session…** and becomes the primary (prominent) button. It still opens the Session Summary first, but it makes the natural next step explicit instead of looping on a generic review action.

The Session Summary sheet has three sections:

1. **Receipt text** — scrollable monospaced summary of all copies, verification results, source totals, and destination totals.
2. **MHL Files** — for each source/destination pair:
   - If an MHL was generated: filename with **Reveal** (opens in Finder) and **Verify** (re-checks hashes) buttons.
   - If no MHL: shows "verification off" or "no MHL" depending on the verification level.
3. **Action buttons:**
   - **Copy Summary** — copies the plain-text receipt to clipboard.
   - **Reveal Receipt** — opens the JSON receipt file in Finder.
   - **End Session** — ends the session, writes receipt files to disk, clears sources/results, and keeps destinations loaded for the next ingest. This is the only way to end a session.
   - **Done** — dismisses the sheet and returns to the live session (press Enter/Return as shortcut).

**Button prominence shift:**
- While sources are still queued: **Start Copy** is primary (green), **Review & Verify** is secondary.
- When all sources are done: **End Session…** becomes the primary action, **Start Copy** dims to secondary.

### 8.1 Button quick reference
**Main action bar**
- **Start Copy**: starts the next ready source copy.
- **Review & Verify**: opens the Session Summary without ending the session while more sources may still be copied.
- **End Session…**: appears when all queued sources are complete and opens the same Session Summary as the final step before ending the session while keeping destinations loaded afterward.
- **Reset Session**: clears the entire session, including destinations; disabled until a copy session has started.
- **Auto**: toggles automatic start of the next queued source after a successful copy.
- **Open Progress**: reopens the live copy progress window if you closed it during an active copy.
- **Cancel Copy**: stops the current copy task. Partially copied files remain on disk.

**Post-Copy Verification**
- **Run Recommended Check**: starts the strongest follow-up check when CopyTrust has flagged something worth investigating.
- **Review Latest Results**: opens the most recent deep-compare summary if one is available.
- **Re-Verify Destinations**: re-hashes the copied files already on each destination.
- **Retry MHL Export**: writes a fresh MHL from already-verified copy data without recopying media.
- **Verify Using MHL…**: imports any `.mhl` file and checks the files listed in it. Shows a live "Verifying file X of Y…" progress indicator during verification.
- **Retry Contact Sheet**: regenerates the contact sheet PDF (and EXIF CSV if enabled) from the latest completed copy results without recopying. Useful when the initial generation failed or was skipped.
- **Deep Compare Files**: re-checks copied source/destination pairs using the verified file set.
- **Open Compare Browser**: opens the detailed file table from the most recent file-check run.
- **Rename Bad MHL**: renames manifest files that cannot be read or parsed to `.mhl.unreadable*` so they stop blocking re-verify.

**Compare Browser**
- **Copy Missing**: copies files marked `Missing Copy` directly into that destination pair, then re-runs file checks.

### 8.2 Typical Operator Flow

**Normal ingest flow**

```text
Add Sources
  -> Add Destinations
  -> Check Preflight
  -> Start Copy
  -> Review & Verify
  -> Deep Compare Files (optional but recommended)
  -> Open Compare Browser (if you want file-level proof)
  -> End Session…
  -> End Session (inside Session Summary)
```

**What each step is for**
- `Add Sources`: load one or more cards/folders into the queue.
- `Add Destinations`: choose one or more copy targets.
- `Check Preflight`: confirm write access, reachability, and free-space warnings are acceptable before copying.
- `Start Copy`: run the actual ingest for the next ready source.
- `Review & Verify`: inspect the session summary and generated MHL links without closing the session.
- `Deep Compare Files`: run the deeper verified-file compare when you want an extra operator-proof pass.
- `Open Compare Browser`: inspect exact file-level results, then use `Copy Missing` if needed.
- `End Session…`: use this after the queue is complete; it opens the final summary as the exit door.
- `End Session`: writes the final session receipt, clears the session, and keeps destinations loaded for the next ingest.

**Recommended verification pass after copy**

```text
Copy completes
  -> Review & Verify
  -> Re-Verify Destinations
  -> Deep Compare Files
  -> If compare passes, End Session…
```

This is the simplest trustworthy pattern for a typical user:
- `Re-Verify Destinations` checks the generated MHL(s) against the copied files.
- `Deep Compare Files` gives you a second, path-agnostic file proof if you want extra assurance.
- If both are clean, the natural next step is to end the session.

### 9. Verify with MHL (post-copy)
After at least one source has been copied, a **Post-Copy Verification** section also appears below sources and destinations. Use it to independently verify your copies:

**Drag-and-drop an MHL file:**
1. Locate the `.mhl` file — either the one CopyTrust generated at the destination, or one from OffShoot, Silverstack, or another tool.
2. Drag the `.mhl` file onto the drop zone in the Post-Copy Verification section.
3. The app parses the MHL, then re-hashes every file listed in it (at the MHL's directory location) using xxHash64.
4. Results appear inline: **matched** (green), **mismatched** (red), **missing** (orange).

**Use the file picker:**
1. Click **Verify Using MHL…** in the Post-Copy Verification section.
2. Browse to the `.mhl` file and select it.
3. Same verification runs as drag-and-drop.

**From the Session Summary sheet:**
1. Click **Review & Verify** to open the sheet.
2. In the MHL Files section, click **Verify** next to any MHL entry.
3. The sheet dismisses and verification runs against that MHL in the main view.

**Typical workflow:**
- Copy card A to Destination 1 and Destination 2 (with Full verification → MHL generated at each).
- Click **Review & Verify** to see the summary and MHL links.
- Click **Verify** on Destination 1's MHL to re-check its files.
- Later, take the MHL to another machine and drop it onto that destination's copy to verify chain of custody.

**Re-verify destinations:**
- Click **Re-Verify Destinations** in the Post-Copy Verification section to re-hash copied files on all destinations.

**If MHL verification fails:**
- Verify panel now shows explicit issue banners (copy status unchanged vs MHL read/creation issue).
- Use **Retry MHL Export** to regenerate missing/failed MHL artifacts from already-verified copy data (no recopy).
- Use **Deep Compare Files** when operator assurance is required.
- After the file-check pass completes, click **Open Compare Browser** to inspect the side-by-side file table for each source/destination pair.
- If the browser shows `Missing Copy`, use **Copy Missing** to repair the destination immediately, then let the app re-run file checks.
- The Post-Copy Verification section now separates bad manifests from destination file-access failures so the warning matches the real problem.
- Failed MHL checks are now listed explicitly in the Verify panel with:
  - filename
  - full path
  - exact failure reason
  - whether the failure is the manifest itself or a referenced-file read/hash failure
  - **Reveal**
  - **Copy Paths**
  - **Rename Bad MHL** (enabled only for manifest read/parse failures)

**Rename Bad MHL (recommended only when the manifest itself is bad):**
- Click **Rename Bad MHL** in the `Failed MHL Checks` section.
- Only manifest read/parse failures are eligible.
- Each unreadable manifest is renamed in place to:
  - `original.mhl.unreadable`
  - or `original.mhl.unreadable2`, `3`, etc. if needed
- This is non-destructive:
  - the damaged file is preserved for audit/manual review
  - but it is no longer discovered as an `.mhl` on future re-verify runs
- Recommended flow:
1. Re-verify reports a manifest read/parse failure.
2. Click **Deep Compare Files**.
3. Click **Open Compare Browser** and confirm the copied files match.
  4. Click **Rename Bad MHL**.
  5. Click **Retry MHL Export** if you need a fresh manifest.
  6. Re-run **Re-Verify Destinations**.
- If the failure says the MHL loaded but referenced files could not be read, do not rename the MHL. Fix destination access/readability first, then retry verification.
- Re-verify now keeps the destination's access grant active while it reads the MHL and hashes referenced files, reducing false "bad MHL" warnings caused by sandbox access loss.
- `Rename Bad MHL` now renames using the destination folder's existing access grant, so the unreadable `.mhl` should actually move out of the active manifest set immediately.
- `Retry MHL Export` now writes a newly timestamped MHL filename, making the regenerated manifest easy to identify.

**If verification or receipt handling goes wrong**

```text
Verification warning or receipt warning
  -> Read the issue banner
  -> Deep Compare Files
  -> Open Compare Browser
  -> If Missing Copy: use Copy Missing
  -> If bad manifest only: use Rename Bad MHL
  -> Retry MHL Export (if needed)
  -> Re-Verify Destinations
  -> End Session…
  -> If receipt copies still fail: choose Save Copies Elsewhere
```

Use that recovery order to avoid the common mistake of treating every MHL warning as a media-copy failure.

**How Deep Compare Files now works:**
- It compares the verified copied file set, not the raw source and destination folder trees.
- Matching is content-first (`size + xxHash64BE`), not strict path-first.
- If the same verified file exists elsewhere under the destination root, it is treated as a valid match.
- Generated artifacts such as `.mhl` are ignored in this compare mode.
- It runs across all copied source/destination pairs in the session, not just the most recent pair.
- This means the file-check pass is answering:
  - "Is the copied file present and intact?"
  rather than:
  - "Is the destination tree structurally identical?"

### 9.1 Subfolder naming with increment
- In **Settings → Card Copy**, template variable `{increment}` inserts a 1-based source queue index.
- `{card_index}` still works for older saved templates, but `{increment}` is the user-facing name shown in the UI.
- Example template: `{date}_{increment}_{alias}`
- With three queued sources: `2026-02-27_1_A_CAM`, `2026-02-27_2_B_CAM`, `2026-02-27_3_C_CAM`.

### 10. Eject source
- On success, source shows safe-to-eject state.
- Use eject controls as needed.

### 11. End session
- Click **Review & Verify** to open the Session Summary sheet.
- Click **End Session** to finalize the session, write receipt files, and keep the destination set loaded for the next session.
- If destination receipt copies cannot be written automatically, the app keeps the local receipt, warns you, and offers **Save Copies Elsewhere** as the default recovery action.
- Each ingest action already writes its own `JSON`, `TXT`, and `LOG` artifacts to the destination `CopyTrust_Receipts/` folder.
- Ending the session writes the aggregate session-close receipt files:
  - plain text to each destination's `CopyTrust_Receipts/` folder
  - JSON to `~/Library/Application Support/CopyTrust/receipts/`
- Receipt includes source + destination transfer outcomes, verification level, duration, hash mismatch details, and MHL file references.

---

## Receipt, MHL, and Log Locations

### Session receipts
- `<destination>/CopyTrust_Receipts/`
- `~/Library/Application Support/CopyTrust/receipts/`
- Every completed ingest action now writes its own named receipt set.
- Session end still writes the aggregate session-close receipt.

### Contact sheet PDF (when enabled)
- `<destination>/CopyTrust_Receipts/contactsheet_{sourceAlias}_{date}.pdf`
- Dark-themed US Letter PDF. Two layout styles: Row (one clip per row with detailed metadata) or Grid (3×4 poster, 12 items per page)
- Videos: 3 frames + codec, FPS, frame count, resolution, audio channels. Photos: 1 thumbnail + full EXIF plus camera make/model when available
- Header shows total clips, frames, duration, file size, source/destination paths, and camera summary when available
- Toggle in **Settings → Post-Copy** → `Generate contact sheet PDF`
- Optional toggle in **Settings → Post-Copy** → `Open contact sheet automatically after creation`

### EXIF / media metadata CSV (when enabled)
- `<destination>/CopyTrust_Receipts/exif_{sourceAlias}_{date}.csv`
- Same 23-column format as Drop Verify CSV: camera, lens, exposure, resolution, duration, codec, bitrate, and more
- Toggle in **Settings → Post-Copy → EXIF / Media Metadata CSV** → `Generate EXIF CSV after each ingest`
- Included in receipt export when enabled

### MHL hash lists (Full verification only)
- Written to the destination root: `CopyTrust - {date} at {time} - {sourceName}.mhl`
- MHL v1.1 XML with xxHash64 digests for every copied file
- Can be re-imported into CopyTrust's Post-Copy Verification section to confirm file integrity at any time
- Also compatible with OffShoot, Silverstack, ShotPut Pro, and YoYotta

### Runtime log
- `~/Library/Containers/com.copytrust.app/Data/Library/Application Support/CopyTrust/logs/<SESSION>/session_<SESSION>.log`
- Or choose **Help → Reveal Session Log**.
- Each completed ingest action also writes a per-ingest `.log` into each destination's `CopyTrust_Receipts/` folder.
- Use **CopyTrust → Settings…** to open the dedicated CopyTrust settings sheet with `Card Copy`, `Camera Card Exclusions`, and `Post-Copy` tabs.
- The **Post-Copy** export option now copies session receipts, per-copy logs, MHL files, contact sheets, and EXIF CSVs into the chosen export folder.

### CopyTrust App Menus
- **CopyTrust → Settings…** opens CopyTrust settings.
- **Help → CopyTrust Help** opens the `First Steps & Recovery` guide.
- **Help → Reveal Session Log** opens the active session log in Finder.
- **Help → Reveal Export Folder** opens the configured export folder when one is set.
- **About CopyTrust** shows version/build info and the `code.matx.ca` link.

Use the runtime log to troubleshoot stalls, copy errors, and state transitions.

---

## Other Tools in the Suite

### Folder Copy Compare
The original tool that inspired the entire suite. A simple post-copy sanity check: drop two folders and see if they match. Use it after a CopyTrust ingest, an Archiware P5 Sync, a Finder copy, rsync, or any other tool.

- [FOLDER_COPY_COMPARE_README.md](FOLDER_COPY_COMPARE_README.md)
- [FOLDER_COPY_COMPARE_USER_GUIDE.md](FOLDER_COPY_COMPARE_USER_GUIDE.md)

### Drop Verify
Single-folder drag-and-drop: generate an MHL, contact sheet PDF, and EXIF CSV from any folder.

- [DROP_VERIFY_README.md](DROP_VERIFY_README.md)
- [DROP_VERIFY_USER_GUIDE.md](DROP_VERIFY_USER_GUIDE.md)

### MHL Verify
Standalone MHL verification — load any `.mhl` file and verify it against the media on disk.

You can also set an **Operator Name** in **Settings → Card Copy → Session**. This name is embedded in MHL files and session receipts.

### 5. Configure auto-advance (optional)
For multi-card workflows where you want to walk away:
- Open **Settings → Card Copy → Copy Behaviour** and enable **Auto-advance to next source**.
- Or toggle the inline **Auto** checkbox in the Card Mode action bar.
- When enabled, the next queued source starts automatically after the current one finishes successfully.
- CopyTrust now always uses the generated per-card subfolder name automatically. There is no naming popup in the copy flow.
- Queue all your cards/sources first, then click **Start Copy** once. Each source copies in turn.
- Come back later and click **Review & Verify** to inspect all results.

### 6. Start copy
- Click **Start Copy**.
- A **Copy Progress** window opens automatically when the copy starts.
- The progress window shows source percent, live copy speed, and per-destination progress/verify state.
- Click **Close** if you want to hide that window. Copy continues in the background.
- While the copy is still running, use **Open Progress** in the main action bar to bring the live progress window back.
- The main action bar also shows a fixed-width `speedometer` badge after **Auto** so live copy speed stays visible even when the progress window is closed.
- Use **Cancel Copy** in the action bar at any time during active copy. Partially copied files remain on disk.
- Activity Log auto-expands when copy starts and can be manually collapsed.
- Use the `-` and `+` controls in the Activity Log header to reduce or increase the log panel height.
- On first use, a **First Steps & Recovery** help sheet opens automatically.
- After that, use **Help → CopyTrust Help** any time to reopen the same operator guide.

### 7. Review verification results
- **Full**: status shows "Hash Verified" with the xxHash64 algorithm name. An MHL file is saved to the destination root.
- **Quick**: status shows "Verified" (count + size matched).
- **None**: status shows completion without verification.
- If any hash mismatches are detected, they are logged and MHL generation is skipped.
- If the source card is ejected during verification, the app falls back to a destination-file-existence check and notes the incomplete verification.

### 7.1 Contact sheet PDF
After each ingest completes (copy + verification), CopyTrust automatically generates a **contact sheet PDF** if enabled in **Settings → Post-Copy**.

- **Layout**: dark-themed US Letter PDF with one clip per row — metadata on the left, thumbnail frames on the right.
- **Header**: source alias (large title), operator name, date, session ID, verification status, source and destination paths, optional camera summary, and a summary line showing total clips, frames, duration, and file size.
- **Video rows**: 3 thumbnail frames extracted at even intervals, plus metadata: file type, frame count, duration, resolution, aspect ratio, codec, bitrate, FPS, and audio channel count.
- **Photo rows**: single thumbnail with camera make/model, lens, focal length, aperture, shutter speed, ISO, and resolution.
- Output: `CopyTrust_Receipts/contactsheet_{sourceAlias}_{date}.pdf` at each destination.
- It can be used as a quick visual check of the transferred media after copy and verification, but the actual integrity proof still comes from verification, receipts, and MHLs.
- Supported formats: JPEG, HEIF/HEIC, RAW (CR3, ARW, NEF), MP4, MOV, and all macOS-native image/video types.
- Data-only ingests (no media files) skip contact sheet generation silently.
- Contact sheet failure is non-fatal — it never blocks receipts, MHL, or session close.
- Optional: in **Settings → Post-Copy**, enable **Open contact sheet automatically after creation** if you want each generated PDF to open as soon as it is written.

To disable contact sheet generation, open **Settings → Post-Copy** and uncheck **Generate contact sheet PDF**.

### 8. Review & Verify
After at least one source has been copied, a **Review & Verify** button appears in the action bar.

Click **Review & Verify** to open the **Session Summary** sheet. This is **non-destructive** — your session stays intact so you can continue adding and copying more sources.

Once all queued sources are finished, that action changes to **End & Keep Destinations…** and becomes the primary (prominent) button. It still opens the Session Summary first, but it makes the natural next step explicit instead of looping on a generic review action.

The Session Summary sheet has three sections:

1. **Receipt text** — scrollable monospaced summary of all copies, verification results, source totals, and destination totals.
2. **MHL Files** — for each source/destination pair:
   - If an MHL was generated: filename with **Reveal** (opens in Finder) and **Verify** (re-checks hashes) buttons.
   - If no MHL: shows "verification off" or "no MHL" depending on the verification level.
3. **Action buttons:**
   - **Copy Summary** — copies the plain-text receipt to clipboard.
   - **Reveal Receipt** — opens the JSON receipt file in Finder.
   - **End & Keep Destinations** — ends the session, writes receipt files to disk, clears sources/results, and keeps destinations loaded for the next ingest. This is the only way to end a session.
   - **Done** — dismisses the sheet and returns to the live session (press Enter/Return as shortcut).

**Button prominence shift:**
- While sources are still queued: **Start Copy** is primary (green), **Review & Verify** is secondary.
- When all sources are done: **End & Keep Destinations…** becomes the primary action, **Start Copy** dims to secondary.

### 8.1 Button quick reference
**Main action bar**
- **Start Copy**: starts the next ready source copy.
- **Review & Verify**: opens the Session Summary without ending the session while more sources may still be copied.
- **End & Keep Destinations…**: appears when all queued sources are complete and opens the same Session Summary as the final step before ending the session while keeping destinations loaded afterward.
- **Reset Session**: clears the entire session, including destinations; disabled until a copy session has started.
- **Auto**: toggles automatic start of the next queued source after a successful copy.
- **Open Progress**: reopens the live copy progress window if you closed it during an active copy.
- **Cancel Copy**: stops the current copy task. Partially copied files remain on disk.

**Post-Copy Verification**
- **Run Recommended Check**: starts the strongest follow-up check when CopyTrust has flagged something worth investigating.
- **Review Latest Results**: opens the most recent deep-compare summary if one is available.
- **Re-Verify Destinations**: re-hashes the copied files already on each destination.
- **Retry MHL Export**: writes a fresh MHL from already-verified copy data without recopying media.
- **Verify Using MHL…**: imports any `.mhl` file and checks the files listed in it.
- **Deep Compare Files**: re-checks copied source/destination pairs using the verified file set.
- **Open Compare Browser**: opens the detailed file table from the most recent file-check run.
- **Rename Bad MHL**: renames manifest files that cannot be read or parsed to `.mhl.unreadable*` so they stop blocking re-verify.

**Compare Browser**
- **Copy Missing**: copies files marked `Missing Copy` directly into that destination pair, then re-runs file checks.

### 8.2 Typical Operator Flow

**Normal ingest flow**

```text
Add Sources
  -> Add Destinations
  -> Check Preflight
  -> Start Copy
  -> Review & Verify
  -> Deep Compare Files (optional but recommended)
  -> Open Compare Browser (if you want file-level proof)
  -> End & Keep Destinations…
  -> End & Keep Destinations (inside Session Summary)
```

**What each step is for**
- `Add Sources`: load one or more cards/folders into the queue.
- `Add Destinations`: choose one or more copy targets.
- `Check Preflight`: confirm write access, reachability, and free-space warnings are acceptable before copying.
- `Start Copy`: run the actual ingest for the next ready source.
- `Review & Verify`: inspect the session summary and generated MHL links without closing the session.
- `Deep Compare Files`: run the deeper verified-file compare when you want an extra operator-proof pass.
- `Open Compare Browser`: inspect exact file-level results, then use `Copy Missing` if needed.
- `End & Keep Destinations…`: use this after the queue is complete; it opens the final summary as the exit door.
- `End & Keep Destinations`: writes the final session receipt, clears the session, and keeps destinations loaded for the next ingest.

**Recommended verification pass after copy**

```text
Copy completes
  -> Review & Verify
  -> Re-Verify Destinations
  -> Deep Compare Files
  -> If compare passes, End & Keep Destinations…
```

This is the simplest trustworthy pattern for a typical user:
- `Re-Verify Destinations` checks the generated MHL(s) against the copied files.
- `Deep Compare Files` gives you a second, path-agnostic file proof if you want extra assurance.
- If both are clean, the natural next step is to end the session.

### 9. Verify with MHL (post-copy)
After at least one source has been copied, a **Post-Copy Verification** section also appears below sources and destinations. Use it to independently verify your copies:

**Drag-and-drop an MHL file:**
1. Locate the `.mhl` file — either the one CopyTrust generated at the destination, or one from OffShoot, Silverstack, or another tool.
2. Drag the `.mhl` file onto the drop zone in the Post-Copy Verification section.
3. The app parses the MHL, then re-hashes every file listed in it (at the MHL's directory location) using xxHash64.
4. Results appear inline: **matched** (green), **mismatched** (red), **missing** (orange).

**Use the file picker:**
1. Click **Verify Using MHL…** in the Post-Copy Verification section.
2. Browse to the `.mhl` file and select it.
3. Same verification runs as drag-and-drop.

**From the Session Summary sheet:**
1. Click **Review & Verify** to open the sheet.
2. In the MHL Files section, click **Verify** next to any MHL entry.
3. The sheet dismisses and verification runs against that MHL in the main view.

**Typical workflow:**
- Copy card A to Destination 1 and Destination 2 (with Full verification → MHL generated at each).
- Click **Review & Verify** to see the summary and MHL links.
- Click **Verify** on Destination 1's MHL to re-check its files.
- Later, take the MHL to another machine and drop it onto that destination's copy to verify chain of custody.

**Re-verify destinations:**
- Click **Re-Verify Destinations** in the Post-Copy Verification section to re-hash copied files on all destinations.

**If MHL verification fails:**
- Verify panel now shows explicit issue banners (copy status unchanged vs MHL read/creation issue).
- Use **Retry MHL Export** to regenerate missing/failed MHL artifacts from already-verified copy data (no recopy).
- Use **Deep Compare Files** when operator assurance is required.
- After the file-check pass completes, click **Open Compare Browser** to inspect the side-by-side file table for each source/destination pair.
- If the browser shows `Missing Copy`, use **Copy Missing** to repair the destination immediately, then let the app re-run file checks.
- The Post-Copy Verification section now separates bad manifests from destination file-access failures so the warning matches the real problem.
- Failed MHL checks are now listed explicitly in the Verify panel with:
  - filename
  - full path
  - exact failure reason
  - whether the failure is the manifest itself or a referenced-file read/hash failure
  - **Reveal**
  - **Copy Paths**
  - **Rename Bad MHL** (enabled only for manifest read/parse failures)

**Rename Bad MHL (recommended only when the manifest itself is bad):**
- Click **Rename Bad MHL** in the `Failed MHL Checks` section.
- Only manifest read/parse failures are eligible.
- Each unreadable manifest is renamed in place to:
  - `original.mhl.unreadable`
  - or `original.mhl.unreadable2`, `3`, etc. if needed
- This is non-destructive:
  - the damaged file is preserved for audit/manual review
  - but it is no longer discovered as an `.mhl` on future re-verify runs
- Recommended flow:
1. Re-verify reports a manifest read/parse failure.
2. Click **Deep Compare Files**.
3. Click **Open Compare Browser** and confirm the copied files match.
  4. Click **Rename Bad MHL**.
  5. Click **Retry MHL Export** if you need a fresh manifest.
  6. Re-run **Re-Verify Destinations**.
- If the failure says the MHL loaded but referenced files could not be read, do not rename the MHL. Fix destination access/readability first, then retry verification.
- Re-verify now keeps the destination's access grant active while it reads the MHL and hashes referenced files, reducing false "bad MHL" warnings caused by sandbox access loss.
- `Rename Bad MHL` now renames using the destination folder's existing access grant, so the unreadable `.mhl` should actually move out of the active manifest set immediately.
- `Retry MHL Export` now writes a newly timestamped MHL filename, making the regenerated manifest easy to identify.

**If verification or receipt handling goes wrong**

```text
Verification warning or receipt warning
  -> Read the issue banner
  -> Deep Compare Files
  -> Open Compare Browser
  -> If Missing Copy: use Copy Missing
  -> If bad manifest only: use Rename Bad MHL
  -> Retry MHL Export (if needed)
  -> Re-Verify Destinations
  -> End & Keep Destinations…
  -> If receipt copies still fail: choose Save Copies Elsewhere
```

Use that recovery order to avoid the common mistake of treating every MHL warning as a media-copy failure.

**How Deep Compare Files now works:**
- It compares the verified copied file set, not the raw source and destination folder trees.
- Matching is content-first (`size + xxHash64BE`), not strict path-first.
- If the same verified file exists elsewhere under the destination root, it is treated as a valid match.
- Generated artifacts such as `.mhl` are ignored in this compare mode.
- It runs across all copied source/destination pairs in the session, not just the most recent pair.
- This means the file-check pass is answering:
  - "Is the copied file present and intact?"
  rather than:
  - "Is the destination tree structurally identical?"

### 9.1 Subfolder naming with increment
- In **Settings → Card Copy**, template variable `{increment}` inserts a 1-based source queue index.
- `{card_index}` still works for older saved templates, but `{increment}` is the user-facing name shown in the UI.
- Example template: `{date}_{increment}_{alias}`
- With three queued sources: `2026-02-27_1_A_CAM`, `2026-02-27_2_B_CAM`, `2026-02-27_3_C_CAM`.

### 10. Eject source
- On success, source shows safe-to-eject state.
- Use eject controls as needed.

### 11. End session
- Click **Review & Verify** to open the Session Summary sheet.
- Click **End & Keep Destinations** to finalize the session, write receipt files, and keep the destination set loaded for the next session.
- If destination receipt copies cannot be written automatically, the app keeps the local receipt, warns you, and offers **Save Copies Elsewhere** as the default recovery action.
- Each ingest action already writes its own `JSON`, `TXT`, and `LOG` artifacts to the destination `CopyTrust_Receipts/` folder.
- Ending the session writes the aggregate session-close receipt files:
  - plain text to each destination's `CopyTrust_Receipts/` folder
  - JSON to `~/Library/Application Support/CopyTrust/receipts/`
- Receipt includes source + destination transfer outcomes, verification level, duration, hash mismatch details, and MHL file references.

---

## Receipt, MHL, and Log Locations

### Session receipts
- `<destination>/CopyTrust_Receipts/`
- `~/Library/Application Support/CopyTrust/receipts/`
- Every completed ingest action now writes its own named receipt set.
- Session end still writes the aggregate session-close receipt.

### Contact sheet PDF (when enabled)
- `<destination>/CopyTrust_Receipts/contactsheet_{sourceAlias}_{date}.pdf`
- Dark-themed US Letter PDF, one clip per row: metadata left, thumbnail frames right
- Videos: 3 frames + codec, FPS, frame count, resolution, audio channels. Photos: 1 thumbnail + full EXIF plus camera make/model when available
- Header shows total clips, frames, duration, file size, source/destination paths, and camera summary when available
- Toggle in **Settings → Post-Copy** → `Generate contact sheet PDF`
- Optional toggle in **Settings → Post-Copy** → `Open contact sheet automatically after creation`

### MHL hash lists (Full verification only)
- Written to the destination root: `CopyTrust - {date} at {time} - {sourceName}.mhl`
- MHL v1.1 XML with xxHash64 digests for every copied file
- Can be re-imported into CopyTrust's Post-Copy Verification section to confirm file integrity at any time
- Also compatible with OffShoot, Silverstack, ShotPut Pro, and YoYotta

### Card mode runtime log
- `~/Library/Containers/com.copytrust.app/Data/Library/Application Support/CopyTrust/logs/<SESSION>/session_<SESSION>.log`
- Or choose **Help → Reveal Session Log**.
- Each completed ingest action also writes a per-ingest `.log` into each destination's `CopyTrust_Receipts/` folder.
- Use **CopyTrust → Settings…** to open the dedicated CopyTrust settings sheet with `Card Copy`, `Camera Card Exclusions`, and `Post-Copy` tabs.
- The **Post-Copy** export option now copies session receipts, per-copy logs, MHL files, and any generated contact sheets into the chosen export folder.

### CopyTrust App Menus
- **CopyTrust → Settings…** opens CopyTrust settings.
- **Help → CopyTrust Help** opens the `First Steps & Recovery` guide.
- **Help → Reveal Session Log** opens the active session log in Finder.
- **Help → Reveal Export Folder** opens the configured export folder when one is set.
- **About CopyTrust** shows version/build info and the `code.matx.ca` link.

Use the runtime log to troubleshoot stalls, copy errors, and state transitions.

Use those when you want to compare two folders, copy missing or different files, generate an MHL from a compared folder, or verify an existing MHL against a folder pair.
