# CopyTrust Quick Start

Date: 2026-08-22
Current testing release: `v2.7.7 (Build 2 public beta)`

With two or more destinations, one **Copy** switch chooses `Simultaneously` or
`In series`, and one button — always labelled **Start** — runs it. That is the
whole multi-destination decision.

CopyTrust 2.7 adds an optional Archiware P5 archive action for controlled
testing. Configure Settings → P5 Archive, use Full or Inline verification,
select a non-deleting plan, and confirm the resulting job and `CT_*` metadata
in P5 Web. Quick/copy-only work is never auto-submitted.

This file is a Quick Start for the current CopyTrust workflow.

The canonical up-to-date guide is: [CopyTrust_UserGuide.md](CopyTrust_UserGuide.md)

## Recommended Workflows

### Direct multi-destination copy
Use this for `A -> B` and `A -> C`.

1. Add one source.
2. Add one or more destinations.
3. With two or more destinations, leave the `Copy` switch on `Simultaneously`
   (the default). Every destination is copied at once, reading the source once
   per destination.
4. Confirm preflight is clean.
5. Click `Start` and review the top-level flow plus every
   destination card. Confirm source/step context, verification, sorting,
   artifacts, and explicit Proxy/P5 choices before continuing.
6. Watch the run in the progress panel on the queue row — percentage, speed, time remaining,
   a bar per destination, and files as they are copied and verified.
7. Use `Review & Verify` during the run if you want to inspect results without ending the session.
8. When all work is done, click `Review Summary…`, then `End Session`. The window stays on the
   run until then, so artifacts still building stay in view.

Expected result:
- the source copies directly to each loaded destination
- copy, selected verification, receipts, and logs finish before completion; Full/Inline also write a hash-backed MHL, while Quick does not
- PDF, CSV, HTML tree, and optional proxy artifacts can continue afterward in
  the background

### Optional proxy media beta

In Settings → Post-Copy → Proxy Media, choose H.264 or HEVC and 12.5%, 25%, or
50%. Optionally enable the dated `Final Cut Proxy Media/YYYY-MM-DD` layout.
CopyTrust preserves the original basename and writes `.mov` so the files can be
placed and relinked later in Final Cut Pro.

This feature is beta. Real encode tests cover MOV and MXF; other inputs work
only when CopyTrust's packaged ffmpeg can decode them. Watch per-clip progress
in the UI and active log, then review the JSON, TXT, and LOG evidence. A proxy
failure never changes the verified-original copy result.

The delivered original is probed before encoding. Display rotation is
used when calculating proxy dimensions, and reported color range, primaries,
transfer, and matrix are carried into the proxy. The evidence report records
encoded and displayed dimensions, rotation, and source/proxy color fields.

### Relay chain
Use this for `A -> B -> C`.

1. Add one source.
2. Add destinations in order — **fastest drive first**.
3. Set the `Copy` switch to `In series`. It shows the chain path and confirms the
   source is read once for the whole chain.
4. Adjust destination order with the up/down controls if needed; check the
   `Stop 1` / `Stop 2` labels.
5. Set `Archive to P5` and `Create proxies` on the intended rows. A new chain
   starts with P5 on the first stop and proxies on the last.
6. Click `Start`. CopyTrust builds the chain and runs it in one action, so the
   pre-copy review always appears.
7. Review the generated topology and destination cards, then continue.

Expected result:
- `A -> B` runs first
- once verified, the output of `B` becomes the source for `B -> C`
- background PDF, CSV, and HTML tree work does not block the next relay leg
- `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json` preserves the ordered legs,
  dependencies, and destination proxy/P5 selections before execution
- each leg's session log records its active queue item and plan link; the plan
  is exported beside that leg's receipts

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
- `Copy Receipt`
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

When the copied root is an `.fcpbundle` or another macOS package, CopyTrust
places `CopyTrust_Receipts` and proxy folders beside the package. Ordinary
folder copies retain their existing internal receipt layout.
