# CopyTrust User Guide

Date: 2026-05-23  
Branch baseline: `main` (v2.4.7 Build 1)

## Purpose

CopyTrust supports more than one real ingest workflow. The app is strongest when the operator can choose the simplest safe pattern for the job instead of forcing every case into one queue model.

This guide describes the main ways to use the app today and when each method makes sense.

## Core Mental Model

- A **source** is a camera card or upstream verified copy.
- A **destination** is where CopyTrust writes the copy.
- In a normal session, **every loaded source copies to every loaded destination**.
- `Queue Current Session` saves the current setup and clears the workspace so another setup can be staged.
- `Start Queue` runs queued sessions in order.
- A **relay chain** means the verified output from one destination becomes the source for the next step.

## Startup And Help

CopyTrust now tries to keep startup guidance focused on the first real job instead of explaining every feature at once.

What happens on first use:
- the in-app help sheet opens automatically
- it starts on `Quick Start`
- `Advanced Start` is there when you intentionally need a relay-chain workflow

How to reopen help:
1. Open `Help > CopyTrust Help`.
2. Start on `Quick Start` for the simplest `A -> B` path.
3. Use `Advanced Start` only when you are intentionally setting up a relay chain.

What `Quick Start` focuses on:
- add one source and one destination
- confirm preflight is clean
- decide whether you want contact sheet PDF, EXIF/media CSV, or both
- confirm `ExifTool` if richer metadata is needed
- if contact sheet PDF is enabled, confirm `ffmpeg` for `MXF` and `REDCINE-X / REDline` for `R3D`

What `Advanced Start` focuses on:
- add one source and two destinations
- use `Queue Relay Chain` to stage an ordered `A -> B -> C` path
- leave this out of the way unless the session actually calls for relay copy

## Workflow Summary

| Method | Best for | Current status | Recommended setup |
| --- | --- | --- | --- |
| Method 1: One card to multiple destinations | Safe dual-copy ingest such as `A -> B` and `A -> C` | Implemented | One live session with one or more sources and two or more destinations |
| Method 2: Relay chain | Fast first copy, then slower downstream copy such as `A -> B -> C` | Implemented, still being polished | One source plus ordered destinations, then `Queue Relay Chain` |
| Method 3: Mixed queued sessions | Different cards going to different destination sets in walk-away order | Implemented | Separate queued sessions, then `Start Queue` |

## Method 1: One Card To Multiple Destinations

Example:
- camera card `A`
- destination `B`
- destination `C`

Use this when:
- you want the same card copied directly to two or more destinations for safety
- both destinations are ready now
- you do not need to free the card before the slower destination finishes

How to do it:
1. Add camera card `A` to the source side.
2. Add destination `B`.
3. Add destination `C`.
4. Click `Start This Session`.

What CopyTrust does:
- it treats this as one ingest session
- source `A` copies to both `B` and `C`
- trust-critical work completes before background PDF/CSV artifacts
- `Review & Verify` lets you inspect the session without ending it
- once all work is done, `Review Summary…` becomes the main review action

Additional cards with the same destinations:
- If you want the next camera card to follow the same destination set, you can keep using the same destination list.
- Add another card source and it will also copy to the preselected destinations.
- If you want a true walk-away queue with cards staged one after another, use `Queue Current Session` after each source-and-destination setup, then click `Start Queue`.

When to prefer separate queued sessions instead:
- when each card should be staged and reviewed as a distinct job
- when the source cards will arrive over time
- when you want a clearer per-card queue history

## Method 2: Relay Chain

Example:
- camera card `A`
- fast destination `B`
- slower destination `C`

Goal:
- copy `A -> B` first
- trust-verify that first leg
- then use verified output on `B` as the source for `B -> C`

Use this when:
- destination `B` is the fastest safe offload target
- destination `C` is slower, remote, or network-based
- you want to free the camera card sooner

How to do it:
1. Add camera card `A` as the source.
2. Add destinations in relay order: `B` first (fastest drive — SSD), then `C` (slower — NAS).
3. A blue callout card appears at the top of the destination list showing the chain path, e.g. `Card A → SSD → NAS`.
4. Check the `Stop 1` / `Stop 2` labels on each destination row. Reorder with the up/down arrows if needed — **put the fastest drive first**.
5. Click `Queue Relay Chain` in the callout (or right-click any destination row → **Queue Relay Chain**).
6. Review the queued sessions panel — each relay leg shows its source type, destination name, and step context.
7. Click `Start Queue`.

Speed ordering tip:
- Copy to your **fastest destination first** (SSD before NAS). This frees the camera card sooner and lets the slower NAS leg run from a local verified copy, not from the card itself.
- The callout reminds you of this when you are about to queue.

What CopyTrust does:
- Step 1 copies from the original camera card to the first destination and verifies it.
- Step 2 waits for the verified output from Step 1, then copies from that verified folder — not the card.
- Later steps continue in the same way.
- PDF/CSV artifact work from Step 1 does not block Step 2.
- The end-session receipt summarises the full relay run with per-leg speed data.
- **Contact sheet PDF generation is faster for relay chains:** thumbnails generated for the first destination are cached on disk and reused for every subsequent leg — no redundant preview work for the same card content.

What the queue panel shows after queuing (reviewing before Start Queue):

Each relay leg appears as a distinct row with a chain icon prefix and blue tint. For a card-to-SSD-to-NAS relay the operator sees:

**Step 1 row:**
```
⦿ A001 → Samsung T7
A001 · Camera Card  →  Samsung T7 · Drive
Step 1 of 2 — copies from A001 (camera card).
```

