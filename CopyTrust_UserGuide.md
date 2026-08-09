# CopyTrust User Guide

Date: 2026-08-09
Release status: **2.5.3 stable**; **2.7.2 Build 32** in testing.
Version history is in the release notes.

## Purpose

CopyTrust supports more than one real ingest workflow. The app is strongest when the operator can choose the simplest safe pattern for the job instead of forcing every case into one queue model.

This guide describes the main ways to use the app today and when each method makes sense.

## Core Mental Model

- A **source** is a camera card or upstream verified copy.
- A **destination** is where CopyTrust writes the copy.
- In a normal session, **every loaded source copies to every loaded destination**.
- With **two or more destinations**, a **Copy** switch appears above the destination list with
  one decision on it: **Simultaneously** or **In series**. That switch is the only thing that
  chooses between a fan-out and a relay chain.
- There is **one Start button**, always labelled `Start`. It runs whatever the Copy switch says,
  and always shows the pre-copy review first.
- A **relay chain** (`In series`) means the verified output from one destination becomes the
  source for the next step. The source is read **once**.
- A **fan-out** (`Simultaneously`) copies to every destination at the same time. The source is
  read **once per destination**.
- `Queue Current Session` saves the current setup and clears the workspace so another setup can be staged.
- `Start Queue` runs queued sessions in order.
- Before a new run begins, the **workflow review** shows the overall topology and one card per destination, including that destination's proxy and P5 choices.
- A queued relay chain writes an immutable, password-free `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json` that binds its ordered legs, dependencies, and destination choices.

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
- add one source and two destinations, in the order you want them copied
- set the `Copy` switch to `In series` for an ordered `A -> B -> C` path
- set `Archive to P5` and `Create proxies` on the intended destination rows
- leave this out of the way unless the session actually calls for relay copy

## Workflow Summary

| Method | Best for | Current status | Recommended setup |
| --- | --- | --- | --- |
| Method 1: One card to multiple destinations | Safe dual-copy ingest such as `A -> B` and `A -> C` | Implemented | One live session, two or more destinations, `Copy: Simultaneously`, then `Start` |
| Method 2: Relay chain | Fast first copy, then slower downstream copy such as `A -> B -> C` | Implemented | One source plus ordered destinations, `Copy: In series`, then `Start` |
| Method 3: Mixed queued sessions | Different cards going to different destination sets in walk-away order | Implemented | Separate queued sessions, then `Start Queue` |

Methods 1 and 2 are the same three steps — add the card, add the destinations, press `Start`.
The only difference is which side of the `Copy` switch is selected.

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
4. Leave the `Copy` switch on `Simultaneously` (the default).
5. Click `Start`, then confirm the pre-copy review.

What CopyTrust does:
- it treats this as one ingest session
- source `A` copies to both `B` and `C` at the same time, reading the card once per destination
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
3. Set the `Copy` switch above the destination list to **In series**. It shows the chain path,
   e.g. `Card A → SSD → NAS`, and a line explaining that the source is read once.
4. Check the `Stop 1` / `Stop 2` labels on each destination row. Reorder with the up/down arrows
   if needed — **put the fastest drive first**.
5. Check `Archive to P5` and `Create proxies` on the rows you want them on. A new chain starts
   with P5 on the first stop and proxies on the last — camera archive first, editing storage
   last. Everything stays adjustable on the destination rows afterwards.
6. Click `Start`.
7. Confirm the pre-copy review. It shows the full chain and one card per stop.

CopyTrust builds the queued chain and starts it as a single action, so **a relay chain always
shows the pre-copy review**. There is no separate queue-then-start step.

Speed ordering tip:
- Copy to your **fastest destination first** (SSD before NAS). This frees the camera card sooner and lets the slower NAS leg run from a local verified copy, not from the card itself.
- The `In series` side of the Copy switch reminds you of this.

What CopyTrust does:
- Step 1 copies from the original camera card to the first destination and verifies it.
- Step 2 waits for the verified output from Step 1, then copies from that verified folder — not the card.
- Later steps continue in the same way.
- PDF/CSV artifact work from Step 1 does not block Step 2.
- The end-session receipt summarises the full relay run with per-leg speed data.
- **Contact sheet PDF generation is faster for relay chains:** thumbnails generated for the first destination are cached on disk and reused for every subsequent leg — no redundant preview work for the same card content.
- when the chain is built, it writes one immutable workflow plan with the sequence ID, ordered destinations, step IDs, dependencies, verification/artifact settings, and explicit per-destination proxy/P5 choices
- every relay session log identifies its active queue item and links back to that plan; the plan is exported beside each leg's receipts

What the queue panel shows once the chain is running:

Each relay leg appears as a distinct row with a chain icon prefix and blue tint. For a card-to-SSD-to-NAS relay the operator sees:

**Step 1 row:**
```
⦿ A001 → Example SSD
A001 · Camera Card  →  Example SSD · Drive
Step 1 of 2 — copies from A001 (camera card).
```

**Step 2 row:**
```
⦿ Example SSD → Example NAS
Example SSD · Drive  →  Example NAS · Network
Step 2 of 2 — waits for Example SSD (drive) to be verified, then copies from it.
```

Hovering over either row shows the exact folder paths:
```
Source: /Volumes/A001
Destination: /Volumes/Example_SSD/Ingest/Example_Project
```

Right-clicking a queue row offers:
- **Reveal Source in Finder** — opens the source volume or folder directly
- **Reveal Destination in Finder** — opens the destination folder directly

Right-click on destination rows:
- The context menu offers **Reveal in Finder** and **Remove Destination** for any destination at
  any time. It no longer carries a relay-chain action — the `Copy` switch is the one place that
  choice is made.

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
  [2] Example NAS           387 MB/s copy  |  412 MB/s verify  |  2m 21s
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
- `Start Queue` remains latched until the runnable list finishes; a queued
  Card/Folder profile with Auto Advance off does not stop an explicit queue run
- trust-critical work for one session finishes before the next queued session starts
- background artifact work can continue afterward without blocking the next queued session
- completed rows distinguish copy completion, artifacts, P5 archive, post-copy
  issues, and full completion
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

### Inline expand — recommended

Click the `›` chevron at the left edge of any queued row to expand a detail panel inline. No workspace change, no reset needed. Multiple rows can be expanded at once — useful for reviewing both legs of a relay chain side by side.

The expanded panel shows:

| | |
|---|---|
| 📷 `A001` | `Camera Card` · `/Volumes/A001` · Reveal |
| 💾 `[Example SSD ]` | `Drive` · `/Volumes/Example_SSD/Ingest/Example_Project` · Reveal |

- **Source rows** are read-only: name, type, path, Reveal in Finder.
- **Destination rows** have an editable alias field — rename a destination without loading the session into the workspace. Changes take effect immediately on the queued item.
- **Reveal** buttons open the exact source or destination folder in Finder.

Hover over any queued row to see the full source and destination paths as a tooltip. Right-click any queued row for `Reveal Source in Finder` and `Reveal Destination in Finder`.

