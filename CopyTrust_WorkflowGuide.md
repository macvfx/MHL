# CopyTrust Workflow Guide

Date: 2026-08-07
Release status: **2.5.3 stable**; **CopyTrust 2.7.2 Build 30** in testing. Build 30 makes `Start` the only blue button on screen: the **Copy** switch is orange because it is a mode, and the duplicate `Queue Current Session` button has gone from the Queued Sessions panel. Builds 25 and 29 replaced
the several relay-chain and start buttons with one **Copy** switch (Simultaneously / In series)
and one button always labelled **Start**.

This is the workflow-strategy companion to the
[full CopyTrust User Guide](CopyTrust_UserGuide.md) and the
[Illustrated Workflow Guide](CopyTrust_Illustrated_Workflow_Guide.md). Use it
for button states, direct-copy strategy, P5 archive handoff, mixed queues,
relay chains, and session lifecycle guidance.

The illustrated guide now includes a workflow atlas for:

- direct `A → B`;
- fan-out `A → B` and `A → C`;
- relay `A → B`, then verified `B → C`;
- `A → B`, then archive verified B to P5;
- fan-out to B/C with only the designated Archive Master sent to P5;
- naming, verification, sorting, artifacts, proxies, and P5 stage order;
- offline P5 request, later submission, restore, and MHL/xxHash64 verification.
- the Build 11 pre-copy topology review and durable workflow-plan/log evidence.

## Pre-Copy Workflow Review (Build 11)

Before a new session starts, CopyTrust presents the whole job rather than only
the current destination row. The top diagram distinguishes:

- one source to one destination;
- multiple sources and/or multiple destinations;
- an ordered source-to-relay chain;
- one active source/destination followed by queued work.

Every destination has its own card showing source context, queue/relay step,
verification, sorting and artifacts, plus explicit **Proxies** and **P5
Archive** states. Review all cards before continuing. A P5 or proxy choice on a
later relay stop is included; it is not mistaken for an unselected workflow.

## Current Button Names and When Each Appears

| Control | When it appears |
|--------|----------------|
| `Start` | Source and destination loaded, no copy running — always the primary blue button, and always this label. Runs whatever the `Copy` switch says. |
| `Copy: Simultaneously \| In series` | Segmented switch above the destination list, whenever two or more destinations are loaded. Disabled during a copy. |
| `Start Queue` | Queue section header: when workspace is empty and queue has items. Bottom bar: when workspace has content and queue has items (secondary style) |
| `Queue Current Session` | Source and destination loaded, not in queue manager mode |
| `Queue This Batch` | Source and destination loaded while a copy is running, not in queue manager mode |
| `Return to Queue` | A queued session is loaded but copy has not started |
| `Review & Verify` | A copy has run (use mid-session to inspect without ending) |
| `Review Summary…` | All sources are done and no copy is running |
| `End Session` | After any completed run (in the action bar). After a cancel (in the simplified cancel bar). |
| `Resume` | Post-cancel action bar (retry the copy). Also in progress sheet after cancel. |
| `Resume Queue` | Post-cancel action bar when queued batches remain |
| `Reset Session` | Visible when session has content and no copy is running; wipes everything. Hidden in cancel state. |
| `Card / Folder` | Segmented copy-mode picker (orange tint); hidden during active copy and in cancel state |
| `Preset` | Preset menu, beside the mode picker; save / load / update saved settings bundles |
| `Done` | Progress sheet after cancel, alongside Resume |
| `+ Add` (queue header) | Queue manager mode — during active copy |
| `Clear Done` | Queue manager mode — completed/failed items exist |
| `Progress` (icon only) | Bottom bar during active copy — opens the full progress sheet |
| `Cancel Copy` | Bottom bar during active copy |
| `Hide` | Progress sheet during active copy (prominent filled button) |

## Copy Modes (Card / Folder)