**Step 2 row:**
```
⦿ Samsung T7 → Synology NAS
Samsung T7 · Drive  →  Synology NAS · Network
Step 2 of 2 — waits for Samsung T7 (drive) to be verified, then copies from it.
```

Hovering over either row shows the exact folder paths:
```
Source: /Volumes/A001
Destination: /Volumes/Samsung T7/Ingest/ProjectX
```

Right-clicking a queue row offers:
- **Reveal Source in Finder** — opens the source volume or folder directly
- **Reveal Destination in Finder** — opens the destination folder directly

Right-click shortcut on destination rows:
- Right-clicking any destination row when relay conditions are met shows a **Queue Relay Chain** menu item — same action as the callout button.
- The context menu also offers **Reveal in Finder** and **Remove Destination** for any destination at any time.

Destination Sort and relay chains:
- If Destination Sort is enabled, sorting is **skipped on intermediate legs** and only runs on the final destination. This prevents the sort from moving files while the next leg is reading from them. The final destination gets the organized type-folder layout.

Important note:
- The current relay workflow requires **one source and two or more destinations in order**.
- If you want another camera card to follow the same relay path, stage it as a **separate relay-chain session**.
- `A → B → C` and `D → B → C` should be queued as two separate relay chains, not a combined multi-source relay session.

Why this matters operationally:
- the card gets offloaded to the fastest destination first
- the second leg reads from a verified upstream copy instead of keeping the card mounted
- slower NAS or network copies can happen after the first trusted copy exists

The session receipt now shows this directly. The `COPY SPEED SUMMARY` block lists each leg side by side so the speed differential is immediately visible:

```
COPY SPEED SUMMARY
  [1] MacBook Pro SSD       218 MB/s copy  |  387 MB/s verify  |  4m 32s
  [2] Synology NAS          387 MB/s copy  |  412 MB/s verify  |  2m 21s
  --------------------------------------------------
  Session total: 265.7 GB in 6m 53s  (avg 654 MB/s across all legs)
```

This is the receipt-level proof that the relay strategy worked — the card-to-SSD leg was faster than a direct card-to-NAS copy would have been, and the NAS leg ran from the verified local copy without keeping the card mounted.

## Method 3: Mixed Queued Sessions

Example:
- Session 1: camera card `A -> B`
- Session 2: camera card `B -> D`

Use this when:
- different cards need different destinations
- you want to preload multiple distinct jobs and then walk away
- not every source shares the same destination set

How to do it:
1. Build the first source/destination setup.
2. Click `Queue Current Session`.
3. Build the second setup.
4. Click `Queue Current Session` again.
5. Repeat as needed.
6. Use the queue arrows if you want to change the run order before copy begins.
7. Click `Start Queue`.

What CopyTrust does:
- each setup becomes its own queued session
- queued sessions run in order
- trust-critical work for one session finishes before the next queued session starts
- background artifact work can continue afterward without blocking the next queued session
- queued rows can be intentionally reordered, including placing a standalone queued job before or between relay-chain rows

This is the strongest fit for:
- load-up-and-walk-away workflows
- different destination groups
- repeated operator staging before copy begins

## Choosing The Right Method

Use Method 1 when:
- the same card should go directly to multiple destinations right now

Use Method 2 when:
- the first destination is the fast safe landing point
- later destinations should read from that verified first copy

Use Method 3 when:
- different cards need different destination sets
- you want a staged queue of separate jobs

## Reviewing a Queued Session Before Running It

### Inline expand (Build 9+) — recommended

Click the `›` chevron at the left edge of any queued row to expand a detail panel inline. No workspace change, no reset needed. Multiple rows can be expanded at once — useful for reviewing both legs of a relay chain side by side.

The expanded panel shows:

| | |
|---|---|
| 📷 `A001` | `Camera Card` · `/Volumes/A001` · Reveal |
| 💾 `[Samsung T7  ]` | `Drive` · `/Volumes/Samsung T7/Ingest/ProjectX` · Reveal |

- **Source rows** are read-only: name, type, path, Reveal in Finder.
- **Destination rows** have an editable alias field — rename a destination without loading the session into the workspace. Changes take effect immediately on the queued item.
- **Reveal** buttons open the exact source or destination folder in Finder.

Hover over any queued row to see the full source and destination paths as a tooltip. Right-click any queued row for `Reveal Source in Finder` and `Reveal Destination in Finder`.

### Load button — for running a specific leg out of queue order

The `Load` button fills the workspace with a queued session's source and destination. Use it when you want to run a specific leg independently rather than using `Start Queue`.

- After loading, press `Start This Session` to run it.
- To put it back without running, click `Return to Queue` — this restores the session to `.queued` status and clears the workspace without touching any other queued items.
- `Reset Session` wipes the entire queue and workspace. Use it only when you want to start completely fresh.
- `Queue Current Session` is hidden while a session is loaded — this prevents accidentally enqueuing a duplicate.
- Load is one-at-a-time: the button is disabled if another session is already loaded or a copy is running.

For inspection and alias editing, prefer the `›` expand panel — it does not disturb the workspace.

## Session Lifecycle — Start, Stop, Continue, Reset

### Starting

| Situation | Button |
|-----------|--------|
| Source and destination in workspace | `Start This Session` |
| Sessions staged in the queue | `Start Queue` |
| A specific queued leg loaded via Load | `Start This Session` (runs that leg only) |

### During a running copy

