# CopyTrust 2.7.2 (Build 30) — Multi-Destination Copy, Relay Recovery, and Suite Alignment Testing Notes

Date: 2026-08-08
Status: Public prerelease for controlled testing
Apps: CopyTrust 2.7.2 Build 30; Drop Verify and Folder Copy Compare 2.7.2 Build 14

## Beta focus

Build 30 is a presentation change only: `Start` is now the only blue control on screen.
The `Simultaneously` / `In series` switch is orange, matching Card/Folder, because it is a
mode; and the Queued Sessions panel's duplicate `Queue Current Session` button is gone,
leaving the one in the action bar. Nothing about what a copy *does* changed, so the matrices
below still apply as written — add one check that exactly one blue control is visible with a
relay chain staged, and that `Queue Current Session` still works from the action bar.

Build 29 changes how a multi-destination copy is started, and fixes two failures that
only appear on relay chains. Test the starting decision and the recovery behaviour
first — they affect every copy with more than one destination.

**One Copy switch, one Start button.** With two or more destinations loaded, a
segmented **Copy** switch appears beside the destination list: **Simultaneously**
copies to every destination at once (the source is read once per destination), and
**In series** copies through them in order so each stop's verified output feeds the
next (the source is read once for the whole chain). In series also shows the ordered
path. One button — always labelled **Start** — runs whichever is selected.
`Simultaneously` remains the default, so an existing setup behaves as before; the
choice is now visible rather than implied by which button was pressed.

This replaces `Queue Relay Chain`, which appeared in three places — the destinations
panel, the queued-sessions panel, and every destination row's context menu — and
started nothing. It built the chain, cleared the workspace, and left the operator to
find `Start Queue` elsewhere. Because the pre-copy review fires when a copy starts, a
relay chain built that way **ran with no review at all**. `Start` now queues and starts
the chain in one action, so the review always appears. The four contextual Start labels
("Start Relay Chain", "Copy to Both Now", "Start This Session", "Start Loaded Session")
are gone; there is one start action and the Copy switch above it already states what it
will do.

**Relay-chain crash fixed.** The immutable workflow plan exported into each
destination's receipts folder was written with a file-write option pair macOS rejects
outright (`.atomic` combined with `.withoutOverwriting`). It is a trap rather than a
thrown error, so no error handling could contain it, and it fired whether or not the
file already existed. The export runs once per destination at the end of every relay
copy, so **every relay chain crashed at the same point**: step 1's files, MHL and
`completed` session manifest all safely on disk, but the queue not yet updated. The
export now writes a temp file and moves it into place, which keeps both properties
honestly — the write is atomic, and the move fails if the destination appeared
meanwhile, which is the immutability guarantee the export exists for.

**Interrupted jobs recover.** A job recorded as `running` in the queue file at launch
tells you the app went away mid-job; it does *not* tell you whether the copy finished,
because the status is written after the copy completes and verifies. Restore now asks
the destination instead of trusting the status: for any job still `running`, CopyTrust
reads the session manifests under `<destination>/<subfolder>/CopyTrust_Receipts/`. A
manifest showing the copy completed (or completed with transient-skip warnings only)
marks the job **completed** and resolves the next relay stop against the folder the
files actually landed in, so the chain carries on from step 2. No completion on disk
sends the job back to **queued** — queued rather than failed, because nothing is known
to be wrong with the media. Only the destination's immediate children are scanned, so
this stays bounded on a large volume.

**Relay defaults and review wording.** A new relay chain starts with `Archive to P5` on
the first stop and `Create proxies` on the last — camera archive first, editing storage
last; both remain changeable on any row. The pre-copy review's P5 line now reports what
was actually tested (`connection OK` / `connection not tested` / `connection failed`)
instead of the ambiguous "checked", and no longer names its destination twice.

**Reset Session genuinely resets** (Build 24), and a loaded queued session now draws
first, labelled "runs first", so a partially-loaded relay chain no longer reads as
though its legs were reversed (Build 27).

**Drop Verify and Folder Copy Compare are rebuilt at 2.7.2 Build 14 for suite alignment
only.** Neither has changed functionally since Drop Verify Build 8 added proxy media, so
they need no new testing beyond confirming they launch, report the expected version, and
pass a smoke copy/verify. Their proxy and operator-manifest behaviour is covered by
`TEST_NOTES_v2.7.0.md` and the 2.7.2 entries in the release notes.