CopyTrust offers two copy modes accessible via a segmented control in the toolbar (orange tint to contrast with blue action buttons). These were previously called *copy type presets*; from 2.7.1 Build 14 they are the copy **mode**, and **Preset** means a saved settings bundle (see [Presets](#presets)).

| Mode | Best for | Key defaults |
|--------|----------|-------------|
| **Card** | Camera card ingest | `{alias}_{date}` naming, inline verification, contact sheet on, sort on, auto-advance on, camera card exclusions active, preserve original names on |
| **Folder** | Folder backup / archive | `{alias}` naming, quick verification, contact sheet off, sort off, auto-advance off, preserve original names on, File Storage / System / Camera Card exclusion groups |

Each mode maintains its own **independent settings profile**. Changes to Card settings never affect Folder settings and vice versa. Configure each mode's defaults in **Settings > Card Copy** and **Settings > Folder Copy**.

Switch modes before setting up a session. The mode picker is hidden during an active copy to keep the action bar clean. Individual settings remain overridable within the active mode.

## Presets

*New in 2.7.1 Build 14.* The **Preset** menu beside the mode picker saves your Card **and** Folder settings under one name and loads them back in a single action.

| Action | Effect |
|--------|--------|
| Save Current Settings as Preset… | Captures both mode profiles plus shared settings (confirm-before-copy, external codecs, ExifTool, codec extension lists, receipt export, notifications) |
| Load | Restores all of the above; a dot (•) on the menu label means settings have drifted since loading |
| Update … from Current Settings | Re-captures in place, keeping the preset's name and identity |
| Duplicate as My Preset… | Makes an editable copy of a read-only shared preset |

**Presets never change destinations.** Loading one names the destination set it expects and says whether that set exists on this Mac; you confirm the destination list yourself before copying.

Shared presets live in `/Users/Shared/CopyTrust/Presets` (read-only to the app, deployable by script or MDM before an operator's first launch); your own are saved in `~/Library/Application Support/CopyTrust/Presets`. Tool *paths*, P5 credentials, operator name and appearance are deliberately excluded so a preset stays portable between machines.

**Contact sheets on proxy/MXF cards:** the contact sheet is a background artifact (never blocks copy/verify/MHL). For cards heavy in camera proxies (`.LRF`) or professional formats (MXF/R3D), enabling **external thumbnail codecs** (Settings > External Codecs, shared) makes CopyTrust run ffmpeg/REDline per file for real thumbnails — worth it for a visual sheet, but expect noticeably longer generation. Leave **external codecs off** for a fast sheet where those files appear as "No Preview" placeholders, and leave **hide placeholders off** unless you specifically want them omitted. See the "Unsupported media, external codecs, and placeholders" section of the User Guide.

**Quick verification and artifacts (fixed in Build 6):** Quick verifies destination existence and size without creating content hashes. Contact sheet PDF, EXIF CSV, HTML tree, and destination sorting now use the separate delivered-file inventory and work normally in Quick mode. MHL remains hash-backed and is not produced by Quick mode. Artifact rows always stop at a terminal status rather than spinning after a zero-work result.

**Proxy media beta (2.6.0):** In Settings → Post-Copy → Proxy Media, optionally
choose H.264 or HEVC / H.265 and 12.5%, 25%, or 50%. The pre-copy confirmation
explicitly shows Proxy Off or the selected settings. During encoding, the UI
and active log show per-clip percentage, speed, and ETA. JSON/TXT/LOG evidence
records the choice and original/proxy metadata comparison. MOV and MXF have
real automated encode coverage; other formats depend on the packaged ffmpeg's
decoder support. Use the **Create proxies** checkbox on each destination row to
choose exactly which destinations receive proxies; several or all may be
selected.

**Proxy correctness (Build 12):** CopyTrust probes each delivered original
before encoding. Display rotation is applied before expected proxy dimensions
are calculated, while reported color range, primaries, transfer, and matrix
drive the encode. The proxy receipt retains raw/display dimensions, rotation,
and original/proxy color fields.

**Package-safe artifacts (2.6.0):** If the copied root is a macOS package such
as `Show Library.fcpbundle`, `CopyTrust_Receipts`, `CopyTrust_Proxies`, and
`Final Cut Proxy Media` are written beside the package. CopyTrust never adds
them to the package contents. Ordinary folder placement is unchanged.

**P5 archive post-copy action (2.7.0 testing):** Configure the P5 server,
archive index, client, and a non-deleting archive plan in Settings → P5
Archive. Full or Inline verification can submit one verified destination after
sorting and enabled artifacts finish. Quick or copy-only work writes a deferred
request with `needs_hash_verification` and is never automatically submitted.

**Crash-report privacy (2.7.0):** CopyTrust is configured not to capture or
transmit media paths or private information through Sentry. File/network
tracing, requests, logs, breadcrumbs, sessions, and performance telemetry are
disabled. A final on-device filter removes source/destination paths, media
filenames, P5 connection and job details, credentials, and operator/client
information before a crash or app-hang report can be uploaded.

### Per-queue-item settings snapshots

Each queued session captures a **full snapshot** of the active mode's settings at the moment it is queued. This means:
- You can queue a card copy with inline verification and contact sheet on, then switch to Folder mode, queue a folder backup with quick verification and contact sheet off — each batch runs with its own settings.
- Queue rows show a coloured mode badge (blue Card / green Folder) indicating which mode was active when the batch was staged.
- Editing mode settings after queuing does not affect already-queued items.

## Recommended Workflows

### Direct multi-destination copy
Use this for `A -> B` and `A -> C`.

1. Add one source.
2. Add one or more destinations.
3. With two or more destinations, leave the `Copy` switch on `Simultaneously` (the default).
4. Confirm preflight is clean.
5. Click `Start` and confirm the pre-copy review.
6. Use `Review & Verify` during the run if you want to inspect results without ending the session.
7. When all work is done, click `Review Summary…`, then `End Session`.

Expected result:
- the source copies directly to each loaded destination, all at the same time, reading the source once per destination
- copy, selected verification, receipts, and logs finish before the session is considered complete; Full/Inline also write a hash-backed MHL, while Quick does not
- PDF, CSV, and HTML tree artifacts can continue afterward in the background

### Verified destination to Archiware P5 (2.7.0 testing)

Use this only with expendable media and a non-deleting P5 archive plan until the
beta has passed your site acceptance tests.

1. In Settings → P5 Archive, enter the server and credentials, then click
   `Test Connection & Load`.
2. Select the archive index, P5 client, and non-deleting archive plan. Confirm
   the P5 client sees the CopyTrust destination at the same absolute path.
3. Select Full or Inline verification and enable `Archive verified copies to
   P5`. In the CopyTrust destination list, check `Archive to P5` beside the one
   destination that P5 should archive.
4. Run the copy and wait for copy, verification, MHL, sorting, and enabled
   artifacts to finish.
5. Inspect `CopyTrust_Receipts/COPYTRUST_P5_ARCHIVE_REQUEST_*.json` for the P5
   job ID/state, then confirm the job and `CT_*` fields in the P5 web GUI.

Pipeline order:

`copy → verify → MHL → sort/artifacts/proxy/provenance → P5 archive request`

P5 failure is supplementary: it leaves the successful copy result intact and
records an actionable deferred request. Restore is performed in P5; verify the
restored files against the preserved capture MHL/xxHash64 before accepting them.
For relay chains, the pre-copy check evaluates the P5 choice across all legs,
so a P5 destination on a later stop is reported without a false no-destination
warning.
Follow
[CopyTrust → P5 Restore and Hash Verification](COPYTRUST_P5_RESTORE_AND_VERIFY_WORKFLOW.md)
for the complete manual restore, reconciliation, and hash-verification procedure
and the explicitly planned coordinated workflow.

### Relay chain
Use this for `A -> B -> C` — camera card to drive to NAS.

1. Add one source (camera card).
2. Add destinations in order — **fastest drive first** (SSD before NAS).
3. Set the `Copy` switch above the destination list to `In series`. It shows the chain path and
   the reminder to put the fastest drive first.
4. Check the `Stop 1` / `Stop 2` labels. Reorder with the up/down arrows if needed.
5. Set `Archive to P5` and `Create proxies` on the rows you want them on. A new chain starts with
   P5 on the first stop and proxies on the last.
6. Click `Start`. CopyTrust builds the chain and runs it in one action, so the pre-copy review
   always appears.
7. Confirm the pre-copy review, which shows the whole chain plus one card per stop.

Once running, each leg appears in the queue panel:
```
⦿ A001 → Example SSD
A001 · Camera Card  →  Example SSD · Drive
Step 1 of 2 — copies from A001 (camera card).

⦿ Example SSD → Example NAS
Example SSD · Drive  →  Example NAS · Network
Step 2 of 2 — waits for Example SSD (drive) to be verified, then copies from it.
```
Hover any row to see exact folder paths. Right-click for `Reveal Source in Finder` or
`Reveal Destination in Finder`.

Expected result:
- `A -> B` runs first — camera card copies to the local drive and is verified
- once verified, the output of `B` becomes the source for `B -> C` — NAS copy reads from the local drive, not the card
- background PDF, CSV, and HTML tree work does not block the next relay leg
- automatic contact-sheet PDF opening does not block receipt or artifact completion
- the camera card can be ejected as soon as Step 1 is trust-complete
- **contact sheet PDF is faster for Step 2 and later:** thumbnails from Step 1 are cached and reused — no redundant preview generation for the same card content
- building the chain writes an immutable `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json` with ordered legs, queue/sequence/step IDs, dependencies, and each destination's proxy/P5 choices
- each session log identifies its active queue item and plan; the same plan is exported into every leg's `CopyTrust_Receipts` folder

### Relay workflow evidence

The workflow plan is written when the chain is authored, before any leg runs,
and is never rewritten to reflect later state. It contains no password. Session
logs add structured `workflow setup`, `workflow source`, and `workflow
destination` entries that link execution back to the plan. A newly queued chain
always receives a new sequence identity, even if its paths match a prior chain,
so stale completed rows cannot satisfy its dependencies.

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
- queue rows show a coloured mode badge (blue Card / green Folder) — each session uses its own mode

### Queue manager — staging during active copy
Use this when you want to set up the next batch while a copy is already running. The UI transforms into a compact queue manager when a copy starts (v2.4.6).

1. Start a copy. The source/destination panels transform into the **Copy Queue** manager.
2. Click **[+ Add]** in the queue header. A sheet opens with available source volumes (shown as wrapping chips, read-only volumes first) and pre-populated destinations from the running copy.
3. Select a source volume chip, adjust destinations if needed, choose a mode (Card/Folder), and click **Add to Queue**.
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
  [2] Example NAS           387 MB/s copy  |  412 MB/s verify  |  2m 21s
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
| Source and one destination in workspace | `Start` |
| Source and 2+ destinations, `Copy: Simultaneously` | `Start` (all at once) |
| Source and 2+ destinations, `Copy: In series` | `Start` (builds the chain and runs it) |
| Sessions staged in the queue | `Start Queue` |
| Specific queued leg loaded via Load | `Start` (runs that leg only) |

The primary button is always `Start`. Before Build 29 the label changed with the job
(`Start This Session`, `Copy to Both Now`, `Start Relay Chain`, `Start Loaded Session`); the
`Copy` switch and the pre-copy review now carry that information instead.

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
| `Start` | Run this leg now |
| `Return to Queue` | Put the leg back in the queue, clear the workspace, queue intact |
| `Reset Session` | Wipe the workspace AND the entire queue |

**Reset Session is always destructive and always wipes everything — use Return to Queue if you just want to un-load.**

## Fixing a Wrong-Order Relay Chain

If you built a relay chain with destinations in the wrong order (e.g. NAS before SSD), click `Edit` on any leg in the queue panel. This removes all legs of that chain and returns the source and destinations to the workspace in their original order. Reorder the destinations using the up/down arrows in the destination panel, confirm the `Copy` switch still reads `In series`, then click `Start` again.

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
4. Failed artifacts (contact sheet, CSV, HTML tree) are retried.

If auto-resume does not trigger, use `Start` manually — the resume infrastructure will detect partial progress and skip verified files.

### Pre-copy check

Before scanning begins, all destination volumes are verified as reachable. If a destination disappeared between setup and start, the copy is blocked upfront.

## macOS Notifications (v2.4.4)

CopyTrust posts native macOS notifications for: copy complete, copy failed, volume disconnect/reconnect, auto-resume, verification, and artifact completion/failure.

Open **Settings > Notifications** to toggle each event. Use **Send Test Notification** to verify system permissions.

If notifications do not appear, check **System Settings > Notifications > CopyTrust**.

## Built-in Test Harness (v2.4.7)

Open **Settings > Test** to validate that your Card or Folder settings produce the expected copy results without needing a real camera card. The harness generates synthetic fixture files and runs the real copy engine, then compares expected vs actual outcomes.

Seven scenarios cover basic copy, naming preservation, file prefix, custom exclusion patterns, known folder/file exclusion matching, verification levels, and destination sort. Results are shown as colour-coded pills (green = pass, red = fail) with per-destination analysis. JSON reports are saved to `~/Library/Application Support/CopyTrust/TestReports/`.

See the [CopyTrust User Guide](CopyTrust_UserGuide.md#test-harness) for full details.