| Situation | Button |
|-----------|--------|
| Open the full progress sheet | `Progress` (icon-only, bottom bar) |
| Hide the progress sheet, keep copying | `Hide` (in progress sheet) |
| Inspect results without stopping | `Review & Verify` (main window) |
| Stop the copy | `Cancel Copy` (bottom bar or progress sheet) |

During copy, the action bar is streamlined: Reset Session, Card/Folder picker, and Preflight badge are hidden. The queue manager shows inline progress on the running row.

### After cancelling — progress sheet

Two buttons appear together:

- **`Resume`** — restarts from where it stopped; reconciled files are not re-copied
- **`Done`** — dismisses the sheet and returns to the main window; the session remains in its cancelled state

### After cancelling — main window

The action bar simplifies to just two (or three) clear options:

```
[ Resume ]  [ Resume Queue ]  ...  "Session cancelled — resume or end?"  ...  [ End Session ]
  primary      if queued                    status label                         secondary
```

- **Resume** (blue) — retry the copy from where it stopped; reconciled files are not re-copied
- **Resume Queue** (blue) — appears when queued batches remain; starts the remaining queue without retrying the cancelled copy
- **End Session** — formally closes the session and saves whatever was captured

All other controls (Reset Session, Card/Folder picker, Preflight badge, Auto toggle, naming preview, Reveal buttons) are hidden in this state. **Review Summary**, **Reveal Receipts**, **Reveal Session Log**, and **Reveal Manifest** are accessible from the **File menu** at any time.

### After completing — main window

```
[ Review Summary ]  ...  "Copy complete"  ...  [ End Session ]
     primary ●                                    secondary
```

- **Review Summary** (blue) — opens the full session summary; `End Session` is also accessible from inside
- **End Session** — closes directly without opening the summary; use when you are confident the run is good

All other controls (Reset Session, Card/Folder picker, Preflight badge, Queue, naming preview, Start) are hidden. Reset and Start are available after ending the session. Review Summary, Reveal Receipts, Reveal Log, and Reveal Manifest are accessible from the **File menu** at any time.

### Queue management with Load

The `Load` button puts a specific queued session into the workspace for running out of order. Three actions are then available:

| Button | Effect on queue |
|--------|----------------|
| `Start This Session` | Runs the loaded leg; removes it from queue on completion |
| `Return to Queue` | Restores the leg to `.queued` status; clears workspace; rest of queue untouched |
| `Reset Session` | Wipes workspace AND entire queue — all legs gone |

Use `Return to Queue` to un-load without committing. Use `Reset Session` only when you want a clean slate.

### Reset Session — what it clears

Reset Session always clears:
- All sources and destinations in the workspace
- All copy results and run history in the current session
- All queued sessions — every relay chain leg and standard queued item
- All preflight and stats state

It does not clear:
- The speed history file (`device_speed_history.json`)
- Previously closed session receipts and manifests on disk
- The last closed review (accessible via `Review Last Summary…`)

## Review And End Session

### During an active session
`Review & Verify` opens the session summary without ending the session. Use this when you want to inspect results, MHL entries, or receipt text while more work may still happen.

### When a run completes or is cancelled

Two paths are available directly from the main window — no need to open the summary sheet first:

| Button | When | What it does |
|--------|------|-------------|
| `Review Summary…` / `Review & Verify` | Always after a run | Opens the summary sheet for inspection. End Session is inside the sheet. |
| `End Session` | Always after a run | Closes the session immediately and saves results without opening the summary sheet. |

Use `End Session` in the main window when you are confident the run is good and just want to move on. Use `Review Summary…` when you want to check file counts, MHL entries, or receipt text before closing.

`End Session` is available after both:
- a **completed** run — all sources verified, queue finished
- a **cancelled or failed** run — any partial results exist

After a cancelled run the action bar simplifies to:
```
[ Resume ]  [ Resume Queue ]  ...  "Session cancelled — resume or end?"  ...  [ End Session ]
```
Resume Queue only appears when queued batches remain.

### What End Session does
- Closes the session and clears the live workspace
- Saves the result so it remains available for later review
- After ending, use `Review Last Summary…`, `Reveal Receipts`, `Reveal Log`, `Reveal Manifest`, or `Reset Session` from the main window

### Summary-sheet actions (if you open Review Summary first)
- `Copy` — copies the receipt text to the clipboard
- `Reveal Summary`
- `Manifest`
- `Log`
- `End Session`
- `End` / `Wait` when background PDF/CSV artifact work is still running

## Destination Folder Safety

CopyTrust validates the destination before any file transfer begins.

### Duplicate subfolder names are blocked before copy starts

If two pending sources would render to the same destination subfolder name (e.g. both use the same naming template and resolve to `ProjectX/A001`), `Start This Session` is blocked. The blocked-start message tells the operator which sources conflict and points to the source alias, prefix, or naming template as the fix path.

### Fresh ingests cannot merge silently into existing folders

If a fresh ingest targets a destination subfolder that already has content in it and no matching prior manifest exists, start is also blocked. This prevents the silent “copy into an old folder” scenario where new files are mixed with previous ingest output.

### Resume is an explicit, validated path

A pre-existing destination subfolder is only accepted when CopyTrust finds a matching prior manifest for exactly that source, destination set, and rendered subfolder. This is the Resume path. Any other pre-existing folder is treated as a collision, not a continuation.

## Partial-Failure Recovery

If a copy run fails mid-way (network drop, drive ejection, unexpected error), CopyTrust now preserves enough state to offer Resume — the same path available after an explicit cancel. Resume is offered when the source, destination set, and rendered subfolder still match the saved partial manifest.

The progress sheet and the source row both surface this state as recoverable rather than treating every failure as a dead end.