### Load button — for running a specific leg out of queue order

The `Load` button fills the workspace with a queued session's source and destination. Use it when you want to run a specific leg independently rather than using `Start Queue`.

- After loading, press `Start` to run it.
- To put it back without running, click `Return to Queue` — this restores the session to `.queued` status and clears the workspace without touching any other queued items.
- `Reset Session` wipes the entire queue and workspace. Use it only when you want to start completely fresh.
- `Queue Current Session` is hidden while a session is loaded — this prevents accidentally enqueuing a duplicate.
- Load is one-at-a-time: the button is disabled if another session is already loaded or a copy is running.

For inspection and alias editing, prefer the `›` expand panel — it does not disturb the workspace.

## Session Lifecycle — Start, Stop, Continue, Reset

### Starting

| Situation | Button |
|-----------|--------|
| Source and one destination in workspace | `Start` |
| Source and two or more destinations, `Copy: Simultaneously` | `Start` (all at once) |
| Source and two or more destinations, `Copy: In series` | `Start` (builds the chain and runs it) |
| Sessions staged in the queue | `Start Queue` |
| A specific queued leg loaded via Load | `Start` (runs that leg only) |

The primary button is always labelled `Start`. It previously changed with the job
(`Start This Session`, `Copy to Both Now`, `Start Relay Chain`, `Start Loaded Session`), which
read as four different buttons. What `Start` will do is stated by the `Copy` switch above it and
confirmed in the pre-copy review.

**Pre-copy workflow review.** Because dragging a card in auto-selects
the copy mode, it is easy to start a card in Folder mode by accident — which
uses Quick verification and skips the contact sheet. To catch this, a
review appears when you start a copy. Its top-level diagram distinguishes a
single direct copy, multi-source/multi-destination fan-out, an ordered relay
chain, or one active copy followed by queued work. A separate card for every
destination identifies its source context, queue/relay step, verification,
sorting, artifacts, and explicit **Proxies** and **P5 Archive** states. Proxy
and P5 choices are evaluated across the complete relay sequence, including a
choice that exists only on a later stop.

The review also summarizes the active **mode** (Card / Folder), **verification
level**, enabled **artifacts**, **destination sort**, and **contact-sheet split**.
Click **Continue** to proceed or **Cancel**
to fix the settings first. It appears only when you start a new session — an
auto-advanced next card or a resumed copy is never interrupted. Turn it off (or
back on) in **Settings → Post-Copy → Before Copy**, or tick "Don't ask again" in
the sheet itself.

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
| `Start` | Runs the loaded leg; removes it from queue on completion |
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

If two pending sources would render to the same destination subfolder name (e.g. both use the same naming template and resolve to `Example_Project/A001`), `Start` is blocked. The blocked-start message tells the operator which sources conflict and points to the source alias, prefix, or naming template as the fix path.

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

If auto-resume does not trigger (e.g. the source was removed or the session was ended), you can still use `Start` to restart manually. The resume infrastructure will detect the partial manifest and skip verified files.

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

### Where to see the Session Health verdict

After every copy, CopyTrust classifies the results into a plain-language **Session Health** report:

- **Session Summary sheet** — a Session Health card per source → destination with a status badge (green Clean / orange Warnings only / red Action required), a summary sentence, warnings and action items grouped by category (click to expand the file list and explanation), and recommendations.
- **Receipt TXT** — a `Health:` verdict block per destination; every `MISMATCH:` line is annotated with its classification; transient skips are listed as `TRANSIENT:` lines.
- **Receipt JSON** — per-destination `healthReport` object plus `transientFiles` and per-mismatch `classification`.
- **Session log** — one `healthReport` line per destination with status and counts.

### Session finished with warnings — "N transient files skipped"

New in v2.5.0. When copying live editing projects (especially Final Cut Pro libraries), some files routinely vanish between the scan and the copy. These are recorded as **transient skips** instead of errors, and the session ends as `completed_with_warnings` rather than `completed_with_errors`. Every skipped file is listed in the session manifest (`transientFiles`), so the archive record stays complete — review the list to confirm nothing you care about was skipped.

**macOS sandbox temp files** (`name.sb-XXXXXXXX-XXXXXX`, created by FCP/Motion during editing) are handled differently as of **v2.5.5**: they are treated like any other exclusion pattern — skipped silently at scan time, never copied, and **not** listed as transient skips or shown in the Session Health report. The count is noted once in the session log (`excluded N macOS sandbox temp file(s) (.sb-*)`) and nowhere else, so they no longer add noise to your warnings.

Real problems are never downgraded: a disconnected source volume, a destination write failure, or a hash mismatch still reports as a real error.

A related FCP note: the *Original Media* folder inside a project `.fcpbundle` is almost always symlinks — often broken ones pointing at old storage or a media transport drive. The real original media nearly always lives outside the bundle in the project folder structure, which CopyTrust archives directly.

### A mismatch was reported — is my copy corrupt?

New in v2.5.0: every size or hash mismatch now gets its own log line. Quick verify logs a three-way comparison — `scanSize` (when the source was scanned), `destSize` (what was copied), and `sourceNowSize` (the source right now):

- **"source changed during session"** — the destination matches the source's current size. The file changed after the scan (normal for live FCP bundles); the copy is faithful.
- **"UNEXPLAINED"** — the destination matches neither the scan-time nor the current source. Investigate: re-run the copy for that file or run a full-hash verify.

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

1. **Workflow review and pre-copy checks** — topology, per-destination choices, destination reachability, free space, and subfolder collisions
2. **File scan** — enumerate source files, apply exclusion patterns
3. **Copy + Inline Verify** — write files to all destinations; with inline verification (the default), each file is hashed at the source during copy, then immediately hashed at the destination and compared — pass/fail feedback appears per-file during this phase
4. **Batch Verify** — if using Full (batch) verification instead of inline, all destination files are re-hashed and compared after the copy phase completes
5. **MHL (Full/Inline only)** — write an MHL v1.1 manifest from hash-backed entries; Quick intentionally skips MHL
6. **Receipt + Log** — write per-copy receipt and session log
7. **Sort** — reorganize files into type folders (if enabled)
8. **Contact sheet PDF + EXIF CSV + HTML tree** — descriptive artifacts run concurrently (when enabled)
9. **Proxy media** — starts after the descriptive artifacts so encoding does not starve them
10. **P5 archive** — submits the destination with **Archive to P5** checked after enabled artifacts finish

Steps 1–6 are trust-critical for the selected verification level. Steps 7–10
are background work that does not block the next queued session. End Session
waits for that background work unless the operator explicitly stops it. An
artifact or P5 failure does not change the already sealed copy/verification
verdict.

### Workflow plan and log evidence

When a relay chain is queued, CopyTrust writes
`CopyTrust/workflow-plans/COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json`. This is
an immutable record of the operator's queued intent: sources, ordered
destinations, queue and sequence identifiers, step dependencies, verification
and post-copy settings, and each destination's explicit proxy/P5 selections.
It contains non-secret P5 configuration only; passwords are never written.

