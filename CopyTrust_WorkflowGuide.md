# CopyTrust User Guide

Date: 2026-05-23  
Current branch baseline: `v2.4.7 (Build 1)`

This file is a short landing page for the current CopyTrust workflow.

## Current Button Names and When Each Appears

| Button | When it appears |
|--------|----------------|
| `Start This Session` | Source and destination loaded, no copy running (always the primary blue button for direct start) |
| `Start Queue` | Queue section header: when workspace is empty and queue has items. Bottom bar: when workspace has content and queue has items (secondary style) |
| `Queue Current Session` | Source and destination loaded, not in queue manager mode |
| `Queue This Batch` | Source and destination loaded while a copy is running, not in queue manager mode |
| `Queue Relay Chain` | One source and two or more destinations loaded |
| `Return to Queue` | A queued session is loaded but copy has not started |
| `Review & Verify` | A copy has run (use mid-session to inspect without ending) |
| `Review Summary…` | All sources are done and no copy is running |
| `End Session` | After any completed run (in the action bar). After a cancel (in the simplified cancel bar). |
| `Resume` | Post-cancel action bar (retry the copy). Also in progress sheet after cancel. |
| `Resume Queue` | Post-cancel action bar when queued batches remain |
| `Reset Session` | Visible when session has content and no copy is running; wipes everything. Hidden in cancel state. |
| `Card / Folder` | Segmented preset picker (orange tint); hidden during active copy and in cancel state |
| `Done` | Progress sheet after cancel, alongside Resume |
| `+ Add` (queue header) | Queue manager mode — during active copy |
| `Clear Done` | Queue manager mode — completed/failed items exist |
| `Progress` (icon only) | Bottom bar during active copy — opens the full progress sheet |
| `Cancel Copy` | Bottom bar during active copy |
| `Hide` | Progress sheet during active copy (prominent filled button) |

## Copy Type Presets

CopyTrust offers two copy type presets accessible via a segmented control in the toolbar (orange tint to contrast with blue action buttons):

| Preset | Best for | Key defaults |
|--------|----------|-------------|
| **Card** | Camera card ingest | `{alias}_{date}` naming, inline verification, contact sheet on, sort on, auto-advance on, camera card exclusions active, preserve original names on |
| **Folder** | Folder backup / archive | `{alias}` naming, quick verification, contact sheet off, sort off, auto-advance off, preserve original names on |

Each mode maintains its own **independent settings profile**. Changes to Card settings never affect Folder settings and vice versa. Configure each mode's defaults in **Settings > Card Copy** and **Settings > Folder Copy**.

Switch presets before setting up a session. The preset picker is hidden during an active copy to keep the action bar clean. Individual settings remain overridable within the active mode.

### Per-queue-item settings snapshots

Each queued session captures a **full snapshot** of the active mode's settings at the moment it is queued. This means:
- You can queue a card copy with inline verification and contact sheet on, then switch to Folder mode, queue a folder backup with quick verification and contact sheet off — each batch runs with its own settings.
- Queue rows show a coloured preset badge (blue Card / green Folder) indicating which mode was active when the batch was staged.
- Editing mode settings after queuing does not affect already-queued items.

## Recommended Workflows

### Direct multi-destination copy
Use this for `A -> B` and `A -> C`.

1. Add one source.
2. Add one or more destinations.
3. Confirm preflight is clean.
4. Click `Start This Session`.
5. Use `Review & Verify` during the run if you want to inspect results without ending the session.
6. When all work is done, click `Review Summary…`, then `End Session`.

Expected result:
- the source copies directly to each loaded destination
- copy, verification, MHL, receipts, and logs finish before the session is considered trust-complete
- PDF and CSV artifacts can continue afterward in the background

### Relay chain
Use this for `A -> B -> C` — camera card to drive to NAS.

1. Add one source (camera card).
2. Add destinations in order — **fastest drive first** (SSD before NAS).
3. A blue callout appears in the destination panel showing the chain path and the `Queue Relay Chain` button.
4. Check the `Stop 1` / `Stop 2` labels. Reorder with the up/down arrows if needed.
5. Click `Queue Relay Chain` in the callout, or right-click any destination row → **Queue Relay Chain**.
6. Review the queued sessions panel before clicking Start Queue. Each leg shows:
   ```
   ⦿ A001 → Samsung T7
   A001 · Camera Card  →  Samsung T7 · Drive
   Step 1 of 2 — copies from A001 (camera card).

   ⦿ Samsung T7 → Synology NAS
   Samsung T7 · Drive  →  Synology NAS · Network
   Step 2 of 2 — waits for Samsung T7 (drive) to be verified, then copies from it.
   ```
   Hover any row to see exact folder paths. Right-click for `Reveal Source in Finder` or `Reveal Destination in Finder`.
7. Click `Start Queue`.