## Destination Volume Disconnect and Recovery

CopyTrust actively monitors all destination volumes during a session. If a destination drive or NAS disconnects mid-copy, the app detects it immediately and takes the following steps:

1. **Immediate detection** — macOS mount/unmount notifications are monitored in real time. When a destination path disappears, CopyTrust cancels the active copy within seconds rather than logging misleading "permission denied" errors for every remaining file.
2. **Clear error message** — the log and UI show "Volume X is no longer available (unmounted or disconnected)" instead of a generic permission error.
3. **Artifact cancellation** — any running contact sheet or CSV generation for the disconnected destination is stopped immediately.
4. **Start button blocked** — the Start button is disabled while any destination is unavailable, with a message explaining which volume is missing.

### Auto-Resume on Reconnect

When the destination volume comes back (drive re-plugged, NAS remounted), CopyTrust:

1. Detects the remount automatically via macOS notifications.
2. Clears the unavailable state for that destination.
3. Finds the first cancelled or failed source that was targeting the reconnected destination.
4. Resumes the copy automatically — already-verified files are skipped and only remaining files are copied.
5. Retries any failed artifact tasks (contact sheet, CSV, sort) for the reconnected destination.

If auto-resume does not trigger (e.g. the source was removed or the session was ended), you can still use `Start This Session` to restart manually. The resume infrastructure will detect the partial manifest and skip verified files.

### Pre-Copy Destination Check

Before scanning or copying begins, all destination volumes are verified as reachable. If a destination has disappeared between setup and start, the copy is blocked with a clear message instead of failing mid-scan.

### What Happens to In-Progress Files

If a file was partially written when the volume disconnected, the incomplete file remains on the destination. On resume, CopyTrust reconciles the destination — it re-scans and re-hashes any files already present. A partially written file will fail hash verification and be re-copied from scratch.

## macOS Notifications

CopyTrust posts native macOS notifications for key events so you can walk away during long copies or multi-card queues and still know when something needs attention.

### Notification Events

| Event | Default | What it means |
|-------|---------|---------------|
| Copy Complete | On | A source finished copying and verifying to all destinations |
| Copy Failed | On | A copy failed or was cancelled |
| Volume Disconnect | On | A destination drive or NAS disconnected mid-session |
| Volume Reconnect | On | A previously disconnected destination is available again |
| Auto-Resume Started | On | CopyTrust is automatically resuming after a volume reconnect |
| Verification Result | On | Hash verification passed or failed |
| Artifacts Complete | Off | Contact sheet and CSV finished successfully |
| Artifacts Failed | Off | Contact sheet or CSV generation failed |

### Settings

Open `Settings > Notifications` to toggle each event type on or off. The test button sends a sample notification to verify your system is configured correctly.

### System Permissions

On first launch, macOS will prompt you to allow notifications from CopyTrust. If notifications do not appear:
1. Open **System Settings > Notifications > CopyTrust**.
2. Ensure **Allow Notifications** is enabled.
3. Choose your preferred alert style (Banners or Alerts).

## Troubleshooting

### Copy says "no permission" but the drive was disconnected

Prior to v2.4.4, macOS would report "permission denied" errors when a volume mount point disappeared, which was misleading. In v2.4.4 and later, CopyTrust detects the real cause — volume unavailability — and reports it accurately. If you see this on an older version, check whether the destination drive or NAS is still connected.

### Copy was interrupted — can I resume?

Yes. CopyTrust saves a session manifest to local App Support after each verified file. When you restart a copy with the same source and destination, CopyTrust finds the manifest and offers resume. Already-verified files are skipped. If the interruption was a volume disconnect, auto-resume handles this automatically when the volume returns.

### Artifacts stuck after a volume disconnect

Prior to v2.4.4, artifact generation (contact sheet, CSV) could appear stuck after a destination disappeared because the failure was not detected promptly. In v2.4.4, running artifacts are cancelled immediately on disconnect and retried automatically on reconnect. If artifacts remain stuck, use `End Session` and re-run artifacts via Drop Verify on the destination folder.

### Card 2 did not start after Card 1

If Card 1's copy failed due to a volume disconnect, Card 2 was not started because the queue waits for trust-critical work to complete before advancing. In v2.4.4, the volume disconnect is detected immediately, so the failure is reported faster. Once the volume returns and auto-resume completes Card 1, the queue advances to Card 2 normally.

### Notifications not appearing

1. Check **System Settings > Notifications > CopyTrust** — notifications must be allowed.
2. Check **Settings > Notifications** in CopyTrust — the event type must be toggled on.
3. Use the **Send Test Notification** button in Settings to verify the system is working.
4. Focus mode or Do Not Disturb will suppress notifications — check your macOS Focus settings.

### The pipeline: what runs when

Understanding the order of operations helps diagnose where an issue occurred:

1. **Pre-copy checks** — destination reachability, free space, subfolder collisions
2. **File scan** — enumerate source files, apply exclusion patterns
3. **Copy + Inline Verify** — write files to all destinations; with inline verification (the default), each file is hashed at the source during copy, then immediately hashed at the destination and compared — pass/fail feedback appears per-file during this phase
4. **Batch Verify** — if using Full (batch) verification instead of inline, all destination files are re-hashed and compared after the copy phase completes
5. **MHL** — write MHL v1.1 manifest
6. **Receipt + Log** — write per-copy receipt and session log
7. **Sort** — reorganize files into type folders (if enabled)
8. **Contact sheet PDF** — generate thumbnail contact sheet (if enabled)
9. **EXIF CSV** — generate metadata CSV (if enabled)