Each leg's session log records a structured `workflow setup`, `workflow source`,
and `workflow destination` block. It also identifies the active queue item,
sequence step, dependency, and workflow-plan path. A copy of the plan is placed
in that leg's `CopyTrust_Receipts` folder so exported evidence remains linked
to the run that consumed it. A later relay with matching paths receives a new
sequence ID and cannot silently reuse rows from the earlier chain.

With inline verification (step 3), the separate batch verify phase (step 4) is skipped — verification completes as part of the copy. This means trust-complete status is reached sooner.

## Verify Diagnostics

Before verification hashing begins, CopyTrust logs a structured diagnostic showing file count, byte count, reused files, and whether any prior copy failures or skipped files already exist. This provides context that was previously only reconstructable by replaying the full session log.

If verification aborts, the abort path now logs the exact stage (source hashing vs destination hashing) and the file path that triggered the failure, instead of collapsing into a vague terminal error. JSON and plaintext receipts preserve failed/skipped file counts and the first recorded error line for post-run analysis.

## Hidden Files

Settings → Card Copy (or Folder Copy) → Hidden Files → **Skip hidden files and folders** controls whether dot-prefixed files and directories (e.g. `.git`, `.ssh`, `.Trash`) are included in copies. Enabled by default. Card and Folder modes store this setting independently.

## Exclusions (Card and Folder)

Both Settings → Card Copy → Exclusions and Settings → Folder Copy → Exclusions use the **same grouped editor**: pattern groups (**File Storage**, **System**, **Camera Card**, **Custom**) with per-pattern checkboxes, an All/None toggle per group, and an active count. Card and Folder modes store their checkbox states independently.

System group patterns: `.Spotlight-V100`, `.fseventsd`, `.DocumentRevisions-V100`, `.TemporaryItems`, `.Trashes`, `__MACOSX`, `@eaDir` (Example NAS), `System Volume Information` (Windows). File Storage covers `.DS_Store`, `Thumbs.db`, and the generated CopyTrust / Drop Verify artifacts (`CopyTrust_Receipts`, `Drop Verify_Receipts`, `receipt_` files, `.mhl` manifests). Camera Card covers `THMBNL`, `MISC`, `BACKUP`, `CLIPINF`, `.THM`, `.LRV`, `.SCR`, `.db`, `.Db`.

Defaults differ by mode:
- **Card mode (fresh profiles): every pattern starts unchecked** — card ingests archive everything unless you opt in to exclusions.
- **Folder mode**: File Storage and System patterns start enabled; Camera Card patterns start disabled.
- Upgrading from an earlier version keeps your saved checkbox states in both modes.

No pattern is silently forced on during copy — what you see checked is exactly what is excluded. Drop Verify exposes the same Camera Card pattern set in its own Exclusions tab, with its own independent checkbox states.

### Custom patterns

The add row at the bottom of the editor takes a pattern, a match type, and a target group. **Also add to Card/Folder mode** adds the same pattern to the other mode's list in one step. Custom patterns can be deleted (trash button); built-in patterns can be unchecked but not deleted.

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

## Archiware P5 Archive (Testing)

CopyTrust can hand one verified destination to an Archiware P5 archive plan
after the copy trust chain and enabled post-copy work finish. This is opt-in, and
remains in controlled testing before production use.

See the [Illustrated Workflow Guide](CopyTrust_Illustrated_Workflow_Guide.md)
for direct, fan-out, relay, Archive Master, offline handoff, and restore
topology charts.

### Configure P5

1. Open **Settings → P5 Archive**.
2. Enter the P5 host or IP address, REST port, API version (normally `v1`), and
   username.
3. Enter the password and click **Save Password**. It is stored in the macOS
   Keychain, not UserDefaults or an archive request file.
4. Click **Test Connection & Load**.
5. Select the live **Archive Index**, **P5 Client**, and **Archive Plan**.
6. Confirm that the selected P5 client can access the CopyTrust destination at
   exactly the same absolute path.
7. In the CopyTrust job, check **Archive to P5** beside the one destination P5
   should archive. Selecting another destination clears the previous selection.
8. Turn on **Archive verified copies to P5** only when the destination and P5 selections are
   correct.

CopyTrust labels and refuses any plan whose P5 details say it deletes source
files. Use a non-deleting archive plan for camera originals.

### What is submitted

Automatic P5 submission requires a destination with successful hash
verification and a valid xxHash64 for every file. Inline and Full verification
can satisfy this. Quick and None/copy-only modes cannot: CopyTrust does not
invent hashes or describe them as MHL-verified.

Before submission, CopyTrust additively creates these P5 archive-index keys so
they are visible and searchable in the P5 web GUI:

| P5 key | GUI label | Value |
| --- | --- | --- |
| `CT_ASSET` | CT Asset | Stable CopyTrust result identifier |
| `CT_XXH64` | CT xxHash64 | Original verified/MHL xxHash64 |
| `CT_FRAME` | Frame Size | Video frame or still-image dimensions |
| `CT_KIND` | Media Kind | image, video, media, or file |
| `CT_CODEC` | Codec | Reported video codec |
| `CT_FPS` | Frame Rate | Reported frame rate |
| `CT_TC` | Start TC | Reported starting timecode |
| `CT_REEL` | Reel | Reported reel or clip basename |
| `CT_CARD` | Source Card | CopyTrust source alias |
| `CT_CAMERA` | Camera | Reported camera make/model |
| `CT_DATE` | Capture Date | Reported capture date |
| `CT_STATE` | CT State | `verified` or `needs_hash_verification` |

Detailed EXIF, contact sheets, MHL, provenance, proxy evidence, and normal
CopyTrust receipts stay as files beside the originals and are included as
`supporting_evidence` paths in the same P5 request. The P5 fields on originals
remain bounded and useful for operator search.

### Multi-destination output policy

For a normal multi-destination copy, CopyTrust generates each enabled contact
sheet, EXIF CSV, and HTML tree independently on every eligible destination.
Proxy output is destination-specific: use **Create proxies** on each destination
row to send proxies to one destination, several destinations, all destinations,
or none. The global Post-Copy proxy setting still controls codec, frame size,
Final Cut folder layout, and whether proxy generation is enabled at all.

P5 is intentionally narrower: it selects exactly one successfully verified
destination using the **Archive to P5** checkbox on that destination row. The
selection is retained in destination sets and captured with queued jobs.
Other destinations remain ordinary verified copies and are not submitted to P5
by that job.

For a relay chain, the pre-copy confirmation reviews the P5 selection across
the complete chain. A first leg therefore identifies a P5 destination selected
on a later relay stop instead of incorrectly warning that no destination was
selected.

### Offline or unconfigured P5

Keep **Always write a deferred P5 request JSON** enabled. The selected
**Archive to P5** destination then receives:

`CopyTrust_Receipts/COPYTRUST_P5_ARCHIVE_REQUEST_<source>_<timestamp>.json`

