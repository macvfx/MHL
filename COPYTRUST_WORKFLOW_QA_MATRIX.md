# CopyTrust 2.7 Workflow QA Matrix

Date: 2026-08-07
Applies to: CopyTrust 2.7.2 Build 31; includes per-source progress lines and corrected file-copy counts (Build 31), the one-blue-action-button colour rule (Build 30), the single `Copy` switch and single `Start` button (Builds 25/29), relay-chain per-stop defaults (Build 23), interrupted-job recovery (Builds 26/27), the relay-export crash fix (Build 29), plus Build 11's visual workflow review, immutable relay plans, structured workflow logs, relay-sequence isolation, relay-aware P5 pre-checks, and per-destination proxy routing; keep the 2.5.3 stable line available for comparison
Purpose: one current, auditable pass through the operator workflows that are
otherwise spread across the User Guide, Field Checklist, QA Run Sheet, and
release-specific notes.

This matrix tests what an operator actually does. It does not replace the unit
suite or real-media testing. Run it with expendable fixtures before a beta is
treated as production-ready.

## Evidence Rules

For every row record:

- app version and build;
- macOS version and machine;
- source and destination filesystem types;
- selected Card or Folder mode;
- selected verification level;
- expected and actual result;
- session ID and log path;
- receipt, manifest, and generated-artifact paths;
- screenshot filename when the row has a visual checkpoint.

Use `PASS`, `FAIL`, or `N/A`. A green UI state alone is not proof: inspect the
destination and the receipt/log evidence.

## Automated Baseline

The CopyCore and CopyTrust test suites are run from the CopyTrust source
repository before the operator matrix below. This repository holds documentation
only, so there is nothing to build here.

Confirm before starting the operator matrix:

- the automated suites passed on the build under test;
- no failed or unexpectedly skipped tests;
- proxy encode tests ran, which needs CopyTrust's packaged `ffmpeg` and `ffprobe`
  installed at `/usr/local/bin`;
- the test results are retained with the QA evidence.

## Fixture Setup

Fixture generation and the ffmpeg proxy-comparison harness are scripts in the
CopyTrust source repository and are run there, not from this documentation repo.

Whichever fixtures you use, use separate writable destination roots. Never point
automated tests at production media or an irreplaceable camera card.

## A. Copy Mode and Pre-Copy Confirmation

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| A1 | Card defaults | Select Card mode and open Settings. | Inline verification, Card naming, Card exclusion profile, contact sheet and configured Card post-copy actions are shown. |
| A2 | Folder defaults | Select Folder mode and open Settings. | Folder profile remains independent; Quick is the default unless deliberately changed. |
| A3 | Mode isolation | Change one Card-only setting, switch to Folder, then return. | Folder is unchanged and Card retains the change. |
| A4 | Confirmation enabled | Start a prepared fixture session. | Confirmation names Card/Folder, verification, sorting, contact-sheet split, enabled artifacts, and a dedicated Proxy line. |
| A5 | Proxy off clarity | Disable proxy media and start. | Confirmation and log say `Proxy: Off` / `proxy=off`; absence is explicit. |
| A6 | Queued snapshot | Queue a Card job, then change mode/settings before queuing a Folder job. | Each queue row has the correct preset badge and later runs using its captured settings. |
| A7 | Direct topology | Start one source to one destination. | Top diagram shows source → destination and the destination card agrees with the configured choices. |
| A8 | Fan-out topology | Start multiple sources and/or destinations. | Diagram identifies the multi-source/multi-destination job and every destination has a separate card. |
| A9 | Relay topology | Queue a relay and start it. | Diagram shows the ordered relay chain; cards identify step and dependency context. |
| A10 | Active plus queue topology | Start a job with two later items queued. | Diagram distinguishes the active source/destination and reports two queued items. |

Visual checkpoints: `01-copy-mode.png` and `05-post-copy-actions.png`.