Steps 1–6 are trust-critical. Steps 7–9 are background artifacts that do not block the next queued session. A failure in step 8 does not affect the integrity of the copy — the files and their verification are already sealed.

With inline verification (step 3), the separate batch verify phase (step 4) is skipped — verification completes as part of the copy. This means trust-complete status is reached sooner.

## Verify Diagnostics

Before verification hashing begins, CopyTrust logs a structured diagnostic showing file count, byte count, reused files, and whether any prior copy failures or skipped files already exist. This provides context that was previously only reconstructable by replaying the full session log.

If verification aborts, the abort path now logs the exact stage (source hashing vs destination hashing) and the file path that triggered the failure, instead of collapsing into a vague terminal error. JSON and plaintext receipts preserve failed/skipped file counts and the first recorded error line for post-run analysis.

## Camera Card Exclusions

Settings → Card Copy → Camera Card Exclusions lets you skip files or folders during card copy. Each exclusion pattern has a type that controls how it matches against path components. These exclusions only apply when using Card mode.

### Pattern Types

| Type | Matches when… | Example |
|------|---------------|---------|
| **Exact** | A folder or file name equals the pattern | `MISC` skips any folder named MISC |
| **Suffix** | A folder or file name ends with the pattern | `.THM` skips `DJI_0001.THM` |
| **Prefix** | A folder or file name starts with the pattern | `._` skips `._DSC0001.ARW` |
| **Contains** | A folder or file name contains the pattern | `cache` skips `fcpcache` |
| **Regex** | A folder or file name matches the regular expression | `(?i)\.mhl$` skips any `.mhl` file |

### Dot-prefix shortcut

Any pattern that starts with `.` (e.g. `.MP4`, `.THM`, `.LRV`) is automatically treated as a file-extension match. It works as a case-insensitive suffix regardless of which type is selected. This means `.MP4` will match `DJI_0001.MP4`, `video.mp4`, and `clip.Mp4`.

### Case insensitivity

All pattern types are case-insensitive. `MISC` matches `misc`, `.MP4` matches `.mp4`, and so on.

## Destination Sort (Post-Copy)

CopyTrust can optionally reorganize files on the destination into type-based subfolders after the trust chain is complete. The sort runs after copy, verify, MHL, and receipt writes — the integrity proof is sealed before any files are moved.

### Enabling

1. Open `Settings > Post-Copy`.
2. Toggle **Sort files into type folders on destination**.
3. Choose a folder mode and review the category list.

### Folder Modes

| Mode | Result | Example |
|------|--------|---------|
| **Flatten** (default) | All files of a type go directly into the type folder | `JPG/IMG_001.JPG` |
| **Preserve Structure** | Source directory tree is kept inside the type folder | `JPG/DCIM/100/IMG_001.JPG` |

In Flatten mode, if two files have the same name, the second is renamed automatically (`IMG_001_2.JPG`, `IMG_001_3.JPG`, etc.).

### Default Categories

| Category | Folder | Extensions |
|----------|--------|------------|
| JPG | `JPG` | jpeg, jpg, heic, heif, png, tiff, tif, bmp, gif |
| RAW | `RAW` | cr3, cr2, arw, nef, dng, raf, orf, rw2, pef, srw, iiq, 3fr, fff, erf, nrw, gpr |
| Video | `Video` | mov, mp4, m4v, avi, mts, m2ts, m2t, m2v, vob |
| Pro Video | `Pro Video` | mxf, r3d, braw, ari, cdng |
| Audio | `Audio` | wav, mp3, aac, aiff, bwf, flac |
| Sidecar | `Sidecar` | xmp, thm, aae, lrv, srt |

### Customizing Categories

- Toggle individual categories on or off.
- Edit the folder name (the actual subfolder created on disk).
- Edit the extension list (comma-separated, case-insensitive).
- Add new categories for project-specific file types.
- Delete categories you do not need.
- Use **Reset to Defaults** to restore the original six categories.

### Relay chains and sorting

In a relay chain (e.g. Card A → SSD B → NAS C), sorting is **skipped on intermediate destinations** and only runs on the final leg.

Why: the next relay leg reads files from the previous destination. If the sort were moving files at the same time, the downstream copy could encounter missing files or a mix of sorted and unsorted paths. The intermediate destination is a transit point — the final destination is where the organized layout matters.

Example with a three-leg relay and sort enabled:

| Leg | Source | Destination | Sort? |
|-----|--------|-------------|-------|
| Step 1 | Card A | SSD B | No (intermediate — Step 2 reads from B) |
| Step 2 | SSD B | NAS C | Yes (final leg — files sorted into type folders) |

For a normal multi-destination session (not relay), every destination is sorted independently.

### What is not moved

- The `CopyTrust_Receipts/` folder is never touched by the sort.
- Files with extensions that do not match any enabled category remain in place.
- Empty source directories are cleaned up after sorting.

### Pipeline order

1. Copy files
2. Verify hashes
3. Write MHL
4. Write per-copy receipt and log
5. **Sort files on destination** (if enabled)
6. Generate contact sheet PDF (uses sorted paths)
7. Generate EXIF CSV (uses sorted paths)
8. Export artifacts

The contact sheet PDF and EXIF CSV reflect the sorted file locations, not the original copy layout.

## Safety Concept

CopyTrust is designed around the idea that safety can mean either:
- **multiple direct copies from the original card**, or
- **a fast trusted first copy followed by downstream relay copies**