Use expendable fixtures throughout. Do not treat a green copy result as P5 proof:
confirm the request JSON, P5 job, archived paths, and index metadata in P5 Web.

## Acceptance matrix

### Copy switch and Start

| Test | Expected result |
|---|---|
| Switch appears | The Copy switch is shown only once two or more destinations are loaded |
| Default topology | `Simultaneously` is preselected; an existing saved setup behaves exactly as it did before Build 29 |
| Source-read wording | `Simultaneously` states the source is read once per destination; `In series` states it is read once for the whole chain and shows the ordered path |
| One button | The start button reads **Start** in every state — no contextual relabelling |
| Simultaneous start | Copies to every destination at once; the queue is left untouched |
| In-series start | One press queues every stop *and* starts the chain — no separate `Start Queue` step |
| Review always fires | A relay chain started from `Start` shows the pre-copy review before any copying begins |
| Chain shape | Every stop is queued under one sequence ID, with stop 2 depending on stop 1 |
| Per-stop defaults | A new chain has `Archive to P5` on the first stop and `Create proxies` on the last; changing either on any row sticks |
| Nothing to start | A single destination, or a missing source, starts nothing and says why |
| No stale control | `Queue Relay Chain` no longer appears in the destinations panel, the queued-sessions panel, or any destination row context menu |
| Help text | In-app help and tooltips describe the Copy switch, not the removed buttons |
| Reset | Reset clears a chain started this way |

### Relay-chain crash and evidence

| Test | Expected result |
|---|---|
| Two-stop relay completes | The full chain runs to completion; the app does not quit after stop 1 |
| Plan export | One `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json` is exported beside every leg's delivered receipts |
| Re-export is a no-op | A chain exporting the same plan to a second destination succeeds without error |
| Immutability preserved | Exporting different content over an existing plan fails and leaves the existing file untouched |
| No temp residue | No `.tmp` file is left on any destination |
| Queue advances | After stop 1 verifies, the queue visibly moves to stop 2 rather than freezing |

### Interrupted-job recovery

| Test | Expected result |
|---|---|
| Finished job recovered | Force quit after a leg completes on disk; on relaunch that job is **completed** and the chain resumes at the next stop |
| Next stop resolved | The recovered leg's delivered folder becomes the upstream source for the following stop |
| Unfinished job requeued | Force quit mid-copy with no completion manifest; on relaunch the job is **queued**, startable, with no block reason |
| Never failed | An interrupted job is never marked failed |
| Resolved path preserved | An already-resolved upstream path is not overwritten with a guess |
| Other statuses untouched | Completed, cancelled, failed, queued, blocked, and paused items restore verbatim |
| Empty queue | An empty queue restores empty |
| De-duplication | Repeated items still collapse, and the surviving item is reconciled |
| Bounded scan | Recovery on a large destination volume returns promptly (immediate children only) |
| No phantom session | The app does not reopen asking to continue a session that already ended |

### Pre-copy review

| Test | Expected result |
|---|---|
| P5 connection wording | The P5 line reads `connection OK`, `connection not tested`, or `connection failed` — never "checked" |
| Destination named once | The P5 line names its destination exactly once |
| P5 on a later leg | Selecting P5 on a later relay stop is still found while an earlier leg is loaded; no false "no destination has Archive to P5 selected" warning |
| Card accuracy | Source/step context, path, queue state, verification, sort, proxy, and P5 fields match the authored job |
| Loaded session order | A loaded queued session draws first, labelled "runs first" |

### Suite alignment

| Test | Expected result |
|---|---|
| Drop Verify version | Reports 2.7.2 Build 14; launches and completes a smoke verify |
| Folder Copy Compare version | Reports 2.7.2 Build 14; launches and completes a smoke compare |
| No behaviour change | Neither app differs from Build 8 in proxy, manifest, or verification behaviour |
| Update check | Each app's Check for Updates resolves against the published release |

## Regression watch

These were fixed earlier in the 2.7.2 line and are worth one pass each, because Build 29
touches the same queue and session code:

- Reset Session clears every piece of session state, not most of it (Build 24).
- What's New shows only the shipping release (Build 21), and is CopyTrust-only and back
  to four bullets (Build 25).
- The pre-copy review stops for the two choices that quietly do the wrong thing
  (Build 22).
- Relay chains keep their sensible per-stop defaults (Build 23).
- A second relay using the same paths receives a new sequence identity and does not
  reuse the older relay's queue rows.
- Destination Sort still applies only to the final destination of a relay chain — a
  known limitation, not a Build 29 regression.