## B. Naming and Renaming

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| B1 | Preserve original folder name | Run Settings → Test → Naming Preservation with preservation enabled. | Case, spaces, dashes, underscores, and trailing digits are retained; filesystem-illegal characters alone are removed. |
| B2 | Naming template | Disable preservation and use `{alias}_{date}` with a prefix. | Preview, destination folder, receipt, and manifest agree. |
| B3 | File prefix | Run Settings → Test → File Prefix. | Every eligible destination filename has the rendered prefix; verification references the renamed path. |
| B4 | Length guard | Use a source alias/template exceeding the filesystem component limit. | UI warns and deterministic truncation avoids a copy failure. |
| B5 | Queue destination alias | Expand a queued row and edit its destination alias. | Alias changes immediately without loading the job; path remains unchanged. |
| B6 | Duplicate rendered names | Add two sources that render to the same destination subfolder. | Start is blocked before mutation with a specific duplicate-name message. |

Visual checkpoint: `02-direct-session.png`.

## C. Direct Copy and Verification Modes

Run a small `A → B + C` fixture once per verification level.

| ID | Mode | Expected copy proof |
|---|---|---|
| C1 | None | Files arrive; receipt clearly records no verification and no MHL. |
| C2 | Quick | Destination existence and size are checked; delivered-file inventory is present; no hashes or MHL are invented. |
| C3 | Full | Copy completes, then destination files are batch hashed and an MHL is written. |
| C4 | Inline | Each file is hashed during copy and immediately checked at each destination; an MHL is written. |
| C5 | Fan-out | Both destinations independently complete the selected trust level and have separate receipts/evidence. |
| C6 | Existing folder safety | Pre-create the rendered destination folder without recognised resume state. | Start is blocked; CopyTrust never silently merges a fresh ingest. |
| C7 | Recognised resume | Cancel a fixture run, then resume the same source/destination. | Completed files are reused and remaining files continue without duplicating output. |

## D. Destination Sort

Test Preserve Structure and Flatten.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| D1 | Type folders | Run Settings → Test → Destination Sort. | Enabled categories contain the configured extensions; disabled categories do not move files. |
| D2 | Preserve Structure | Select Preserve Structure. | Category folders retain the source-relative hierarchy. |
| D3 | Flatten | Select Flatten with duplicate basenames. | Files are flat and collisions become `_2`, `_3`, and so on without overwriting. |
| D4 | Delivery MHL | Verify the MHL after sorting. | It resolves against the sorted paths and passes; the source-layout MHL is archived in receipts. |
| D5 | Two destinations | Run `A → B + C` with sorting. | Both destinations independently receive a verifiable sorted layout and provenance record. |
| D6 | Relay rule | Run `A → B → C` with sorting. | B remains unsorted and safe as the next source; only final destination C is sorted. |
| D7 | Reconnect after sort | Disconnect only after sorting finishes, then reconnect. | Sort does not run twice; no `_2` duplicates or duplicate source-MHL archive appears. |

Visual checkpoint: `05-post-copy-actions.png`.

## E. Secondary Artifacts

Enable contact sheet, EXIF CSV, and HTML tree. Repeat E1–E5 in Quick and Inline.

| ID | Check | Expected evidence |
|---|---|---|
| E1 | Delivered inventory | PDF/CSV/tree are generated from delivered files even when Quick has no hashes. |
| E2 | Independent states | Run PDF/CSV/tree plus a slower proxy job and watch each row. Each artifact row reaches Done, Failed, Skipped, or Nothing to do as soon as its own generator finishes; completed descriptive rows show checkmarks while Proxy Media alone continues spinning. |
| E3 | Contact sheet | PDF opens and has the configured layout, source name, verification state, and expected media/placeholders. |
| E4 | EXIF CSV | CSV contains delivered media rows and subject-first filename. |
| E5 | HTML tree | Selected tree mode produces the expected native HTML output. |
| E6 | Retry one artifact | Delete one artifact and use its retry action. Only that artifact is rebuilt. |
| E7 | Zero-work outcome | Use a fixture with no eligible media for a requested artifact. UI reports Nothing to do and stops. |
| E8 | Package placement | Copy an expendable `.fcpbundle` in Folder mode. Receipts/artifacts are siblings of the package, never children. |

Visual checkpoint: `05-post-copy-actions.png`; retain artifact-result
screenshots as manual QA evidence when executing E1–E8.

## F. Proxy Media Beta

Use expendable media. The verified original remains the trust result even if a
proxy fails.