Both are valid, but they serve different operational needs:
- Direct multi-destination copy is simpler and gives parallel redundancy from the original source.
- Relay chaining is better when the first destination is much faster than the later destination and the card needs to be freed sooner.

## Inline Verification

Inline verification is the new default verification mode (v2.4.5). It replaces the batch verification pass with per-file verification during the copy phase.

### How it works

1. Each file is hashed at the source as it is being copied (xxHash64).
2. Immediately after the file is written to the destination, the destination copy is hashed.
3. The two hashes are compared. A pass/fail indicator appears next to each file in the progress view.
4. If a mismatch is detected, the file is logged as failed and the copy continues to the next file.

### Why inline is the default

- **Faster feedback.** Errors are detected as they happen, not minutes later in a separate verification phase.
- **Shorter total time.** Trust-complete status is reached as soon as the last file is copied and verified, with no separate verify pass.
- **Same trust guarantee.** The hash comparison is identical to batch verification — the only difference is timing.

### Verification levels

| Level | Behaviour |
|-------|-----------|
| **Inline** (default) | Per-file hash during copy. No separate verify phase. |
| **Full** | All files copied first, then all destination files re-hashed in a separate batch pass. |
| **Quick** | Metadata-only check (size, date) — no hash verification. |
| **None** | No verification at all. |

### Post-copy re-verify

An optional post-copy re-verify pass can be enabled in Settings. When on, the traditional batch verification runs after inline verification completes, using `bypassCache: true` to force reads from disk rather than OS cache. This provides a belt-and-suspenders guarantee for high-value ingests.

### UI labelling

When inline verification is active, all progress surfaces read **"Copying & Verifying"** instead of just "Copying":
- The progress sheet badge shows "copying & verifying" with the overall percentage
- The status message bar reads "Copying & Verifying to N destinations…"
- The source row in the main window shows "Copying & Verifying"
- The menu bar popover phase reads "Copying & Verifying"
- Session log lines record `phase=copying+verifying`

When using Full (batch) verification, labels remain unchanged: "Copying" during the copy phase, then "Verifying" during the separate verify phase.

### MHL and receipts

MHL generation works identically with inline verification. Hashes are accumulated during the copy phase and written after the last file completes. Receipts show the same fields regardless of verification mode.

## Copy Type Presets

Copy type presets let operators switch between camera-card and folder-copy configurations with one click. Each mode maintains its own independent settings profile — changes to Card settings never affect Folder settings and vice versa.

### Preset picker

A segmented control in the toolbar shows the active preset: **Card** or **Folder** (orange tint). Switching modes saves the current settings to the outgoing profile and loads the incoming profile. The picker is hidden during an active copy.

### Preset defaults

| Setting | Card | Folder |
|---------|------|--------|
| Subfolder naming | `{alias}_{date}` | `{alias}` |
| Preserve original folder names | On | On |
| Camera card exclusions | On (defaults) | Not applicable |
| Destination sort | On | Off |
| Verification level | Inline | Quick |
| Auto-advance | On | Off |
| Contact sheet | On | Off |
| EXIF CSV | Off | Off |
| Auto-eject | Off | Off |

### Per-mode settings

Each mode stores its own complete settings profile including: naming template, subfolder prefix, file prefix, preserve original names, verification level, post-copy re-verify, auto-advance, auto-eject, contact sheet (on/off, style, open after creation, hide placeholders), EXIF CSV, and destination sort (on/off, categories, folder mode).