The file contains exact local paths, sizes, hashes, P5 metadata, server target
hints, archive job ID, and state. It never contains the P5 password. If P5 is
offline or incomplete, the verified copy remains successful and the JSON
explains what is required next.

The `copytrust-p5-archive.py` helper below is distributed with the CopyTrust
source, not with these docs. Validate the request without changing P5:

```bash
copytrust-p5-archive.py \
  "/path/to/COPYTRUST_P5_ARCHIVE_REQUEST_A001_20260729_120000.json"
```

Submit only after reviewing the dry run:

```bash
copytrust-p5-archive.py --submit \
  "/path/to/COPYTRUST_P5_ARCHIVE_REQUEST_A001_20260729_120000.json"
```

The script prompts for the password without echoing it. For unattended
automation it can read `P5_PASSWORD` from the environment. It updates the same
JSON atomically with the P5 job ID and final state.

### Restore and re-verification

Restore remains a deliberate P5 operator action. After P5 restores the archived
folder, use the preserved MHL in CopyTrust, MHL Verify, or another compatible
tool to calculate xxHash64 again and compare it with the capture-time values.
The `CT_XXH64` field is searchable context in the P5 web GUI; the MHL remains
the portable file-by-file verification record.

The complete current operator procedure—including restore preview, receiving
client and landing-path checks, path/count/byte reconciliation, MHL result
interpretation, and the planned coordinated workflow—is in
[CopyTrust → P5 Restore and Hash Verification](COPYTRUST_P5_RESTORE_AND_VERIFY_WORKFLOW.md).
CopyTrust 2.7.0 does not yet submit or automatically verify a P5 restore.

## Destination Sort (Post-Copy)

CopyTrust can optionally reorganize files on the destination into type-based subfolders after the trust chain is complete. The sort runs after copy, verify, MHL, and receipt writes — the integrity proof is sealed before any files are moved.

### Enabling

1. Open `Settings > Post-Copy`.
2. Pick **Card Copy** or **Folder Copy** in the mode picker at the top — all Post-Copy artifact settings are stored per mode.
3. Toggle **Sort files into type folders on destination**.
4. Choose a folder mode and review the category list.

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

### Known Issues (Destination Sort)

Both items below affect only the optional sort step. The copy, verify, MHL, and
receipt trust chain is never affected.

**1. Relay chains sort only the final destination — _known limitation, for now._**
If you set up a relay-chain queue **and** enable Destination Sort, only the **final**
destination is sorted. Intermediate destinations stay in their original layout — and
because the sort decision is made once, at copy time, they are not sorted later either
(there is no second pass after the chain finishes). This is intentional: it stops the
sort from moving files while the next leg is reading from them.

| Leg | Source | Destination | Sorted? |
|-----|--------|-------------|---------|
| Step 1 | Card A | SSD B | No — intermediate, keeps original layout |
| Step 2 | SSD B | NAS C | Yes — final leg, type-folder layout |

If you need every copy sorted, use a normal (non-relay) multi-destination session,
where each destination is sorted independently.

**2. A destination disconnect _during_ the sort can re-run the sort — _bug._**
The sort is one-shot once it finishes. But if a destination volume disconnects while
the sort is still moving files and you reconnect it, the app may re-run the sort over
a partially-sorted folder. In Flatten mode this can create duplicate `…_2` files; in
Preserve Structure mode it logs harmless "file already moved" errors. The integrity
proof (copy/verify/MHL) is already sealed and is unaffected. Workaround: avoid
unplugging the destination until the post-copy sort/artifact step reports complete.
A fix is being scoped without touching the working copy path. The full trace and
mitigation options are in CopyTrust's internal workflow trace, available on request.

## Contact Sheets (Post-Copy)

Contact sheet settings live in **Settings > Post-Copy > Contact Sheet**, stored per mode (Card/Folder). Layout is **Row** (one clip per row with detailed metadata, 7 per page) or **Grid** (3×4 poster, 12 per page).

### Unsupported media, external codecs, and placeholders

CopyTrust makes thumbnails natively for photos and common video, but it can't decode **professional and proxy formats** — MXF, R3D, BRAW, ARRIRAW, CinemaDNG, the MPEG‑2 family, and DJI `.LRF` proxies. What happens to those files on the contact sheet depends on two settings:

- **External thumbnail codecs** (Settings > External Codecs — a *shared*, not per-mode, setting). This is the switch that lets CopyTrust shell out to **ffmpeg** (MXF, MPEG‑2 family, LRF) and **REDline** (R3D) to extract real thumbnail frames.
  - **Off:** unsupported files appear as **"No Preview" placeholder tiles** with their filename and metadata. Fast — no external tools run.
  - **On:** CopyTrust runs ffmpeg/REDline per file to get real thumbnails. This is the right choice when you want a visual sheet of MXF/R3D footage, but it is **much heavier**: a card full of proxies or MXF means one external-tool invocation per file, so contact-sheet generation takes substantially longer than an all-JPEG/RAW card. Plan for it on proxy/MXF-heavy ingests.

- **Hide unsupported format placeholders** (per mode, under Contact Sheet).
  - **Off (default, recommended):** no-preview files still appear as placeholder tiles in the sheet. This is the leanest path — CopyTrust does not do any extra up-front work to decide what to hide.
  - **On:** files that can't produce a thumbnail are **omitted** from the PDF entirely (they still appear in the EXIF CSV and MHL). Turning this on makes CopyTrust run an extra preview pass up front to determine which files to drop, so it is slower on proxy/MXF-heavy cards. Use it only when you specifically want a clean sheet with no placeholder tiles.
  - Cosmetic note: with hide-placeholders **off**, the sheet header does not print a "N files without preview" count (the placeholder tiles convey it); with it **on**, that count appears.

**Practical guidance for proxy/MXF-heavy cards:** decide whether you actually need real thumbnails for those formats. If yes, enable external codecs and expect longer generation. If placeholders are fine, leave external codecs off for a fast sheet. Either way, leave **hide placeholders off** unless you specifically need the no-placeholder look — it's the lighter path. (Contact sheet generation is a background artifact and never blocks copy, verify, MHL, or receipts; if it fails you can retry just that artifact — see below.)

### Split large contact sheets

A 4,000+-file card in Grid layout produces a single PDF with hundreds of pages. **Split large contact sheets** caps how many files go into each PDF:

- **Off — single PDF** (default) · **Every 250 files** · **Every 500 files** · **Every 1,000 files**
- Cards over the limit are written as numbered parts: `copytrust_contactsheet_<alias>_<stamp>_part1of9.pdf`, `_part2of9.pdf`, …
- Each part's header carries a **"Part x of y — files a–b"** line so a printed or emailed part identifies its file range on its own. Thumbnails, EXIF, and all other content are unchanged — only how many PDFs carry it.
- Receipt export, the extra export folder, and **Retry missing artifacts** all recognize split parts.

Example: a 4,391-file card split at 500 produces 9 PDFs of roughly 42 grid pages each.

## Proxy Media (Post-Copy)