Expected result:
- `A -> B` runs first — camera card copies to the local drive and is verified
- once verified, the output of `B` becomes the source for `B -> C` — NAS copy reads from the local drive, not the card
- background PDF and CSV work does not block the next relay leg
- automatic contact-sheet PDF opening does not block receipt or artifact completion
- the camera card can be ejected as soon as Step 1 is trust-complete
- **contact sheet PDF is faster for Step 2 and later:** thumbnails from Step 1 are cached and reused — no redundant preview generation for the same card content

### Mixed queued sessions
Use this when different cards need different destination sets.

1. Build one source/destination setup.
2. Click `Queue Current Session`.
3. Build the next setup.
4. Click `Queue Current Session` again.
5. Reorder queued rows with the queue arrows if needed.
6. Click `Start Queue`.

Expected result:
- each queued row runs in visible queue order
- a standalone queued row can be moved ahead of or between relay-chain rows if you intentionally reorder it
- trust-critical copy work finishes before the next queued session starts
- queue rows show a coloured preset badge (blue Card / green Folder) — each session uses its own preset

### Queue manager — staging during active copy
Use this when you want to set up the next batch while a copy is already running. The UI transforms into a compact queue manager when a copy starts (v2.4.6).

1. Start a copy. The source/destination panels transform into the **Copy Queue** manager.
2. Click **[+ Add]** in the queue header. A sheet opens with available source volumes (shown as wrapping chips, read-only volumes first) and pre-populated destinations from the running copy.
3. Select a source volume chip, adjust destinations if needed, choose a preset (Card/Folder), and click **Add to Queue**.
4. Alternatively, drag a volume from Available Volumes onto the drop target strip at the bottom of the queue.
5. Repeat to stage more batches if needed.
6. Click the running row to expand inline progress (per-destination bars, speed, ETA, recent files).

Expected result:
- the currently-running copy is not interrupted
- staged batches auto-advance after the current copy completes (with auto-advance on), including batches added via [+ Add] during a direct-start copy
- destinations default to the same ones the running copy uses
- completed items older than 24 hours auto-prune on app launch; use "Clear Done" for immediate cleanup

### After cancelling a copy with queued batches

If you cancel a copy and queued batches remain, the action bar simplifies to:
- **Resume** — retry the cancelled copy
- **Resume Queue** — start the remaining queued batches without retrying the cancelled one
- **End Session** — close the session and save partial results

Review Summary, Reveal Receipts, Reveal Log, and Reveal Manifest are accessible from the **File menu** at any time.

## Receipt Speed Summary

Every session receipt now includes a `COPY SPEED SUMMARY` block showing average copy speed and verify speed per destination, making the performance of each leg immediately readable without digging through the detailed timing lines.

For a relay-chain session the summary makes the strategy legible at a glance:

```
COPY SPEED SUMMARY
  [1] MacBook Pro SSD       218 MB/s copy  |  387 MB/s verify  |  4m 32s
  [2] Synology NAS          387 MB/s copy  |  412 MB/s verify  |  2m 21s
  --------------------------------------------------
  Session total: 265.7 GB in 6m 53s  (avg 654 MB/s across all legs)
```

This shows directly why the relay strategy works: offloading from the camera card to a fast local SSD first frees the card faster, and the slower NAS copy then reads from the already-verified local copy rather than the original card.

The JSON receipt also stores `averageCopySpeedBytesPerSecond` and `averageVerifySpeedBytesPerSecond` as explicit fields per destination, so speed data is machine-readable without recalculating from duration and byte count.

## Reviewing Queued Sessions Before Running

Click the `›` chevron on any queued row to expand it inline. Shows source name, type, and path (read-only) and destination name, type, and path with an editable alias field. No workspace change. Multiple rows can be expanded simultaneously.

- Edit a destination alias directly in the expanded row — no need to Load.
- Hover any row for a path tooltip. Right-click any row for `Reveal Source in Finder` / `Reveal Destination in Finder`.

The `Load` button is for running a specific leg out of queue order. For editing and inspection, use the `›` expand panel — it does not disturb the workspace.

## Start, Stop, Continue, and Reset

### Starting a copy

| Situation | Button |
|-----------|--------|
| Source and destination in workspace | `Start This Session` |
| Sessions staged in the queue | `Start Queue` |
| Specific queued leg loaded via Load | `Start This Session` (runs that leg only) |

### During a running copy

| Situation | Button |
|-----------|--------|
| Open the full progress sheet | `Progress` (icon-only, bottom bar) |
| Hide the progress sheet, keep copying | `Hide` (in progress sheet) |
| Inspect results mid-run | `Review & Verify` (main window) |
| Stop the copy | `Cancel Copy` (bottom bar or progress sheet) |
| See live speed | Speed badge in the bottom bar |

