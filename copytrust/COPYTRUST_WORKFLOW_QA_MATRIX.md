# CopyTrust 2.7 Workflow QA Matrix

Date: 2026-08-22
Applies to: CopyTrust 3.0.2 build 64. Sections A to K were written for 2.7 and re-checked since; a failure
in them is a regression in something long settled.
Sections L to N were added 14 Oct 2026 for the 2.9.8 field-test work; section O (the Monitor Hub and live
progress) was added 17 Oct 2026 for 3.0.
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
| A1 | Card defaults | Select Card mode and open Settings. | Inline verification, Card naming, contact sheet and configured Card post-copy actions are shown. Settings ▸ Exclusions has **no row checked** (build 56). |
| A2 | Folder defaults | Select Folder mode and open Settings. | Folder profile remains independent; Quick is the default unless deliberately changed. Settings ▸ Exclusions has **only the System group checked**; Receipts & Manifests, Proxies and Camera Card are unchecked (build 56). |
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
| F5 | Evidence bundle | JSON, TXT, and LOG named `<folder>_proxy-receipt_<stamp>` exist under `Receipts` (before 2.9.8, in a `Receipts/Proxy Media` subfolder) and agree on settings and outcomes. |
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

| G17 | Proxy progress shows the work left (b32) | Run a card with several clips to two destinations, proxies on. Watch the Proxy Media row. | Reads `N of M · <card> → <drive> · NN%` where M counts every encode across both destinations (5 clips × 2 destinations = 10), not a per-destination `2/5`. Codec/speed/ETA appear only in the activity log. |
| G18 | Menu bar during post-copy work (b32) | When the copy finishes but proxies are still encoding, open the menu bar popover. | Shows "No active copies", the cards ready to eject, and the running proxy progress — not the bare idle view. Reverts to the plain idle view once artifacts finish. |
| G19 | Stalled artifact recovers (b32) | Let a run complete with artifacts enabled. If any artifact row stops changing, leave it. | Within five minutes the source turns to `Artifacts stalled — retry`, the stuck artifact rows become individually retryable, and the log records `secondaryArtifacts stalled … lastMessage="…"`. No row spins indefinitely and Rebuild All is not required. |
| G20 | Two cards, both artifact sets finish (b32) | Run two cards to the same two destinations with contact sheet and proxies on, Auto on. | Both sources reach `secondaryArtifacts complete`. Specifically the first card's contact sheet finishes its second destination and its proxies run — they must not stop when the second card's copy begins. |

| G21 | End Session always ends (b32) | With background artifacts running, press `End Session` in the bottom action bar. | It offers **End Now** and **Wait**. End Now closes immediately. Wait closes once artifacts finish — and closes anyway, logging `closeSession abandoning stalled backgroundArtifacts`, if they go silent for a minute. It must never sit on "Finishing background artifacts…" indefinitely. |
| G22 | Review Summary is readable (b32) | Open Review Summary on a run with warnings, then resize the sheet. | Session Health and the receipt text grow with the window rather than staying in fixed boxes. Default sheet is 680×640. |

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
| H2b | Review is unskippable | Build a chain and start it. | The pre-copy review fires every time; a chain can never run without one. |
| H2c | Chain survives its first stop | Run a two-stop chain to the end of stop 1. | The app stays up, each destination's `Receipts` gains exactly one workflow plan with no `.tmp` beside it, and stop 2 starts on its own. |
| H2d | Per-stop defaults | Build a fresh chain with P5 archiving enabled. | `Archive to P5` lands on the first stop and `Create proxies` on the last; a deliberate per-row choice already made is not relocated. |
| H3 | Trust gate | Introduce an expendable Step 1 failure. | Step 2 stays blocked and never starts from an untrusted intermediate. |
| H4 | Edit before start | Use Edit on an untouched chain and reorder destinations. | All legs return to the workspace in order, the `Copy` switch still reads `In series`, and `Start` rebuilds the chain without duplicates. |
| H5 | Edit after start | Start one leg and attempt Edit. | Edit is unavailable once the chain has begun. |
| H6 | Final-only sort | Enable Destination Sort. | Intermediate B remains stable/unsorted; final C is sorted and verifiable. |
| H7 | Artifacts | Enable background artifacts. | Later relay leg does not wait for PDF/CSV/tree/proxy work after upstream trust completes. |
| H8 | Speed receipt | End session. | Receipt identifies every leg and gives per-leg copy/verify speeds. |
| H9 | Card release | After Step 1 becomes trust-complete, inspect safe-to-eject state. | Original card can be released while downstream work continues from B. |
| H10 | Immutable workflow plan | Build a relay, inspect `COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json`, then run it. | Plan exists before execution, contains ordered step/dependency IDs and explicit destination choices, contains no password, and its bytes do not change. |
| H11 | Receipt export linkage | Inspect every relay leg's receipts. | The same workflow plan is exported into each `Receipts` folder and logs link the active queue item back to it. |
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