| ID | Check | Expected evidence |
|---|---|---|
| F1 | H.264 50% | H.264 High MOV has half-width and half-height, matching duration/frame rate/audio-track count/timecode where available. |
| F2 | HEVC 25% | HEVC Main 10 MOV has quarter-width and quarter-height with 10-bit pixel format. |
| F3 | Final Cut layout | Final Cut option creates `Final Cut Proxy Media/YYYY-MM-DD/.../OriginalBasename.mov`. |
| F4 | Progress | Long encode shows clip/total, percent, speed, and ETA in UI and periodic log lines. |
| F5 | Evidence bundle | JSON, TXT, and LOG exist under `CopyTrust_Receipts/Proxy Media` and agree on settings and outcomes. |
| F6 | Relink | Final Cut can relink the generated proxy using the preserved original basename and compatible media properties. |
| F7 | Retry | Delete one proxy evidence file and retry missing artifacts. Evidence is regenerated without changing the verified original. |
| F8 | Cancel | Cancel during encode. Encoder exits and no `.partial.mov` remains. |
| F9 | Unsupported decoder | Test an expendable proprietary/unusual codec. | Failure is isolated, explicit, retryable, and does not alter original verification. |
| F10 | Package placement | Proxy folders created for an `.fcpbundle` are siblings, not package contents. |
| F11 | Unspecified audio language | An original reporting audio language `und` and a proxy omitting that tag both normalize to unspecified; a successful encode completes instead of becoming a false failure. |
| F12 | Retry status | Selecting Retry immediately changes a terminal failed proxy row to Running; completion then replaces it with a checkmark or a new actionable failure. |
| F13 | Per-destination selection | Enable proxies for two destinations, uncheck **Create proxies** on one, and run an expendable copy. | Proxies and proxy evidence are created only on the checked destination; originals and other enabled artifacts still reach both. |
| F14 | Multiple proxy destinations | Check **Create proxies** on both destinations. | Both destinations receive independently validated proxies and evidence. |
| F15 | Rotated portrait source | Generate a proxy from expendable media whose encoded frame is landscape and whose display matrix is 90 or 270 degrees. | The proxy is portrait; validation uses displayed dimensions and passes. JSON/TXT evidence records encoded frame, displayed frame, and rotation. |
| F16 | Full-range source color | Generate H.264 from an expendable source reported as full range (`pc`). | Proxy remains full range, validation passes, and receipt color range/space/transfer/primaries accurately distinguish reported values from N/A defaults. |

Visual checkpoint: `05-post-copy-actions.png`; retain proxy progress and
evidence screenshots as manual QA evidence when executing F1–F16.

## G. Mixed Queue

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| G1 | Stage two jobs | Queue Card A, then queue Folder B with different destinations/settings. | Two distinct ordered rows with correct source, destinations, and preset badges. |
| G2 | Reorder | Move a standard row before or between other pending rows. | Visible order and execution order match. |
| G3 | Inline review | Expand rows and inspect/edit aliases. | Multiple rows can be reviewed without loading or resetting the workspace. |
| G4 | Load/Return | Load a pending row, then Return to Queue. | Workspace clears and the queue remains intact without duplication. |
| G5 | Add while running | During a copy use `+ Add`, then also test drop-to-queue. | Active copy continues; new batch is staged with explicit source/destination/mode. |
| G6 | Start Queue latch | Queue Card and Folder jobs, capture Auto off in one profile, then click Start Queue. | The complete runnable list advances after each trust-complete copy; per-profile Auto does not stop the explicit queue run. |
| G7 | Cancel/Resume Queue | Cancel the active job while another remains. | Resume retries current work; Resume Queue skips to remaining queued work. |
| G8 | Persistence | Quit and relaunch with pending jobs. | Pending queue restores once, in order, without duplicates. |
| G9 | Reset warning | Use Reset Session only after confirming the destructive warning. | Workspace and complete queue are cleared; Return to Queue remains the safe unload action. |
| G10 | Per-job artifact snapshot | Queue jobs with different artifact/proxy settings and start the queue. | Each job's background outputs match its captured settings even after the next profile activates. |
| G11 | Completion states | Observe a job after copy while artifacts/P5 remain active. | Row distinguishes Copy complete, Artifacts running, P5 archive running, needs attention, and Fully complete. |
| G12 | Structured workflow log | Inspect each job's session log. | `workflow setup`, source, and per-destination entries record topology, queue item, verification, artifacts, proxy and P5 choices. |
| G13 | Every source is visible (b31) | Stage **two** cards against the **same two** destinations and start. | Queue row is titled `2 sources`, status line reads `Source 1 of 2`, and one line per source appears below with its own bar: the running card `Copying & Verifying NN%`, the waiting card `Waiting`. Neither card is hidden at any point in the run. |
| G14 | Counts are in one unit (b31) | During G13, compare the menu bar popover, the queue row status line, and the activity log heartbeat. | All three agree and all read **file copies**: a 47-file card to two destinations counts toward `94`, never `47`. Bytes copied never exceeds the byte total shown beside it. |
| G15 | Whole-run bar (b31) | During G13, watch the row's main bar as the first card finishes and the second starts. | The bar advances continuously across both cards. It does **not** reach 100% at the end of card one and restart from zero. ETA is labelled `left on this source`. |
| G16 | Single source unchanged (b31) | Run one card to two destinations. | No per-source lines, no `Source N of M`, no All-sources bar. Row title is the card's name. |