The action bar during copy is streamlined: Reset Session, Card/Folder picker, and Preflight badge are hidden. The running row in the queue manager shows inline progress.

### After a cancel — progress sheet

| Situation | Button |
|-----------|--------|
| Resume from where it stopped after cancel or recoverable partial failure | `Resume` |
| Dismiss and return to main window | `Done` |

### After a cancel — main window

The action bar simplifies to just two (or three) buttons:

```
[ Resume ]  [ Resume Queue ]  ...  "Session cancelled — resume or end?"  ...  [ End Session ]
  primary      if queued                    status label                         secondary
```

- **Resume** — retry the copy from where it stopped
- **Resume Queue** — appears when queued batches remain; starts the remaining queue
- **End Session** — close the session and save partial results

All other controls (Reset Session, Card/Folder picker, Preflight, Auto toggle, naming preview, Reveal buttons) are hidden. Review Summary and Reveal actions are accessible from the **File menu**.

### After a completed run — main window

```
[ Review Summary ]  ...  "Copy complete"  ...  [ End Session ]
     primary ●                                    secondary
```

- **Review Summary** (blue) — open the session summary sheet; `End Session` is also inside it
- **End Session** — close directly without opening the summary sheet

All other controls (Reset Session, Card/Folder picker, Preflight, Queue, naming preview, Start) are hidden. Reset and Start become available after ending the session.

### Loaded session — queue management

When a queued session is loaded via `Load`:

| Button | What it does |
|--------|-------------|
| `Start This Session` | Run this leg now |
| `Return to Queue` | Put the leg back in the queue, clear the workspace, queue intact |
| `Reset Session` | Wipe the workspace AND the entire queue |

**Reset Session is always destructive and always wipes everything — use Return to Queue if you just want to un-load.**

## Fixing a Wrong-Order Relay Chain

If you queued a relay chain with destinations in the wrong order (e.g. NAS before SSD), click `Edit` on any leg in the queue panel. This removes all legs of that chain and returns the source and destinations to the workspace in their original order. Reorder the destinations using the up/down arrows in the destination panel, then click `Queue Relay Chain` again.

`Edit` is only available while all legs are still pending — it is disabled once the chain has started running.

## End Of Run

Two exit paths are available from the main window after any run completes or is cancelled:

**Quick exit — no summary sheet required:**
Click `End Session` in the action bar. The session closes, results are saved, and the workspace clears. Use this when you are confident the run is good and just want to move on.

**Review first:**
Click `Review Summary` (after a completed run) to open the summary sheet, then click `End Session` from inside.

After a completed run, the action bar shows only `Review Summary` and `End Session` with a "Copy complete" label. After a cancelled run, the bar shows `Resume` and `End Session` with a "Session cancelled — resume or end?" label.

Summary sheet actions (if you open it):
- `Copy`
- `Reveal Summary`
- `Manifest`
- `Log`
- `End Session`
- `End` / `Wait` when background artifacts are still running

After `End Session`, use the main UI for:
- `Review Last Summary…`
- `Reveal Receipts`
- `Reveal Log`
- `Reveal Manifest`
- `Reset Session`

The main workspace is cleared at session end, so use those review buttons instead of expecting the previous sources or destinations to remain loaded.

## Volume Disconnect Recovery (v2.4.4)

CopyTrust now monitors destination volumes in real time. If a destination drive or NAS disconnects:

1. The active copy is cancelled immediately with a clear message.
2. The Start button is blocked until the volume returns.
3. When the volume remounts, the copy resumes automatically — verified files are skipped.
4. Failed artifacts (contact sheet, CSV) are retried.

If auto-resume does not trigger, use `Start This Session` manually — the resume infrastructure will detect partial progress and skip verified files.

### Pre-copy check

Before scanning begins, all destination volumes are verified as reachable. If a destination disappeared between setup and start, the copy is blocked upfront.

## macOS Notifications (v2.4.4)

CopyTrust posts native macOS notifications for: copy complete, copy failed, volume disconnect/reconnect, auto-resume, verification, and artifact completion/failure.

Open **Settings > Notifications** to toggle each event. Use **Send Test Notification** to verify system permissions.

If notifications do not appear, check **System Settings > Notifications > CopyTrust**.

## Built-in Test Harness (v2.4.7)

Open **Settings > Test** to validate that your Card or Folder settings produce the expected copy results without needing a real camera card. The harness generates synthetic fixture files and runs the real copy engine, then compares expected vs actual outcomes.

Six scenarios cover basic copy, naming preservation, file prefix, exclusion patterns, verification levels, and destination sort. Results are shown as colour-coded pills (green = pass, red = fail) with per-destination analysis. JSON reports are saved to `~/Library/Application Support/CopyTrust/TestReports/`.

See the [CopyTrust User Guide](COPYTRUST_USER_GUIDE.md#test-harness) for full details.