## K. Source Manifest (2.7.8)

| ID | Scenario | Steps | Expected |
|---|---|---|---|
| K1 | Arrival manifest found | Stage a folder with a vendor `.mhl` at its root, and one with `ascmhl/`. | The row names the tool and entry count for both, before any copy. |
| K2 | No manifest | Stage an ordinary card. | The row says none was found. Absence stated, not silent. |
| K3 | Unreadable manifest | Put a truncated `.mhl` beside a source. | Reported as present and unreadable — never as absent. |
| K4 | Intact card, Inline | Copy K1's card. | Green Source Provenance card, all entries matched, tool credited. No measurable time added to the copy. |
| K5 | Damaged card | Alter a byte after the manifest was written; copy. | Copy completes and verifies clean; source verdict red and names the file. Both recorded as separate fields. |
| K6 | Partial coverage | Manifest mixing xxHash64 with MD5 entries. | Amber *Partly checked*, never a green seal. |
| K7 | Quick verification | Copy K5's card with Quick. | No source verdict at all, and the staging row said so beforehand. |
| K8 | Our own manifest | Re-stage a CopyTrust delivery. | Credited as ours, no arrival verdict. |
| K9 | Resumed copy | Cancel part-way, resume. | Same verdict as an uninterrupted copy of the same card. |
| K10 | Fan-out | Two destinations. | One verdict per source in the log, not one per destination. |

## L. Space, Skipped Drives and Topping Up (field test 13 Oct 2026)

