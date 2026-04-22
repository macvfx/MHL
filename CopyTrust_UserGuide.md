# CopyTrust User Guide

Date: 2026-04-21  
Branch baseline: `codex/v2.1.9-red-r3d-build2` (v2.2 Build 8)

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
2. Add destinations in relay order:
   `B` first, then `C`, then any later stops.
3. Adjust the destination order if needed with the up/down controls.
4. Check the visible relay order labels such as `Stop 1` and `Stop 2`.
5. Click `Queue Relay Chain`.
6. Click `Start Queue`.

What CopyTrust does:
- Step 1 starts from the original source.
- Step 2 waits for the verified output from Step 1.
- Later steps continue in order the same way.
- PDF/CSV artifact work from Step 1 does not block Step 2.
- The end-session receipt now summarizes the full relay run instead of only the last leg.

Important note:
- Relay chains are currently easiest when built from **one source and an ordered destination list**.
- This is also the **recommended and intentionally visible UI path for now**.
- In practice, that means the current relay workflow is: choose one source, choose two or more destinations in order, then use `Queue Relay Chain`.
- If you want another camera card to follow the same relay path, stage that as a **separate relay-chain session**.
- In other words, `A -> B -> C` and `D -> B -> C` should currently be queued as two separate relay chains, not one combined multi-source relay session.
- A possible future option is a more explicit “finish `A -> B`, then choose `C` as the next destination from `B`” flow, but that is **not** the primary workflow CopyTrust is presenting in the UI today.

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

## Review And End Session

During an active or partially completed session:
- `Review & Verify` opens the session summary without ending the session
- use this when you want to inspect results, MHL entries, or receipt text while more work may still happen

When all queued work is complete:
- `Review Summary…` becomes the main review button
- the summary sheet is where you confirm the final run before ending it

Current summary-sheet actions:
- `Copy`
- `Reveal Summary`
- `Manifest`
- `Log`
- `End Session`
- `End` and `Wait` when background PDF/CSV artifact work is still running

What to expect from `End Session`:
- the session is closed and the live workspace is cleared
- the app keeps the finished run available for later review from the main UI
- after ending, use `Review Last Summary…`, `Reveal Receipts`, `Reveal Log`, `Reveal Manifest`, or `Reset Session`

What no longer applies:
- there is no `Done`
- there is no `Done + Clear`
- the old expectation that destinations stay loaded after session end is no longer the current workflow

## Safety Concept

CopyTrust is designed around the idea that safety can mean either:
- **multiple direct copies from the original card**, or
- **a fast trusted first copy followed by downstream relay copies**

Both are valid, but they serve different operational needs:
- Direct multi-destination copy is simpler and gives parallel redundancy from the original source.
- Relay chaining is better when the first destination is much faster than the later destination and the card needs to be freed sooner.

## Current Practical Guidance

Recommended today:
- For `A -> B` and `A -> C`, use one normal session with multiple destinations.
- For `A -> B -> C`, use `Queue Relay Chain`.
- For `A -> B -> C` followed by another card taking the same path, queue each card as its own relay chain.
- For different cards going to different destinations, use separate queued sessions and `Start Queue`.
- Use `Help > CopyTrust Help` any time you want the in-app startup checklist again.

Still improving:
- clearer user-facing language around relay chains versus normal multi-destination sessions
- possible future alternate relay authoring such as “after `A -> B`, choose `C` from `B`” without changing the current preferred workflow
- fuller lineage visibility in manifests, receipts, and saved logs
- device speed history — persistent per-volume speed tracking across sessions for degradation detection and pre-copy time estimates 
