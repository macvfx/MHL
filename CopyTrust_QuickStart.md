# CopyTrust Quick Start

Date: 2026-04-18  
Current branch baseline: `v2.2 (Build 2)` 

This file is a Quick Start for the current CopyTrust workflow.

The canonical up-to-date guide is: COPYTRUST_UserGuide.md

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
Use this for `A -> B -> C`.

1. Add one source.
2. Add destinations in order.
3. Adjust destination order with the up/down controls if needed.
4. Click `Queue Relay Chain`.
5. Click `Start Queue`.

Expected result:
- `A -> B` runs first
- once verified, the output of `B` becomes the source for `B -> C`
- background PDF and CSV work does not block the next relay leg

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

## End Of Run

When the queue is complete, `Review Summary…` opens the session summary sheet.

Current summary actions:
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