> **Beta in 2.6.0:** Test proxy creation and relinking with expendable copies
> before adopting it as production policy. Proxy generation is separate from
> the original-copy trust result.

Enable **Generate proxy media after verified copy** in **Settings > Post-Copy >
Proxy Media** for the selected Card or Folder mode. Then check **Create
proxies** beside every destination that should receive proxy output. Choose:

- **HEVC / H.265** — HEVC Main 10 in a MOV container, recommended for current
  Final Cut Pro workflows.
- **H.264** — H.264 High in a MOV container for broader compatibility.
- **Frame size** — 12.5%, 25%, or 50% of each source dimension. Aspect ratio is
  preserved and dimensions are rounded to even pixels.

CopyTrust uses the packaged `/usr/local/bin/ffmpeg` and
`/usr/local/bin/ffprobe`; it does not select a Homebrew or MacPorts copy.
Transcoding begins only after copy and verification, and after the lighter
contact-sheet/CSV/tree work. A proxy failure is reported in its own retryable
status row and never changes the verified-copy result.

By default, proxies are written beneath:

`CopyTrust_Proxies/<source subfolders>/OriginalFileName.mov`

Enable **Create Final Cut Proxy Media dated folder** to write:

`Final Cut Proxy Media/YYYY-MM-DD/<source subfolders>/OriginalFileName.mov`

The date is the completed-copy date. Source subfolders are retained so camera
cards containing duplicate basenames do not overwrite one another. The proxy
basename always matches the delivered original exactly, with only its extension
changed to `.mov`. Field testing with both CopyTrust H.264 and HEVC proxies
confirmed that Final Cut Pro reconnects them after they are named this way.

Automated real-encode tests cover a MOV source and an MXF source. Other
standard formats should work when the packaged ffmpeg can decode their video
and audio streams. File-extension recognition is not a decoder guarantee;
proprietary media such as R3D or BRAW is not claimed as supported by this beta
unless the packaged ffmpeg can decode it. Failures are logged and remain
retryable without changing the verified-copy result.

The generated proxy folders are built-in exclusions, so later CopyTrust scans
do not ingest previously generated derivatives as source media.

### Proxy receipt, summary, and session log

After proxy generation, each destination receives three evidence files beneath:

`CopyTrust_Receipts/Proxy Media/`

- `proxy_receipt_<source>_<stamp>.json` is the structured receipt. It records
  the operator, session, selected codec and percentage, packaged tool paths,
  every original-to-proxy path pair, both ffprobe snapshots, individual
  comparison results, and failed encode attempts.
- `proxy_receipt_<source>_<stamp>.txt` is the operator-readable summary. It
  states the explicit choice (for example, **H.264 at 50%** or **HEVC / H.265
  at 25%**), identifies the original and proxy paths, and lists every
  comparison as PASS, FAIL, or N/A.
- `proxy_receipt_<source>_<stamp>.log` records timestamped encode starts,
  percentage/speed/ETA heartbeats, completions, failures, comparison results,
  and the final batch result.

Before encoding, CopyTrust probes the delivered original. For a source whose
container reports 90- or 270-degree display rotation, frame scaling and
validation use the displayed orientation rather than the raw encoded width and
height. The receipt records both encoded and displayed frames plus rotation.

Reported full/limited color range, color primaries, transfer, and matrix are
passed into scaling and encoding. If the original does not report one of these
fields, CopyTrust uses the documented BT.709 proxy default but records the
source comparison as N/A instead of claiming preservation.

The proxy comparison validates the requested codec and calculated displayed frame size,
then compares frame rate, duration within approximately one frame, starting
timecode, reported color metadata, audio track count, and each reported audio
track's sample rate, channels, channel layout, and language. Codec, profile,
pixel format, bitrate, and frame dimensions are expected proxy changes.
Container-private metadata that ffprobe cannot meaningfully compare is not
described as equal. A missing original field is recorded as N/A, while a
reported original value that differs is a validation failure.

During a long encode, the Proxy Media status row updates about every five
seconds with the current clip/total, percentage, encode speed, and estimated
remaining time—for example, `Proxy 2/12 — 63% · 1.40× · ~18s remaining`.
The app's live session log records the same heartbeat with numeric percentage,
encoded seconds, speed, and ETA, along with the selected codec and scale.
Clips that do not report a usable duration still show encoded time and speed
without inventing a percentage or ETA.

The log also records original and proxy paths, dimensions, audio-track counts,
timecodes, comparison pass/fail counts, and the final receipt paths. All three
proxy evidence files are included when receipt export to an additional folder
is enabled.

### macOS packages and Final Cut libraries