Reference: `COPYTRUST_CAPACITY_DECISION_GATES.md`. Use a deliberately small second destination (a
small SSD or a disk image under one card's size), never a client's drive. Free space is read fresh
at the review and again as each card starts, so freeing or filling a drive between rows changes
what the next row shows.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| L1 | Full drive is a warning | Stage one card and two destinations, the second with less free space than the card. | Second drive's row and the card's badge read as a warning (*this drive will be skipped for this card*), not a red failure; the aggregate badge says warnings, not failed. |
| L2 | Start is not held | With L1 staged, auto-advance off. | Start is enabled. The pre-copy review names the second drive with free and needed figures, and appears even if the routine review is switched off. |
| L3 | Skipped whole | Run L2. | Card complete and verified on the first drive; **no folder and no file** on the second. Log `performCopy destinationSkipped … reason=no-space`; copy map row *skipped: no room*. |
| L4 | Queue does not halt | Three cards, the second drive able to hold only the first; auto-advance on; Start and leave. | All three cards run. No `autoAdvance blocked … preflight=fail`. Cards 2 and 3 are on the first drive only, and owed to the second in the copy map. |
| L5 | Nothing has room | One card larger than every destination's free space, a smaller card queued behind it. | Nothing written anywhere; the card reads *No destination has room … Nothing was written* and can be resumed; the smaller card is attempted next. Log `performCopy noRoom`. |
| L6 | Margin | A card whose size equals a drive's free space to within 0.5%. | That drive is skipped (size plus margin does not fit); the review and copy map give the free and needed figures. |
| L7 | Banner appears and follows | Stage cards that do not all fit; remove a card; add a drive. | The banner names the cards with no copy and those below the preferred copies, with bytes; it updates on each change. |
| L8 | Extra-cards drive | Use *Add one for just the N extra cards*; run. | The new drive is badged, takes only a card that did not fit elsewhere, and shows *not needed* for a card that fit the main drives. |
| L9 | Copies policy | Settings › Copy Behaviour: minimum 1, preferred 2; then with one destination only. | With one drive the preferred count is capped at one, and no shortfall is reported; with two drives and a skipped card the card is reported below preferred. |
| L10 | Top-up | After L3, free the space and press *Copy to 1 missing*. | Same folder name on the missed drive; the first drive untouched; copy map shows both verified, nothing owed. A drive still without room is skipped again with its reason. |
| L11 | Copy map files | After any of the above. | `CopyMap_<session>.csv` and `.json` in the `Receipts` folder of each drive that received something, and in `~/Library/Application Support/CopyTrust/CopyMaps`; rows sorted by unit so A-cam cards sit together. |
| L12 | Eject policy | Try to eject the card from L3 before the top-up, manually and with auto-eject on. | Manual eject warns that the card is short of the preferred copies for want of room and asks; auto-eject does not eject. After L10 the warning is gone and auto-eject is allowed. |
| L13 | Eject while in use | During a copy, try to eject the source, then a destination. | Both refused with the reason. Between cards a destination may be ejected. |
| L14 | Whole-run progress | Run four cards to two destinations. | Headline bytes, file copies, speed and time left refer to the run; the card line says *Card N of 4*; the menu bar agrees. With a skipped drive the totals count only the copies that will be written. |
| L15 | Same structure | Stage a drive with no project folder beside one with it; choose *Use the same structure as…*. | Folders to create are listed in the review and made only at Start; the delivery's provenance carries `structureCopiedFrom`. |

## M. Metadata Sources and the EXIF CSV (field test 13 Oct 2026)

Reference: `COPYTRUST_METADATA_COLLECTION_REVIEW.md`. Use cards from at least two camera families
(for example Sony XAVC S MP4 with `M01.XML`, Canon Cinema EOS MXF with `.XML`, an Atomos MOV).

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| M1 | Sidecar fills what the container lacks | Copy a Sony and a Canon card. | EXIF CSV `CameraSerialNumber`, `Lens`, `FirmwareVersion` and (Sony) `StartTimecode` are filled; Canon firmware is the sidecar's, not `1`. |
| M2 | ffprobe over ExifTool | Switch ExifTool on and copy the Canon card. | `StartTimecode` is `HH:MM:SS:FF`, not seconds; `BitrateMBps` is tens of MB/s, not 0.144. `MetadataSources` credits ffprobe for both. |
| M3 | Date basis | Copy a MOV and an MXF. | MOV: `DateBasis=utc`, no wall-clock; MXF: `camera-local` with `DateTakenWallClock` equal to the camera's own clock. |
| M4 | Implausible date | Copy clips from a recorder whose clock was never set. | `DateNote` reads *date looks like a reset clock*; `DateTaken` is unchanged. |
| M5 | Checked against the file | Any card where a tool reports a bitrate far from size over duration. | `BitrateMBps` is the file's figure, `MetadataSources` says `Derived`, `MetadataNote` says what was replaced. |
| M6 | Contact sheet | Open the sheet for M1. | Lens and serial shown; the date line says *UTC, shown local* or *camera clock*; the footer lists the tools used with clip counts. |
| M7 | Drop Verify matches | Run the same folder through Drop Verify. | Same columns, same order, same values as CopyTrust's CSV. |

## N. Remote Notifications (field test 13 Oct 2026)

Use a Pushover account or a test webhook (a local listener on this Mac is enough). Nothing here
should ever contain a card, project, drive or folder name or a path.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| N1 | Test message | Settings › Notifications › Remote: enter credentials, *Save and send test*. | Message arrives; the sheet says it was sent. A wrong token says *refused*; no network says *unreachable*. |
| N2 | Run finished once | Three cards, to completion. | One *all cards finished* message with counts, not three. A card left unstarted keeps the run open. |
| N3 | Failure | Make a copy fail (eject a destination mid-copy). | A *copy failed* or *needs attention* message at high priority, naming nothing. |
| N4 | Drive events | Disconnect and reconnect a destination. | *Drive disconnected* then *available again*, and *resumed* if it auto-resumes. |
| N5 | Content check | Read every message received during N1 to N4, and the webhook's raw body. | No card alias, project, volume name or path anywhere; only counts and fixed sentences. |
| N6 | Secrets | Inspect Preferences and the session log. | Token, user key and webhook URL are in the Keychain only; the log has `remoteNotify event= outcome=` lines and nothing else. |

## O. CopyTrust Monitor Hub: live progress (field test, unreleased)

Needs CopyTrust Monitor 0.3 on a second Mac or the same Mac, and CopyTrust with *Send live progress*
switched on. Nothing sent may contain a card, project, drive or folder name or a path.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| O1 | Connect | Monitor: Live status ▸ Copy Link. CopyTrust: Settings › Notifications › CopyTrust Monitor Hub, paste, turn on, *Save and send test status*. | Settings says the hub accepted the test; the Monitor lists the station as Idle. The notifications webhook link says the hub did not recognise the URL. |
| O2 | Off by default | Fresh settings. | Nothing is sent until the toggle is on; turning it off stops updates at once. |
| O3 | Live copy | Several cards to two destinations, verification on. | Scanning, Copying, Verifying with percent, bytes, speed and time left agreeing with CopyTrust's own progress. Copied never exceeds the total. Verifying never shows Finished. |
| O4 | One run | Watch between cards. | *Preparing* between cards; the same run continues; the card position rises. No new card appears. |
| O5 | Auto-advance off | Leave the next card unstarted. | After about 15 seconds: Waiting for an operator, *The next card needs to be started*. Never Finished. *Start Next Card* in the progress window starts it. |
| O6 | Resume | Unplug a destination mid-copy, leave it stopped. | After about 15 seconds: Waiting for an operator, *A card stopped and can be resumed*. Resuming continues the same run. |
| O7 | Background jobs | Turn on proxies or reports for two or more cards. | After copying: Background work, *Background jobs: X of Y done* rising, ready-to-eject count; Finished at the end. |
| O8 | Hub down | Quit the Monitor mid-copy, then reopen it. | The copy is unaffected. The station shows Status unknown, then Live when it reports again. |
| O9 | Network loss | Take the station off the network for a minute. | Update delayed at 15 seconds, Status unknown at 45; never Finished or Failed on its own. |
| O10 | Two stations | Two CopyTrust Macs, same hub. | Separate cards. Same name on both: a short ID suffix appears on the wallboard. Forget Station removes a retired one. |
| O11 | Content check | Capture the traffic or read the hub's status JSON. | Numbers and fixed words only. No names, paths, volume names, URL secret or observed network address. |

## P. Builds 55 to 58 (field test 20 Oct 2026)

Use a Mac with default settings (or **Preset ▸ Unload ▸ Reset Settings to Defaults**) unless a row says otherwise. Builds 55 to 57
were never published separately, so test them as one: build 58 onward carries all of them.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| P1 | Clean Quick copy is green | Two cards, verification **Quick**, to one destination, to completion. | Completed This Run shows a green thumbs-up and **copied & verified** on both; no orange triangle. Review Summary says Clean and MHL Files says *no MHL*. Each card's trust status reads **Ready to eject**. |
| P2 | Inline and Full still write an MHL | Repeat P1 with **Inline**, then **Full**. | An MHL is written and listed; both cards stay green. |
| P3 | A real problem still turns amber | Make a card need a look (verification fails, or delete the MHL after an Inline copy and reopen the summary, or use fewer verified copies than the minimum). | Orange triangle and **copied — check before ejecting**, with the first reason in small grey text beneath (and *+N more* when there are several). Not green. |
| P4 | Card exclusions all off | Settings ▸ Exclusions in **Card** mode on default settings. | No row is checked in any group, including System and *Final Cut Relink Aliases*. |
| P5 | Folder exclusions: System only | Same in **Folder** mode. | Only the System group is checked. Receipts & Manifests, Proxies, Camera Card and *Final Cut Relink Aliases* are unchecked. |
| P6 | A proxy folder is copied | Folder mode: copy a folder holding `Final Cut Proxy Media/<date>/clip.mov`, `CopyTrust_Proxies/clip.mov` and a `.DS_Store`. | Both proxy folders arrive with their files. The `.DS_Store` does not (System is on in Folder mode). The log line `performCopy exclusions … active=[…]` names no proxy folder. |
| P7 | Card mode copies everything | Card mode: the same tree. | Everything arrives, `.DS_Store` included. |
| P8 | A loaded preset brings its exclusions | Load a preset saved before build 56 (or one with rows ticked). Open Settings ▸ Exclusions. | The rows it was saved with are checked. Untick them, **Update … from Current Settings**, reload: they stay unchecked. |
| P9 | Unload, keep settings | Load a preset, then **Preset ▸ Unload ▸ Unload and Keep Current Settings**. | Toolbar reads *Preset*; Settings ▸ Enforced Naming says Off; verification, exclusions, proxies and notifications are as they were. Destinations already staged stay. |
| P10 | Unload, reset | Load a preset with non-default settings, then **Unload and Reset Settings to Defaults**. | Both modes return to the defaults (P4 and P5 hold). The preset file is still in the presets folder. The operator name and P5 server are unchanged. |
| P11 | Unload survives a relaunch | After P9 or P10, quit and reopen. | The preset does not come back: no name in the toolbar, no enforced naming, no destination check, no mount requests for its volumes. |
| P12 | Moving the file is not enough | Load a preset, move its `.json` out of the presets folder, relaunch. | Its naming rules are still in force (this is why Unload exists). Unload now clears them. |
| P13 | No Unload under a policy | On a Mac with a managed or enforced policy. | **Unload** is not in the menu. |
| P14 | Build a Preset: walk through | **Preset ▸ Build a Preset…**; step through every page in both Card and Folder (the *Settings for* switch), then read the summary. | Nine pages (eight without staged destinations); each reads back correctly on the last page; Back keeps what was set. |
| P15 | The builder starts clean | Load a preset that has exclusions and a naming template, **Unload (keep)**, then open the builder with *Start from this Mac's current settings* **off**. | The draft shows the factory defaults: no exclusions on in Card, System only in Folder, default naming. Nothing on this Mac changed before Save. |
| P16 | Start from this Mac | Turn the switch **on**. | The draft copies what Settings shows now. No naming convention, P5 server or destinations are carried. |
| P17 | Save loads it | **Save Preset**. | The preset is in *My Presets*, is loaded (name in the toolbar, no • until something changes), and Settings matches the summary. Enforced Naming says Off. |
| P18 | Duplicate name refused | Open the builder again and type the same name. | A warning appears and **Next** and **Save Preset** are disabled. |
| P19 | Destinations toggle | With two destinations staged, open the builder. | A *Destinations* page offers to include them; leaving it off saves a settings-only preset; turning it on and reloading stages them again. |
| P20 | Enforced builder unchanged | **Build an Enforced Naming Preset…** | Opens the same wizard as before and builds an enforced preset. |
| P21 | Folder under enforced naming: switch | With an enforced naming preset in **Card** mode, drop a plain folder (not a camera card) as a source. | The naming sheet shows *This looks like a folder, not a camera card…* and **Switch to Folder Mode**. Pressing it closes the sheet, the mode becomes Folder, and the source is still staged. The log has `namingAtAdd decision=switchToFolderMode … sourceKept=yes` and a `copyMode switch from=card to=folder` line. |
| P22 | Cancel is logged | Drop a folder as in P21, press Escape. | The source is removed, and the log says `namingAtAdd cancelled … decision=removed`. A real camera card shows no folder note. |
| P23 | Mode change releases waiting sources | Drop two sources under enforced naming, but do not answer the sheet (use *Switch to Folder Mode* on the first). | Neither source is removed. Nothing is left waiting for a name. The log shows `released by switch to Folder mode`. |
| P24 | Folder wording | Folder mode: copy two folders. | The progress reads *Folder 1 of 2*, the banner *Folder 1 · name*, the menu bar *1 of 2 folders done*. Card mode still says *Card*. |
| P25 | Hidden files default | CopyTrust on default settings, both modes: Settings ▸ Hidden Files. Copy a folder holding `.hidden_note.txt`. | *Skip hidden files* is off in both modes and the dot-file arrives. A Mac with a saved setting keeps it. |
| P26 | Drop Verify defaults | Drop Verify on default settings: Settings ▸ Exclusions. | Only the System group is checked; Receipts & Manifests, Media Files and Camera Card are unchecked. Verify a folder that holds a ShotPut `.mhl`: it is in the inventory. |
| P27 | Drop Verify second run | Verify a delivery twice with defaults, then again with the Receipts & Manifests rows ticked. | The second default run lists Drop Verify's own `Receipts` files and `.mhl`; with the rows ticked it does not. (This is the accepted consequence of the new defaults.) |
| P28 | Power in the log | On a laptop, start CopyTrust plugged in, then unplug it, then plug it in. Read the session log. | `power state source=ac …` at launch, `power changed from[source=ac …] to[source=battery …]` on unplugging (with `timeToEmpty` once macOS has one), and `power changed` again on plugging in. |
| P29 | Chip and banner | On battery, stage a card and a destination. | The bottom bar shows a battery chip with the charge and macOS's time left (grey). The banner above the destinations does **not** appear unless the queue is tight or will not fit (orange or red). Plugged in: a plug chip with the percentage, no banner. A desktop Mac: neither. Clicking the chip opens the detail. |
| P30 | Estimate against the queue | On battery at about 40% with a queue that needs longer than the charge, start the copy. | The banner turns orange or red with the needed time and the usable time, and the log has `power atCopyStart … advice[…]` and one `power WARNING`. |
| P31 | Heartbeat | Leave a copy running for over five minutes. | A `power heartbeat` line every five minutes with `remaining=` and `runETA=`. |
| P32 | Held at 80% | On a laptop held at 80% on AC (Optimized Battery Charging), copy for a while. | No banner and no warning: not charging at 80% on AC is normal. |
| P33 | Drain on AC | Run a long copy on a small adapter that cannot keep up. | After the charge falls 3 points, a note: *Plugged in, but the battery is draining*, and a `power WARNING (heartbeat)` line. |
| P34 | Connection chips | Stage a card (reader) and two drives on different ports. | Each row shows its chip (`USB 10 Gbps · SSD`, `USB 5 Gbps`, …); hovering shows the device name and port path. A network share shows `Network`; an internal volume `Internal`. |
| P35 | Slow-port warning | Plug a drive into a USB 2.0 port or behind a USB 2 hub, and stage it. | The chip turns orange (`USB 2.0 · 480 Mbps`) with a line: about 40 MB/s, try a different port or cable (or a faster hub). A card reader says *card reader*. Start is not blocked. The log has `link WARNING`. |
| P36 | Same drive, two ports | Copy to the same drive in two different ports (one fast, one slow), twice each. | `device_speed_history.json` has the connection on each sample, and the two ports show different `portPath` values. |
| P37 | Log lines | Stage volumes and read the session log. | One `link source=… / destination=… bus=… link=… port=… hubs=…` line per volume, with no paths. A drive that is unplugged and replugged is read again. |
| P38 | Older history | Open a build with a speed history file written before this build. | It loads with no error; older samples simply have no connection. |
| P39 | Chip colours | On battery, change the queue size or the charge so the estimate moves from fits, to little to spare, to will not fit. | The chip goes grey (`41% · 2h05m`), orange (`41% · needs 1h40m`), then red (`8% · plug in`); the banner appears only for orange and red. |
| P40 | Chip detail | Click the chip. | A popover with the source, charge, macOS's time estimate, adapter, and the queue estimate; it never blocks anything. |
| P41 | Relay order suggestion | In series, two drives with earlier copies on record (or on ports of clearly different speed), the slower one first. | Under the chain preview: *"SSD averaged 410 MB/s and NAS 88 MB/s. Put SSD first so the card is free sooner"* with **Move to Stop 1**. For ports without a record the line says *faster connection (about 900 MB/s) than … (about 400 MB/s)*. |
| P42 | Apply it | Click **Move to Stop 1**. | The drive becomes Stop 1, the chain preview updates, the suggestion disappears, and the log has `relayOrder decision=moved stop=… from=2 to=1`. |
| P43 | No guessing | In series with a drive that has neither a record nor a USB link (a network share, or a new drive). | No suggestion about that drive. With Simultaneously selected, or during a copy, no suggestion at all. |
| P44 | Cancel asks first | Start a copy and press **Cancel Copy** (progress sheet, main window, and queue manager). | Each asks *Stop this copy?* with **Stop Copy** and **Keep Copying**; the message says what is kept for the verification level. Keep Copying changes nothing. |
| P45 | Resume at Quick | Verification **Quick**, copy a card of many files to a drive, **Stop Copy** part way, start the same card again and accept the resume. | The files finished before the stop are reused (the receipt and log count them as reconciled) and only the rest are copied. It does not start from the first file. |
| P46 | A cut-short file is recopied | After P45's stop, delete one finished file on the drive, and cut another short (truncate it), then resume. | Both are copied again and match the source; the others are reused. |
| P47 | A touched file is recopied | After a stop at Quick, change the modification date of one finished file on the drive (touch it), then resume. | That file is copied again. |
| P48 | Inline is unchanged | The same at **Inline**. | Verified files are reused, unverified ones are copied and verified; nothing is reused on size and date alone. |
| P49 | A verified file that went missing | Inline copy, stop, delete a file the first run verified, resume. | The deleted file is copied again and is not counted as already done. |
| P50 | New Folder in the destination panel only | In Volumes click Dest on a drive, then Source on a drive. | The Dest panel has a New Folder button and a folder made with it can be added; the Source panel has none. |

## Ship Decision

Do not call the workflow ready if:

- any trust-critical row fails;
- an artifact remains permanently queued/running;
- queue or relay dependencies can start out of order;
- proxy work changes the verified-original result;
- a card is written partly to a drive that has no room for it, or a full drive holds Start or halts
  an unattended queue (section L);
- a remote notification or a live status update carries a name or a path (sections N and O);
- a station is reported Finished while a card is unstarted, stopped or unnamed (section O);
- a clean copy is shown amber, or a card that needs a look is shown green (section P1 to P3);
- a default copy leaves out a proxy, receipt or manifest folder without the operator having ticked it (section P4 to P7);
- an unloaded preset comes back after a relaunch (section P11);
- a CSV value is credited to the wrong tool, or a date is shown without its clock (section M);
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