Visual checkpoint: `03-mixed-queue.png`.

G13–G16 exist because the pre-b31 UI named only the active source and mixed units in its
counts — a 47-file card to two destinations reported `75 / 47 files` in the menu bar, and the
second staged card was invisible until its turn came.

## H. Relay Chain

Use one source and at least two ordered destinations.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| H1 | Create chain | Load A, then B and C in order; set `Copy` to `In series`; click `Start`. | The pre-copy review appears showing the full chain, then the queue shows Step 1 and Step 2 with one sequence identity and dependency. |
| H2 | Correct source binding | Continue past the review. | Step 1 copies A → B; Step 2 reads the verified B output and copies B → C. |
| H2a | One button, one label | Check the primary button with one destination, with `Simultaneously`, with `In series`, and with a queued session loaded. | It reads exactly `Start` in every state. No `Queue Relay Chain` button exists above the destinations, in the queue panel, or in a destination row's context menu. |
| H2b | Review is unskippable | Build a chain and start it. | The pre-copy review fires every time — the Build 25 fix for chains that previously ran with no review at all. |
| H2c | Chain survives its first stop | Run a two-stop chain to the end of stop 1. | The app stays up (Build 29 crash), each destination's `CopyTrust_Receipts` gains exactly one workflow plan with no `.tmp` beside it, and stop 2 starts on its own. |
| H2d | Per-stop defaults | Build a fresh chain with P5 archiving enabled. | `Archive to P5` lands on the first stop and `Create proxies` on the last; a deliberate per-row choice already made is not relocated. |
| H3 | Trust gate | Introduce an expendable Step 1 failure. | Step 2 stays blocked and never starts from an untrusted intermediate. |
| H4 | Edit before start | Use Edit on an untouched chain and reorder destinations. | All legs return to the workspace in order, the `Copy` switch still reads `In series`, and `Start` rebuilds the chain without duplicates. |
| H5 | Edit after start | Start one leg and attempt Edit. | Edit is unavailable once the chain has begun. |
| H6 | Final-only sort | Enable Destination Sort. | Intermediate B remains stable/unsorted; final C is sorted and verifiable. |
| H7 | Artifacts | Enable background artifacts. | Later relay leg does not wait for PDF/CSV/tree/proxy work after upstream trust completes. |
| H8 | Speed receipt | End session. | Receipt identifies every leg and gives per-leg copy/verify speeds. |
| H9 | Card release | After Step 1 becomes trust-complete, inspect safe-to-eject state. | Original card can be released while downstream work continues from B. |
| H10 | Immutable workflow plan | Build a relay, inspect `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json`, then run it. | Plan exists before execution, contains ordered step/dependency IDs and explicit destination choices, contains no password, and its bytes do not change. |
| H11 | Receipt export linkage | Inspect every relay leg's receipts. | The same workflow plan is exported into each `CopyTrust_Receipts` folder and logs link the active queue item back to it. |
| H12 | Sequence isolation | Run a relay to completion, then build another relay with matching paths. | The second chain has a new sequence ID and does not reuse the first chain's completed rows or dependencies. |
| H13 | Interrupted chain recovery | Force quit during stop 1, after its files and `completed` manifest are on the destination. Relaunch. | The finished stop is restored as **completed**, stop 2's upstream path resolves to where the files actually landed, and the chain carries on — it does not come back stuck or ask you to redo a finished copy. |
| H14 | Interrupted chain, nothing finished | Force quit early in stop 1, before any completion manifest exists. Relaunch. | The stop is restored as **queued**, never failed, with no stale block reason on the stop behind it. |