Finder presents macOS packages as conceptually single items even though they
are directories ([macOS bundle background](https://en.wikipedia.org/wiki/Bundle_%28macOS%29)).
When the copied root is a recognized package—for example,
`Show Library.fcpbundle`—CopyTrust does not add receipt or proxy directories to
the package contents. It writes these as siblings instead:

```text
Destination/
├── Show Library.fcpbundle
├── CopyTrust_Receipts/
└── Final Cut Proxy Media/        (when enabled)
```

This applies to contact sheets, CSV, HTML, provenance, archived source MHL,
proxy evidence, and proxy media. Ordinary folders retain the existing layout,
with `CopyTrust_Receipts` inside the copied folder.

### Open automatically with multiple parts

When **Open contact sheet automatically after creation** is on:
- a single PDF opens in Preview as before;
- a split run **reveals the parts selected in Finder** (in `CopyTrust_Receipts/`) instead of opening a stack of Preview windows.

### Per-artifact status and retry

Contact Sheet, EXIF CSV, HTML Tree, and Proxy Media each show their own status
line (working / done / failed). Each spinner changes to a checkmark or result as
soon as that artifact generator finishes, so a slower proxy does not leave an
already-created PDF, CSV, or tree spinning. Failed rows have their own **Retry**
button, and **Rebuild All** regenerates the whole set.

**Proxy Media** reports the work left across the whole run, not one destination:
`7 of 10 · A001 → RAID 01 · 15%` — the encode number out of every encode the run will
perform (five clips to two destinations is ten), the card and drive, and how far into the
current clip. Codec, scale, speed and ETA stay in the activity log and the proxy receipt.

**If an artifact stops responding**, it is failed automatically after five minutes of
silence rather than spinning indefinitely: the source shows `Artifacts stalled — retry`, each
artifact still mid-flight becomes individually retryable, and the log records the last step
it reached. Use the artifact's own **Retry** — Rebuild All is not needed to recover.

**End Session always ends the session.** While background artifacts are running it becomes a
menu: **End Now — skip remaining artifacts**, or **Wait for Artifacts, then End**. Waiting is
bounded by progress rather than by a clock — artifacts that keep reporting are allowed to
finish however long they take, but once they have been silent for a minute the session closes
without them and says so in the log.

### Quick verification and descriptive artifacts

Quick verification checks that every delivered file exists and has the expected size; it does not calculate the content hashes required for an MHL. Contact sheet PDF, EXIF CSV, HTML tree, and destination sorting do not require those hashes and are generated from CopyTrust's delivered-file inventory.

Delivered files and hash evidence are tracked separately:

- Quick mode creates enabled contact sheet, EXIF CSV, and HTML tree artifacts after the size check succeeds.
- Quick-mode destination sorting works and the descriptive artifacts use the sorted paths.
- Quick mode still does **not** write an MHL or claim hash verification.
- Full and Inline modes retain their hash-backed MHL behavior.
- Every enabled artifact status row reaches a terminal done, failed, skipped, or **Nothing to do** state.

### If no contact sheet appears: check the active mode

Artifact settings are per mode, and drag-dropping a source can auto-select the copy mode — a card copied in Folder mode uses the Folder profile, where the contact sheet is **off** by default. The activity log states this explicitly (`contactSheet: disabled in Folder mode settings — skipped`), and the `contactSheet: generating` line shows the style, split setting, and timeout in effect. The metadata pass — which runs before the first preview and can take a while on RAW-heavy cards — logs its start and progress every 500 files, and split runs log each part as it is written.

### Large-card generation time and timeout

Contact sheet generation for RAW-heavy cards is preview-bound (roughly 0.25 s per file — a 4,391-file JPG+RAW card takes ~17 minutes). Before v2.5.4 a fixed 180-second timeout raced this work but could not stop it: the session reported *"Contact sheet timed out after 180s"* and *"1 failed"* while the full PDF was silently written to `CopyTrust_Receipts/` anyway — never acknowledged, never auto-opened.

From v2.5.4:
- the timeout scales with the card (180 s minimum, ~0.75 s per file — a 4,391-file card gets ~55 minutes);
- a genuinely timed-out or cancelled run now stops promptly and removes any partial or already-written part PDFs, so a reported failure means no PDFs are left on the destination;
- use **Retry missing artifacts** (or Drop Verify on the destination folder) to regenerate after a timeout.

## Safety Concept

CopyTrust is designed around the idea that safety can mean either:
- **multiple direct copies from the original card**, or
- **a fast trusted first copy followed by downstream relay copies**

Both are valid, but they serve different operational needs:
- Direct multi-destination copy is simpler and gives parallel redundancy from the original source.
- Relay chaining is better when the first destination is much faster than the later destination and the card needs to be freed sooner.

### Crash-report privacy

CopyTrust uses Sentry for crash and app-hang diagnosis. It is configured **not
to capture or transmit media paths or private information**. This includes
source and destination paths, media filenames, P5 hosts and URLs, credentials,
request headers, P5 client/plan/index/job details, and operator, customer,
project, or client information. It does not attach session logs, receipts,
manifests, contact sheets, screenshots, or media.
Automatic file-I/O and network tracing, performance tracing/profiling,
failed-request capture, session tracking, interaction breadcrumbs, and Sentry
logs are disabled.

Before an event is uploaded, CopyTrust removes messages, exception text,
requests and headers, user/server fields, tags, extras, breadcrumbs, source
context, filenames, and full binary paths. It retains the app release/build,
Sentry platform identifier, crash addresses, image identifiers, module
basenames, and stack functions required for symbolication. IP-address storage
must also be disabled in the Sentry project's server-side privacy settings;
the application cannot enforce retention or deletion after an event reaches
Sentry.

In a Debug build, **Settings → Test → Sentry Integration → Send Privacy-Safe
Test Event** sends one synthetic exception through this same on-device filter
and displays its event ID. The event contains no media, path, P5, credential,
operator, or client data and does not force a crash. In Sentry it remains
identifiable by the exception type `CopyTrustSentryIntegrationTest`, while its
exception value is replaced with `Redacted by CopyTrust privacy filter`.

## Inline Verification

Inline verification is the new default verification mode. It replaces the batch verification pass with per-file verification during the copy phase.

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

#### Sorted copies and MHL verification (since 2.5.2; in 2.5.3 stable)

When **Destination Sort** is on, files are moved into type folders (`Video/`, `Proxy/`, …) *after* the copy. The MHL written during the copy describes the pre-sort layout, so a single MHL alone would point at paths that no longer exist once sorting completes.

Since 2.5.2 (stable as of 2.5.3), CopyTrust handles this automatically:

- A **delivery MHL** describing the sorted layout is written to the destination root, and every verify action — **Verify Using MHL**, **Re-Verify Destinations**, **Retry MHL Export** — targets it.
- The original **source MHL** is preserved as provenance under `CopyTrust_Receipts/… - Source.mhl`, so the destination root holds exactly one verifiable MHL.
- A **`PROVENANCE_<source>_<timestamp>.json`** record is written to `CopyTrust_Receipts/` for every copy: the settings used (naming, sort categories, folder mode) plus the per-file source→destination mapping (identity for a plain copy).
- If a network destination drops and reconnects mid-pipeline, the sort is **not** re-run (it is one-shot) — only unfinished artifacts are retried.

> Sorted-copy MHL handling shipped in the 2.5.3 stable release. Plain (unsorted) copies are unchanged: the single copy-time MHL at the destination root is the one you verify against.

## Copy Modes (Card / Folder)

Copy modes let operators switch between camera-card and folder-copy configurations with one click. Each mode maintains its own independent settings profile — changes to Card settings never affect Folder settings and vice versa.

> **Naming note:** the Card / Folder control is the copy **mode**. **Preset** refers only to the saved settings bundles described in [Presets](#presets) below.

### Mode picker

A segmented control in the toolbar shows the active mode: **Card** or **Folder** (orange tint). Switching modes saves the current settings to the outgoing profile and loads the incoming profile. The picker is hidden during an active copy.

### Mode defaults

| Setting | Card | Folder |
|---------|------|--------|
| Subfolder naming | `{alias}_{date}` | `{alias}` |
| Preserve original folder names | On | On |
| Skip hidden files | On | On |
| System exclusions | Off (fresh profiles, v2.5.0 b2) | On |
| File Storage exclusions | Off (fresh profiles, v2.5.0 b2) | On |
| Camera card exclusions | Optional, default off | Optional, default off |
| Exclusion groups | File Storage, System, Camera Card, Custom | File Storage, System, Camera Card, Custom |
| Destination sort | On | Off |
| Verification level | Inline | Quick |
| Auto-advance | On | Off |
| Contact sheet | On | Off |
| EXIF CSV | Off | Off |
| Auto-eject | Off | Off |

### Per-mode settings

Each mode stores its own complete settings profile including: naming template, subfolder prefix, file prefix, preserve original names, verification level, post-copy re-verify, hidden-file handling, exclusion pattern checkboxes, auto-advance, auto-eject, contact sheet (on/off, style, open after creation, hide placeholders, split limit), EXIF CSV, HTML directory tree (on/off, mode), and destination sort (on/off, categories, folder mode). HTML tree modes are **Project summary index** (native, no `tree` required), **One HTML per top-level folder**, and **Entire project** (recursive modes require `tree`).

Configure each mode independently:
- **Settings > Card Copy** — card-specific settings plus the grouped Exclusions editor and Hidden Files toggle
- **Settings > Folder Copy** — folder-specific settings plus the grouped Exclusions editor and Hidden Files toggle
- **Settings > Post-Copy** — all artifact settings (contact sheet, EXIF CSV, HTML tree, destination sort) per mode via the Card/Folder picker at the top
- **Settings > Test** — built-in test harness to validate settings for either mode (see [Test Harness](#test-harness) below)

Shared settings (not per-mode): operator name, external codecs, notifications, appearance, destination sets, receipt export.

### Per-queue-item snapshots

When a batch is queued, the full active profile and non-secret P5 target choices
are captured as snapshots. Each queued item runs with exactly the settings
chosen at staging time. P5 passwords remain only in Keychain and are resolved
for the captured server identity when post-copy work begins. You can queue a
Card batch with inline verification, switch to Folder mode, queue a Folder
batch with quick verification, and each runs independently. Already-queued
items and their background artifacts are not affected by later settings
changes.

### Persistence

Both profiles are saved to disk and survive app restarts. On first launch after upgrading, existing settings are migrated into the Card profile. The Folder profile starts with factory defaults.

---

## Presets

A **preset** saves your Card **and** Folder settings under one name, so a whole
configuration can be restored in a single action. Where the mode picker chooses *which*
profile is active, a preset sets *what is in both of them*.

Presets are for the case where someone sets the app up once — for a camera, a show, or a
house standard — and operators load it and start work.

### The Preset menu

The **Preset** menu sits next to the Card / Folder picker in the bottom action bar.

| Action | What it does |
|---|---|
| Save Current Settings as Preset… | Captures the current Card and Folder settings under a new name |
| Load | Replaces both mode profiles and the shared settings with the preset's |
| Update … from Current Settings | Re-captures the loaded preset in place, keeping its name and identity |
| Rename… / Delete | Your own presets only |
| Duplicate as My Preset… | Makes your own editable copy of a shared preset |

The menu label shows the loaded preset's name. A **dot (•)** after the name means settings
have changed since it was loaded — choose *Update…* to keep those changes, or *Load* again
to discard them.

### What a preset contains

Everything that describes *how* a copy is made:

- **Per mode, for both Card and Folder** — naming template, subfolder and file prefix,
  preserve original names, verification level, post-copy re-verify, auto-advance,
  auto-eject, hidden files and exclusion patterns, contact sheet (on/off, style, open after
  creation, hide placeholders, split limit), EXIF CSV, HTML tree (on/off, mode), proxies
  (on/off, codec, frame scale, Final Cut proxy folder), destination sort (on/off,
  categories, folder mode).
- **Shared** — confirm before copy, external codecs on/off, ExifTool metadata, the ffmpeg /
  REDline / BRAW extension lists, receipt export, and the four notification settings.

### What a preset deliberately does not contain

| Not included | Why |
|---|---|
| Destinations | A preset never changes your destination list. Loading one names the destination set it expects and tells you whether that set exists on this Mac — you then check the destinations yourself before copying. |
| External tool paths | ffmpeg, REDline, BRAW Decode, ExifTool and tree live in different places on each Mac and are detected locally. The *extensions* that route to each tool do travel. |
| P5 server and credentials | Per-site, and the password is held in Keychain. |
| Operator name | It is stamped on receipts as who performed the copy. A shared preset must never put someone else's name on your receipts. |
| Appearance mode | A personal preference, not a copy setting. |
| Drop Verify settings | A separate part of the app. |

### Shared presets

Presets appear in two groups:

- **Shared** — set up for everyone on this Mac, in
  `/Users/Shared/CopyTrust/Presets`. CopyTrust only ever *reads* this folder. These cannot
  be renamed, edited or deleted from the app; use **Duplicate as My Preset…** to make your
  own copy.
- **My Presets** — your own, saved in
  `~/Library/Application Support/CopyTrust/Presets`.

Because the app never writes to the shared folder, re-deploying house presets cannot
overwrite your own, and two operators on the same Mac cannot overwrite each other's.

### Deploying presets to a team

Presets are plain, readable JSON files. To put a preset on other machines, copy its `.json`
file into `/Users/Shared/CopyTrust/Presets` — by hand, from a script, or as part of an
imaging or MDM step. That folder exists on every Mac from the moment macOS is installed and
does not require the user to have launched CopyTrust first, so presets can be placed before
anyone's first run.

CopyTrust reads the folder at launch. A preset added while the app is running appears after
a relaunch.

If a preset file cannot be read, the Preset menu says so and names the file; every other
preset still loads.

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

CopyTrust checks subfolder name length before copy begins.

### APFS limit

APFS allows a maximum of 255 bytes per path component. With ASCII characters this means 255 characters; with multi-byte Unicode (emoji, CJK) the byte count may be higher than the character count.

### What happens

- If the rendered subfolder name exceeds 255 bytes, it is truncated at a clean character boundary (no split multi-byte characters).
- The subfolder naming preview in the main window shows an orange warning icon when truncation would occur.
- The total path length (destination root + subfolder + longest relative file path) is also checked against 1024 bytes.

### When to expect this

Name length issues are more likely with the Folder preset and Preserve Original Folder Names enabled, since sanitized names are typically shorter than original names.

## Dark Mode

CopyTrust defaults to dark appearance.

### Settings

Open `Settings > Appearance` to choose:

| Mode | Behaviour |
|------|-----------|
| **Always Dark** (default) | Dark appearance regardless of macOS setting |
| **Follow System** | Follows the macOS Light/Dark appearance setting |

## Menu Bar Progress

CopyTrust shows copy progress in the macOS menu bar.

During the post-copy verification phase the blue copy bar is replaced by an **orange verification bar** with its own percentage, averaged across destinations and matching the activity log's `verify NN%` lines, under a "Copy complete — verifying" label. The live activity log carries a copy-phase heartbeat — a line every ~5 seconds with percent, file-copy count, bytes copied, and current speed.

The expanded activity log pane is **resizable**: drag the handle at its bottom edge to grow it toward filling the window, and the chosen height is remembered across launches. Each copy logs a one-line mode summary at the start, including `proxy=off` or the selected codec/scale/Final Cut folder (`copy mode=Card verify=inline artifacts=[…] proxy=hevc-25%-fcpFolder=on sort=on contactSheetSplit=500 exclusionsEnabled=3 destinations=2`), so a saved log shows exactly how the session was configured.

### Menu bar icon

A `doc.on.doc` icon appears in the menu bar. During an active copy the icon fills in (`doc.on.doc.fill`).

### Popover content (during copy)

| Field | Example |
|-------|---------|
| Source name | `A001 · Source 1 of 2` |
| Destination count | `2 destinations · Copying` |
| Progress bar | Visual bar with percentage, for the source copying now |
| File copies | `142 / 380 file copies` |
| Bytes | `48.2 GB / 128.7 GB` |
| All sources | Second bar with percentage — only when the run has more than one source |
| Show CopyTrust | Button to bring the main window forward |

The counts are **file copies**, not files: every file is written once per destination, so a
47-file card going to two destinations is 94 copies. Both halves of the ratio — and the byte
totals beside them — count the same thing, and they match the activity log's
`75/94 file copies` heartbeat.

Sources copy one after another, so the main bar reaching 100% means the current card is
done, not the run. The `Source N of M` label and the second, quieter **All sources** bar —
which weights each source by its scanned size — appear only when more than one source is
staged.

### After the copy, while background work continues

Copying finishes before proxies and other artifacts do. Rather than going straight to "No
active copies" — accurate, but it reads as *the whole job is done* — the popover shows:

- **No active copies**
- which cards are **ready to eject**, so they can be pulled without waiting
- what is still running, e.g. `Proxies 7 of 10 · A001 → RAID 01`, with a reminder to leave
  CopyTrust open until it finishes

### Idle state

Once the background work ends, the popover shows a green checkmark and "No active copies"
with a Show CopyTrust button.

### Use case

The menu bar progress lets operators monitor copies without keeping the main CopyTrust window visible. Minimize or hide the window and check the menu bar icon for status.

## Queue Manager — Staging During Active Copy

When a copy starts, the UI transforms from the source/destination setup panels into a compact **Copy Queue** manager. This provides a clear visual mode shift and makes it obvious that the app is in a running-copy state.

### Queue Manager layout

The queue manager replaces the two side-by-side panels with a single full-width panel showing:
- A **running row** for the active copy — status icon, source name, arrow, destination names, preset badge, and live progress bar
- **Queued rows** for staged batches — each showing source, destinations, preset, and status
- **One line per source** under the running row when the run has more than one source
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

### Runs with more than one source

Sources are copied one after another, not simultaneously — "simultaneous" describes the
destinations, which are written in parallel. A run staged with two cards therefore has a
first card and a second card, and the queue row now shows both:

- The row title reads **`2 sources`** instead of naming only the card copying right now, and
  the status line adds **`Source 1 of 2`**.
- Below the row, **one line per source** gives that source's own bar and status —
  `Waiting`, `Copying & Verifying 81%`, `Verifying`, `Complete`, `Cancelled` or `Failed`.
  The active source's name is bold.
- The row's main progress bar covers the **whole run**, each source weighted by its scanned
  size. It no longer fills to 100% at the end of the first card and start again from zero.
- The **estimated time remaining** is still for the source copying now, and says so:
  `~4m 20s left on this source`. The clock restarts with each source.
- The **file copies** count in the status line is per file per destination — the same unit
  as the activity log.

A run with a single source looks exactly as it did: no extra lines, and the row title is the
card's name.

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

Each queued session stores the active copy preset at the time it was created.

### Visual indicator

Queue rows show a coloured badge next to the session name:
- **Card** — blue badge
- **Folder** — green badge

### Behaviour

When a queued session starts, its stored preset is applied before the copy begins. This means different queue items can use different presets in the same queue run — for example, a Card-preset camera card ingest followed by a Folder-preset folder backup.

### How presets are stored

The preset is saved with the queued session item and persists across app restarts. Changing the active preset in the toolbar does not retroactively change already-queued sessions.

## Current Practical Guidance

- For `A -> B` and `A -> C`, use one normal session with multiple destinations and `Copy: Simultaneously`.
- For `A -> B -> C`, set the `Copy` switch to `In series` and press `Start`.
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

Open **Settings > Test**. The tab shows the current Card or Folder profile summary, scenario picker, path configuration, fixture options, and results. **Run Test**, **Reveal Source**, and **Reveal Report** stay visible in the bottom action bar so you do not need to scroll to start or inspect a run.

Debug builds also show **Sentry Integration** at the top of this tab. Use its
privacy-safe test-event button after changing the Sentry project or DSN. Match
the displayed event ID in Sentry and inspect the received event to confirm that
the privacy filter removed private fields. This verifies delivery and filtering;
it does not replace a separate controlled crash/dSYM symbolication test.

### Mode picker

A **Card / Folder** segmented control at the top selects which mode profile to test. The profile summary below it shows the active settings that will be used: naming template, verification level, file prefix, exclusion status, and destination sort status. Switch modes to test each profile independently.

### Scenarios

Seven test scenarios are available, each targeting a specific aspect of the copy engine:

| Scenario | What it tests |
|----------|---------------|
| **Basic Copy** | Copy with current mode settings — verifies all files arrive at the destination |
| **Naming Preservation** | Verifies `Preserve Original Folder Names` behaviour and template rendering |
| **File Prefix** | Verifies the copied file prefix template renders correctly when enabled |
| **Exclusion Pattern** | Verifies that enabled exclusion patterns from the selected mode skip matching files |
| **Folder/File Exclusions** | Creates known sample folders/files, applies sample exclusions, and verifies matching names are skipped |
| **Verification Levels** | Tests none / quick / full / inline verification outcomes |
| **Destination Sort** | Verifies files are sorted into type-based subfolders after copy |

Each scenario focuses on one feature but runs the full copy pipeline. MHL generation, receipts, and verification all happen as they would in a real ingest.

The **Folder/File Exclusions** scenario adds temporary sample exclusions for the run only:

| Pattern | Type | Expected match |
|---------|------|----------------|
| `EXCLUDE_SAMPLE_FOLDER` | Exact | Any folder or file name equal to `EXCLUDE_SAMPLE_FOLDER` |
| `exclude_sample_file` | Prefix | Files whose names start with `exclude_sample_file` |
| `cache_proxy` | Prefix | Files whose names start with `cache_proxy` |

These sample exclusions do not change saved Card or Folder settings.

### Paths

- **Source root** — where the synthetic source tree is created. Defaults to the system temp directory. Click Browse to choose a different location.
- **Destination roots** — one or more destination folders where files are copied. Click **Add Destination Root…** to add destinations and the remove button to delete them from the test run.
- **Use Destination Set** — loads destination sets saved from the main CopyTrust window and replaces the current test destination roots with that set's destinations.
- **Save as Destination Set…** — saves the current test destination roots back to the shared CopyTrust destination set list.

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
5. Click **Run Test** in the bottom action bar.

Progress text updates as the test moves through fixture generation, copy, verification, and analysis. When finished, colour-coded result pills appear.

### Contextual tips

The test tab shows scenario-specific tips when relevant settings are not active:
- Running **File Prefix** with the file prefix setting disabled shows a warning that results may not reflect prefix behaviour.
- Running **Destination Sort** with sort disabled shows a warning.
- Running **Exclusion Pattern** with no active exclusion patterns shows a warning.
- Running **Folder/File Exclusions** shows the sample patterns that will be applied for that run.

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
5. Run **Exclusion Pattern** if you added or modified saved exclusion patterns.
6. Run **Folder/File Exclusions** when you want a controlled proof that file-name and folder-name exclusions are working.
7. Run **Destination Sort** if you changed sort categories or folder mode.
8. When all pills are green, your settings are validated for real use.