Configure each mode independently:
- **Settings > Card Copy** — card-specific settings plus Camera Card Exclusions
- **Settings > Folder Copy** — folder-specific settings
- **Settings > Test** — built-in test harness to validate settings for either mode (see [Test Harness](#test-harness) below)

Shared settings (not per-mode): operator name, external codecs, notifications, appearance, destination presets, receipt export.

### Per-queue-item snapshots

When a batch is queued, the full active profile is captured as a snapshot. Each queued item runs with exactly the settings chosen at staging time. You can queue a Card batch with inline verification, switch to Folder mode, queue a Folder batch with quick verification — each runs independently. Already-queued items are not affected by later settings changes.

### Persistence

Both profiles are saved to disk and survive app restarts. On first launch after upgrading, existing settings are migrated into the Card profile. The Folder profile starts with factory defaults.

## Preserve Original Folder Names

When **Preserve Original Folder Names** is enabled (default in both Card and Folder presets), the destination subfolder keeps the exact name, case, and spacing from the source volume's mount-point name.

### What changes

| Setting | Destination subfolder for source `2026-001 My Project` |
|---------|--------------------------------------------------------|
| Preserve off | `2026_001_My_Project` (sanitized, underscored) |
| Preserve on (default) | `2026-001 My Project` (original name kept) |

Preserve mode reads the raw volume name directly — dashes, spaces, dots, mixed case, and Unicode are all kept exactly as the source provides them. The source alias shown in the UI also matches the raw volume name.

### What is still sanitized

Only characters that are illegal on macOS/APFS are removed: `/`, `:`, and null bytes. Everything else — spaces, mixed case, Unicode, dashes, dots — is preserved.

### What is not affected

MHL filenames, receipt filenames, and manifest filenames always use the safe sanitized form. Only the destination subfolder name honours this setting.

## Name Length Guard

CopyTrust checks subfolder name length before copy begins (v2.4.5).

### APFS limit

APFS allows a maximum of 255 bytes per path component. With ASCII characters this means 255 characters; with multi-byte Unicode (emoji, CJK) the byte count may be higher than the character count.

### What happens

- If the rendered subfolder name exceeds 255 bytes, it is truncated at a clean character boundary (no split multi-byte characters).
- The subfolder naming preview in the main window shows an orange warning icon when truncation would occur.
- The total path length (destination root + subfolder + longest relative file path) is also checked against 1024 bytes.

### When to expect this

Name length issues are more likely with the Folder preset and Preserve Original Folder Names enabled, since sanitized names are typically shorter than original names.

## Dark Mode

CopyTrust defaults to dark appearance (v2.4.5).

### Settings

Open `Settings > Appearance` to choose:

| Mode | Behaviour |
|------|-----------|
| **Always Dark** (default) | Dark appearance regardless of macOS setting |
| **Follow System** | Follows the macOS Light/Dark appearance setting |

## Menu Bar Progress

CopyTrust shows copy progress in the macOS menu bar (v2.4.5).

### Menu bar icon

A `doc.on.doc` icon appears in the menu bar. During an active copy the icon fills in (`doc.on.doc.fill`).

### Popover content (during copy)

| Field | Example |
|-------|---------|
| Source name | `A001` |
| Destination count | `2 destinations · Copying` |
| Progress bar | Visual bar with percentage |
| File count | `142 / 380 files` |
| Bytes | `48.2 GB / 128.7 GB` |
| Show CopyTrust | Button to bring the main window forward |

### Idle state

When no copy is running, the popover shows a green checkmark and "No active copies" with a Show CopyTrust button.

### Use case

The menu bar progress lets operators monitor copies without keeping the main CopyTrust window visible. Minimize or hide the window and check the menu bar icon for status.

## Queue Manager — Staging During Active Copy

When a copy starts, the UI transforms from the source/destination setup panels into a compact **Copy Queue** manager (v2.4.6). This provides a clear visual mode shift and makes it obvious that the app is in a running-copy state.

### Queue Manager layout

The queue manager replaces the two side-by-side panels with a single full-width panel showing:
- A **running row** for the active copy — status icon, source name, arrow, destination names, preset badge, and live progress bar
- **Queued rows** for staged batches — each showing source, destinations, preset, and status
- **Completed/failed rows** that remain until manually cleared or auto-pruned after 24 hours
- A **drop target strip** at the bottom for dragging volumes from the Available Volumes pool

### Inline progress expansion

Click the running row to expand it. The expanded view shows:
- Per-destination progress bars with percentage and bytes
- Copy speed and estimated time remaining
- Recent verified files (today's session) with pass/fail icons
- "Open Full Progress" button to access the detailed progress sheet
- "Cancel" button

An icon-only **Progress** button in the bottom action bar opens the full progress sheet on demand. The progress sheet no longer auto-opens when a copy starts — inline progress in the queue manager is the primary view.

### How to stage the next batch

Three ways to add a new batch during an active copy:

1. **[+ Add] button** — click in the queue manager header. A sheet opens with available source volumes shown as wrapping chips (read-only and camera card volumes sorted first, volumes already in use filtered out) and pre-populated destinations from the running copy. Choose a preset (Card/Folder with orange segmented control), adjust destinations if needed, then click "Add to Queue."

2. **Drop a volume** — drag a volume chip from the Available Volumes pool onto the dashed drop strip at the bottom of the queue manager. This creates a queued batch using that volume as the source and the current active destinations.

3. **Click a volume in the pool** — while the queue manager is active, clicking a volume in the Available Volumes pool adds it directly to the queue using the current destinations.

### What happens to staged batches

Staged batches appear as queued rows in the queue manager. When the current copy completes, auto-advance picks up the next queued session and starts it automatically (if auto-advance is enabled). This works for batches added via [+ Add] during both direct-start copies and queued runs.

### After cancelling with queued batches remaining

If you cancel the first copy and queued batches remain, **Start Queue** appears prominently in the bottom action bar. Click it to start the remaining queued sessions without restarting the cancelled copy. The action bar is streamlined in this state — Reveal buttons are hidden, and Review & Verify is the primary inspection action.

### Returning to setup mode

When all queued items finish and no copy is running, the UI transitions back to the original source/destination setup panels. If queued items remain visible (completed, waiting for manual start), the queue manager stays active.

### Auto-cleanup

Completed, cancelled, and failed queue items older than 24 hours are automatically removed on app launch. Use the "Clear Done" button in the queue manager header for immediate manual cleanup.

## Mixed Presets in Queue

Each queued session stores the active copy preset at the time it was created (v2.4.5).

### Visual indicator

Queue rows show a coloured badge next to the session name:
- **Card** — blue badge
- **Folder** — green badge

### Behaviour

When a queued session starts, its stored preset is applied before the copy begins. This means different queue items can use different presets in the same queue run — for example, a Card-preset camera card ingest followed by a Folder-preset folder backup.

### How presets are stored

The preset is saved with the queued session item and persists across app restarts. Changing the active preset in the toolbar does not retroactively change already-queued sessions.

## Current Practical Guidance

- For `A -> B` and `A -> C`, use one normal session with multiple destinations.
- For `A -> B -> C`, use `Queue Relay Chain`.
- For `A -> B -> C` followed by another card taking the same path, queue each card as its own relay chain.
- For different cards going to different destinations, use separate queued sessions and `Start Queue`.
- For camera card ingest, use the **Card** preset. For folder backup or archive, use the **Folder** preset.
- To stage the next job while a copy runs, load sources and destinations, then click **Queue This Batch**.
- Check the menu bar icon for copy progress without switching to the CopyTrust window.
- Use `Help > CopyTrust Help` any time you want the in-app startup checklist again.
- Use **Settings > Test** to validate that your current Card or Folder settings produce the expected results before running a real ingest.

## Test Harness

The built-in test harness (Settings > Test) generates controlled fixture files and runs the real copy engine to validate that naming, verification, exclusions, file prefix, and destination sort work as configured. It uses the same `IngestEngine.executeCopy` path as a real ingest — the only difference is the synthetic source files.

### Why it exists

Settings like naming templates, file prefixes, exclusion patterns, verification levels, and destination sort interact with each other. Changing one can affect outcomes in non-obvious ways. The test harness lets you confirm that your current configuration produces the expected results without needing a real camera card or waiting for a full ingest to complete.

### Opening the test tab

Open **Settings > Test**. The tab shows the current Card or Folder profile summary, scenario picker, path configuration, fixture options, and results.

### Mode picker

A **Card / Folder** segmented control at the top selects which mode profile to test. The profile summary below it shows the active settings that will be used: naming template, verification level, file prefix, exclusion status, and destination sort status. Switch modes to test each profile independently.

### Scenarios

Six test scenarios are available, each targeting a specific aspect of the copy engine:

| Scenario | What it tests |
|----------|---------------|
| **Basic Copy** | Copy with current mode settings — verifies all files arrive at the destination |
| **Naming Preservation** | Verifies `Preserve Original Folder Names` behaviour and template rendering |
| **File Prefix** | Verifies the copied file prefix template renders correctly when enabled |
| **Exclusion Pattern** | Verifies that enabled camera card exclusion patterns skip matching files |
| **Verification Levels** | Tests none / quick / full / inline verification outcomes |
| **Destination Sort** | Verifies files are sorted into type-based subfolders after copy |

Each scenario focuses on one feature but runs the full copy pipeline. MHL generation, receipts, and verification all happen as they would in a real ingest.

### Paths

- **Source root** — where the synthetic source tree is created. Defaults to the system temp directory. Click Browse to choose a different location.
- **Destination roots** — one or more destination folders where files are copied. Click the `+` button to add destinations and the `−` button to remove them.

### Fixture options

| Option | Choices | What it controls |
|--------|---------|------------------|
| **File count** | 5 / 20 / 50 | Number of synthetic files generated |
| **Mix profile** | Camera Card / Mixed Media / Document Folder | Directory structure and file types |
| **Size profile** | Tiny (1–10 KB) / Realistic (200 MB – 4 GB) / Large (1–20 GB) | Byte size of each generated file |
| **Random seed** | Any integer | Seed for reproducible file content — same seed always produces the same files |

Use **Tiny** size for quick validation runs. **Realistic** and **Large** sizes test with production-scale files but take proportionally longer.

### Mix profiles

- **Camera Card** — generates a `DCIM/` directory structure with `IMG_`, `DJI_`, `MVI_`, `DSC_`, and `CLIP_` prefixed files in `.JPG`, `.CR3`, `.MP4`, `.MOV`, `.ARW`, and `.MXF` formats. Mirrors the layout of a real camera card.
- **Mixed Media** — generates files across `images/`, `video/`, `audio/`, `docs/`, and `sidecar/` directories with a variety of photo, video, audio, document, and sidecar formats.
- **Document Folder** — generates nested directories (`reports/`, `invoices/`, `contracts/`, `notes/`, `archive/2025/`) with `.pdf`, `.xlsx`, `.docx`, `.txt`, and `.csv` files.

### Running a test

1. Select **Card** or **Folder** mode.
2. Choose a scenario.
3. Set the source and destination paths.
4. Adjust fixture options if needed (defaults are fine for a quick check).
5. Click **Run**.

Progress text updates as the test moves through fixture generation, copy, verification, and analysis. When finished, colour-coded result pills appear.

### Contextual tips

The test tab shows scenario-specific tips when relevant settings are not active:
- Running **File Prefix** with the file prefix setting disabled shows a warning that results may not reflect prefix behaviour.
- Running **Destination Sort** with sort disabled shows a warning.
- Running **Exclusion Pattern** with no active exclusion patterns shows a warning.

### Reading results

Results appear as colour-coded capsule labels:

| Pill | Green means | Red means |
|------|-------------|-----------|
| **Generated** | Fixture files created successfully | Generation failed |
| **Expected Copy** | Expected file count matches configuration | Count mismatch |
| **Excluded** | Expected excluded count matches configuration | Exclusion logic error |
| **Subfolder** | Destination subfolder name matches rendered template | Name mismatch |
| **Prefix** | Destination filenames start with the rendered prefix | Prefix not applied |
| **Verification** | All files passed hash verification | Verification failures |
| **MHL** | MHL manifest file generated | MHL missing or write failure |
| **Sorted** | Files moved to correct type-based subfolders | Sort mismatch |

Below the pills, a per-destination analysis card shows expected vs actual file counts, plus any missing, unexpected, or failed files.

### JSON reports

Every test run saves a JSON report to `~/Library/Application Support/CopyTrust/TestReports/`. Reports include the full configuration snapshot, fixture manifest, expected vs actual results, and any mismatches. Use **Reveal Report** to open the reports directory in Finder.

### Typical workflow

1. Configure your Card or Folder settings as desired.
2. Run the **Basic Copy** scenario with 5 files / Tiny to confirm the pipeline works.
3. Run **Naming Preservation** if you changed the naming template or prefix.
4. Run **File Prefix** if you enabled or changed the file prefix.
5. Run **Exclusion Pattern** if you added or modified exclusion patterns.
6. Run **Destination Sort** if you changed sort categories or folder mode.
7. When all pills are green, your settings are validated for real use.