Visual checkpoint: `04-relay-chain.png`.

## I. Archiware P5 Archive (2.7.0 testing)

Use expendable fixtures and a non-deleting archive plan.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| P1 | Connection and discovery | Enter the P5 server and credentials, then use Test Connection & Load. | Live archive indexes, P5 clients, and plans populate; password is stored in Keychain and absent from preferences/request JSON. |
| P2 | Delete-plan guard | Select a plan whose details report `deletefiles` or `deleteall`. | Plan is visibly unsafe and automatic submission is blocked. |
| P3 | Client path visibility | Confirm the selected P5 client can resolve the destination at the same absolute path. | Preflight succeeds; a hidden or differently mounted path produces a deferred/error state rather than a false success. |
| P4 | Full/Inline submission | Run a small Full or Inline verified copy with automatic P5 archive enabled. | Request JSON contains valid 16-digit xxHash64 values, P5 job ID/state, and the server accepts the archive selection. |
| P5 | Quick gate | Run Quick verification with deferred JSON enabled. | No automatic submission; request state is `needs_hash_verification` and no hash is invented. |
| P6 | GUI metadata | Inspect and search the archived originals in P5. | `CT_*` keys are visible/searchable and contain expected hash, frame/image size, kind, codec/timecode/camera values when available. |
| P7 | Supporting evidence | Inspect the selection/request. | MHL, provenance, receipts, contact sheet, EXIF CSV, and proxy evidence that exist are marked as supporting evidence. |
| P8 | Offline P5 | Stop or misconfigure the test server and run an eligible copy. | Copy remains successful; password-free deferred request records the actionable error and can be dry-run by the helper. |
| P9 | Restore verification | Restore the fixture through P5 and verify it against the archived MHL. | Restored file count/path are reviewed and every file xxHash64 matches before acceptance. |
| P10 | Multi-destination selection | Copy to two expendable destinations and check **Archive to P5** beside one. Then check the other destination. | The P5 checkbox is single-select; ordinary enabled artifacts reach both, proxies follow each destination's **Create proxies** checkbox, and only the currently checked P5 destination is submitted. |
| P11 | Queue overlap | Run two queued copies while the first P5 job is deliberately slow. | The second copy starts after the first trust gate; first-job P5 progress stays on its own row and does not overwrite live copy status. |
| P12 | Relay-chain P5 pre-check | Build a two-stop relay chain and select **Archive to P5** only on the second stop, then start the first leg. | Confirmation names the selected relay destination and does not warn that no P5 destination is selected. |

Known tested baseline (private fixture identifiers anonymized): P5 8.0.4
archived a CopyCore Inline-verified PNG, text sidecar, and MHL to a non-deleting
test index; readback returned both complete hashes, `64x36` image dimensions,
and the expected CopyTrust fields.

## Ship Decision

Do not call the workflow ready if:

- any trust-critical row fails;
- an artifact remains permanently queued/running;
- queue or relay dependencies can start out of order;
- proxy work changes the verified-original result;
- P5 accepts a Quick/copy-only job, a source-deleting plan, or an incomplete hash;
- P5 job/metadata cannot be confirmed in its own web GUI;
- package artifacts are written inside `.fcpbundle`;
- the published guide contains stale controls, missing screenshots, duplicate
  images, or broken links.

Record the final decision:

- Build:
- Automated baseline:
- Operator matrix:
- Known beta exceptions:
- Decision: `SHIP BETA / HOLD`
- Reviewer:
- Date:
