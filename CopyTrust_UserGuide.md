# CopyTrust User Guide

Date: 2026-04-27  
v2.3 Build 5

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
| Hide the progress sheet, keep copying | `Hide` (in progress sheet) |
| Inspect results without stopping | `Review & Verify` (main window) |
| Stop the copy | `Cancel Copy` (in progress sheet) |

### After cancelling — progress sheet

Two buttons appear together:

- **`Resume`** — restarts from where it stopped; reconciled files are not re-copied
- **`Done`** — dismisses the sheet and returns to the main window; the session remains in its cancelled state

### After cancelling — main window

```
[ Review & Verify ]  [ End Session ]  [ Start This Session ]  [ Reset Session ]
      primary ●          secondary        restart/retry            wipe all
```

- **Review & Verify** (blue) — inspect partial results before deciding; the right first step if anything looks unexpected
- **End Session** — formally closes the session and saves whatever was captured; use this when you are done with this run whether it completed or not
- **Start This Session** (grey, demoted) — available if you want to restart the copy
- **Reset Session** — wipes the workspace and the entire queue; use only when you want to start completely fresh

### After completing — main window

```
[ Review Summary… ]  [ End Session ]  [ Start This Session ]  [ Reset Session ]
      primary ●          secondary          secondary              wipe all
```

- **Review Summary…** (blue) — opens the full session summary; `End Session` is also accessible from inside
- **End Session** — closes directly without opening the summary; use when you are confident the run is good

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

After a cancelled run the action bar reads (in priority order):
```
[ Review & Verify ]  [ End Session ]  [ Start This Session ]
      primary ●          secondary          demoted
```

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

## Verify Diagnostics

Before verification hashing begins, CopyTrust logs a structured diagnostic showing file count, byte count, reused files, and whether any prior copy failures or skipped files already exist. This provides context that was previously only reconstructable by replaying the full session log.

If verification aborts, the abort path now logs the exact stage (source hashing vs destination hashing) and the file path that triggered the failure, instead of collapsing into a vague terminal error. JSON and plaintext receipts preserve failed/skipped file counts and the first recorded error line for post-run analysis.

## Safety Concept

CopyTrust is designed around the idea that safety can mean either:
- **multiple direct copies from the original card**, or
- **a fast trusted first copy followed by downstream relay copies**

Both are valid, but they serve different operational needs:
- Direct multi-destination copy is simpler and gives parallel redundancy from the original source.
- Relay chaining is better when the first destination is much faster than the later destination and the card needs to be freed sooner.

## Current Practical Guidance

- For `A -> B` and `A -> C`, use one normal session with multiple destinations.
- For `A -> B -> C`, use `Queue Relay Chain`.
- For `A -> B -> C` followed by another card taking the same path, queue each card as its own relay chain.
- For different cards going to different destinations, use separate queued sessions and `Start Queue`.
- Use `Help > CopyTrust Help` any time you want the in-app startup checklist again.
