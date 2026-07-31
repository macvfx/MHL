# CopyTrust 2.7 Workflow QA Matrix

Date: 2026-07-31
Applies to: CopyTrust 2.7.0 Build 8 public prerelease; keep the 2.5.3 stable line available for comparison
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

Run before the operator matrix:

```bash
swift test --package-path CopyCore
xcodebuild \
  -project FolderCopyCompare.xcodeproj \
  -scheme CopyTrust \
  -configuration Debug \
  -derivedDataPath /tmp/CopyTrust-QA-DerivedData \
  test
```

Expected:

- both commands exit successfully;
- no failed or unexpectedly skipped tests;
- proxy encode tests run when CopyTrust's packaged `ffmpeg` and `ffprobe` are
  installed at `/usr/local/bin`;
- test results are retained with the QA evidence.

## Fixture Setup

Fast fixture:

```bash
scripts/generate_test_fixtures.sh /tmp/copytrust-fixtures
```

Use separate writable destination roots. Never point automated tests at
production media or an irreplaceable camera card.

For real proxy comparison against an optional Final Cut-generated reference:

```bash
scripts/test_ffmpeg_proxies.sh \
  /path/to/original.mxf \
  /path/to/final-cut-reference.mov \
  /tmp/copytrust-ffmpeg-proxy-test \
  50
```

## A. Copy Mode and Pre-Copy Confirmation

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| A1 | Card defaults | Select Card mode and open Settings. | Inline verification, Card naming, Card exclusion profile, contact sheet and configured Card post-copy actions are shown. |
| A2 | Folder defaults | Select Folder mode and open Settings. | Folder profile remains independent; Quick is the default unless deliberately changed. |
| A3 | Mode isolation | Change one Card-only setting, switch to Folder, then return. | Folder is unchanged and Card retains the change. |
| A4 | Confirmation enabled | Start a prepared fixture session. | Confirmation names Card/Folder, verification, sorting, contact-sheet split, enabled artifacts, and a dedicated Proxy line. |
| A5 | Proxy off clarity | Disable proxy media and start. | Confirmation and log say `Proxy: Off` / `proxy=off`; absence is explicit. |
| A6 | Queued snapshot | Queue a Card job, then change mode/settings before queuing a Folder job. | Each queue row has the correct preset badge and later runs using its captured settings. |

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
| E2 | Independent states | Each artifact row reaches Done, Failed, Skipped, or Nothing to do. No row spins permanently. |
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

Visual checkpoint: `05-post-copy-actions.png`; retain proxy progress and
evidence screenshots as manual QA evidence when executing F1–F10.

## G. Mixed Queue

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| G1 | Stage two jobs | Queue Card A, then queue Folder B with different destinations/settings. | Two distinct ordered rows with correct source, destinations, and preset badges. |
| G2 | Reorder | Move a standard row before or between other pending rows. | Visible order and execution order match. |
| G3 | Inline review | Expand rows and inspect/edit aliases. | Multiple rows can be reviewed without loading or resetting the workspace. |
| G4 | Load/Return | Load a pending row, then Return to Queue. | Workspace clears and the queue remains intact without duplication. |
| G5 | Add while running | During a copy use `+ Add`, then also test drop-to-queue. | Active copy continues; new batch is staged with explicit source/destination/mode. |
| G6 | Auto-advance | Leave Auto enabled. | Next ready job starts only after trust-critical work for the current job completes. |
| G7 | Cancel/Resume Queue | Cancel the active job while another remains. | Resume retries current work; Resume Queue skips to remaining queued work. |
| G8 | Persistence | Quit and relaunch with pending jobs. | Pending queue restores once, in order, without duplicates. |
| G9 | Reset warning | Use Reset Session only after confirming the destructive warning. | Workspace and complete queue are cleared; Return to Queue remains the safe unload action. |

Visual checkpoint: `03-mixed-queue.png`.

## H. Relay Chain

Use one source and at least two ordered destinations.

| ID | Check | Procedure | Expected evidence |
|---|---|---|---|
| H1 | Create chain | Load A, then B and C in order; choose Queue Relay Chain. | Queue shows Step 1 and Step 2 with one sequence identity and dependency. |
| H2 | Correct source binding | Start Queue. | Step 1 copies A → B; Step 2 reads the verified B output and copies B → C. |
| H3 | Trust gate | Introduce an expendable Step 1 failure. | Step 2 stays blocked and never starts from an untrusted intermediate. |
| H4 | Edit before start | Use Edit on an untouched chain and reorder destinations. | All legs return to the workspace in order, then re-queue without duplicates. |
| H5 | Edit after start | Start one leg and attempt Edit. | Edit is unavailable once the chain has begun. |
| H6 | Final-only sort | Enable Destination Sort. | Intermediate B remains stable/unsorted; final C is sorted and verifiable. |
| H7 | Artifacts | Enable background artifacts. | Later relay leg does not wait for PDF/CSV/tree/proxy work after upstream trust completes. |
| H8 | Speed receipt | End session. | Receipt identifies every leg and gives per-leg copy/verify speeds. |
| H9 | Card release | After Step 1 becomes trust-complete, inspect safe-to-eject state. | Original card can be released while downstream work continues from B. |

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

Known tested baseline (private fixture identifiers anonymized): P5 8.0.4
archived a CopyCore Inline-verified PNG, text sidecar, and MHL to a non-deleting
test index; readback returned both complete hashes, `64x36` image dimensions,
and the expected CopyTrust fields.

## J. Screenshot and Guide Validation

Capture the deterministic documentation set:

```bash
scripts/capture-copytrust-workflow-screenshots.sh
scripts/build-copytrust-workflow-guide.sh
```

Expected:

- only declared screenshots are present;
- each image has the dimensions declared in the screenshot manifest;
- images are distinct and ordered;
- the guide generator rejects missing images or broken manifest rows;
- `docs/CopyTrust_Illustrated_Workflow_Guide.md` contains every declared screenshot and
  matching operator caption;
- `docs/CopyTrust_Illustrated_Workflow_Guide.pdf` contains the same ordered
  scenarios and embedded images;
- screenshot/demo code is Debug-only and a Release build still succeeds.

## Ship Decision

Do not call the workflow ready if:

- any trust-critical row fails;
- an artifact remains permanently queued/running;
- queue or relay dependencies can start out of order;
- proxy work changes the verified-original result;
- P5 accepts a Quick/copy-only job, a source-deleting plan, or an incomplete hash;
- P5 job/metadata cannot be confirmed in its own web GUI;
- package artifacts are written inside `.fcpbundle`;
- the generated guide contains stale controls, missing screenshots, duplicate
  images, or broken links.

Record the final decision:

- Build:
- Automated baseline:
- Operator matrix:
- Screenshot/guide validation:
- Known beta exceptions:
- Decision: `SHIP BETA / HOLD`
- Reviewer:
- Date:
