# CopyTrust QA Run Sheet

**Version under test:** v2.2 (Build 8)  
**Date:** 2026-04-21  
**Purpose:** Run a structured UI + real-media regression pass for CopyTrust, with special attention to trust-first completion, background artifact behavior, cancelled-session recovery, resumable ingest on real media, exFAT destination artifact writes, log provenance headers, and per-session speed history.

## How To Use This Sheet
- Run Section A first if you want a quick fixture sanity pass before touching real media.
- Run Section B for actual camera card and removable-drive testing.
- Run Section C to validate the v2.2 Build 6–8 features: exFAT artifact writes, log headers, hostname provenance, and device speed history.
- Record pass/fail notes inline or copy this file and fill in the blanks.
- If something fails, capture:
  - exact step number
  - source card type
  - destination filesystem
  - whether auto-eject was on or off
  - visible UI text
  - whether the issue is UI-only, trust/reporting-only, or data-integrity-related
  - whether the issue happened during trust-critical copy/verify/MHL work or only during background PDF/CSV generation

## Test Metadata
- Operator:
- Machine:
- macOS version:
- App build seen in UI:
- Source card type(s):
- Destination 1:
- Destination 1 filesystem:
- Destination 2:
- Destination 2 filesystem:
- Auto-eject setting for this run:

## Pass / Fail Legend
- `PASS`: behavior matched expectation
- `FAIL`: behavior incorrect or missing
- `N/A`: not applicable to this run

---

## Section A. Fixture Sanity Pass

### A1. Build Baseline
Confirm the current codebase is in a green state before testing UI behavior.

Run:

```bash
swift test --package-path CopyCore
xcodebuild -project "FolderCopyCompare.xcodeproj" -scheme CopyTrust -configuration Debug build -quiet
```

Record:
- CopyCore tests: `PASS / FAIL`
- CopyTrust build: `PASS / FAIL`
- Notes:

### A2. Generate Fixtures
Run:

```bash
./scripts/generate_test_fixtures.sh /tmp/copytrust-fixtures
```

Expected folders:
- `/tmp/copytrust-fixtures/source_card_A`
- `/tmp/copytrust-fixtures/source_card_B`
- `/tmp/copytrust-fixtures/destination_primary`
- `/tmp/copytrust-fixtures/destination_backup`

Record:
- Fixture generation: `PASS / FAIL`
- Notes:

### A3. Fixture Ingest Smoke
In CopyTrust:
1. Add both source fixture folders.
2. Add both destination fixture folders.
3. Set verification to `Full (xxHash64)` or your intended test level.
4. Start ingest.

Check:
- progress window opens
- progress can be closed and reopened
- status phases advance cleanly
- no unexpected alerts
- completed fixture sources move into `Completed Sources`
- active-row eject controls are not shown

Record:
- Fixture smoke: `PASS / FAIL`
- Notes:

---

## Section B. Real-Media Regression Pass

## B1. Test Setup
Before launching the run:
- Insert at least one real camera card.
- Mount at least one real removable destination drive.
- If possible, use two destination filesystems across your runs:
  - APFS
  - exFAT
- If possible, run at least one two-card session.

Record:
- Real media mounted and recognized: `PASS / FAIL`
- Notes:

## B2. Preflight UI Check
Open CopyTrust and add the real source card and destination(s).

Check:
- source card appears with correct name/path
- destination list shows the expected drives
- preflight does not show a false hard failure
- source counts/sizes look plausible
- no destination eject button is shown

Record:
- Preflight UI: `PASS / FAIL`
- Notes:

## B3. Single-Card Happy Path
Settings:
- auto-eject `OFF`
- verification `Full`

Steps:
1. Start ingest for one real source card.
2. Let copy complete normally.
3. Wait for verification and MHL generation to complete.

Check during run:
- progress phases are understandable
- speed/progress updates keep moving
- no status gets stuck

Check after completion:
- source card moves into `Completed Sources`
- completed source shows sensible trust/eject status
- active workflow advances cleanly without offering eject on the live card area
- MHL, receipts, and logs are created on destination

Record:
- Single-card happy path: `PASS / FAIL`
- Notes:

## B4. Manual Eject From Completed Sources
With the successful run from B3:
1. Use the `Eject` control from `Completed Sources`.

Check:
- eject is offered only from `Completed Sources`
- success/failure message is visible after the action
- no false success is shown if the card stays mounted
- no destination eject action is offered

Record:
- Manual eject after trusted run: `PASS / FAIL`
- Notes:

## B5. Manual Eject Warning Path
Create a run where trust is not fully clean. Examples:
- stop before verification completes
- create a manifest/artifact failure if you can do so safely
- use a configuration that leaves required trust work incomplete

Then:
1. Go to `Completed Sources`.
2. Press `Eject`.

Check:
- manual eject is still offered
- warning appears before eject proceeds
- warning text matches the underlying issue closely enough to guide the operator
- operator can cancel without losing state
- operator can continue and eject anyway if desired

Record:
- Manual eject warning path: `PASS / FAIL / N/A`
- Notes:

## B6. Auto-Eject Trusted Source Cards
Turn on `Auto-eject completed source cards` in settings.

Run a clean ingest again.

Check:
- auto-eject only applies to source cards
- auto-eject does not target destinations
- auto-eject triggers only after copy, verification, and MHL creation complete
- completed source shows a clear success/failure message

Record:
- Auto-eject trusted source: `PASS / FAIL`
- Notes:

## B7. Auto-Eject Trust Gate
With auto-eject still enabled, run a case where trust is incomplete.

Check:
- auto-eject does not fire
- source remains in `Completed Sources`
- UI makes it possible to eject manually instead
- warning path still works for manual eject

Record:
- Auto-eject blocked on trust gate: `PASS / FAIL / N/A`
- Notes:

## B8. Busy-Volume / Eject Failure Behavior
Try to force a realistic eject failure on a source card. Examples:
- open the card in Finder
- preview a file on the card
- keep Terminal working directory on the card

Then try manual eject from `Completed Sources`.

Check:
- UI reports eject failure clearly
- card is not marked ejected on failure
- source remains visible in `Completed Sources`
- app does not hang or lose session context

Record:
- Eject failure surfacing: `PASS / FAIL / N/A`
- Notes:

## B9. Two-Card Sequential Session
Run a session with two real source cards if available.

Steps:
1. Add card 1 and card 2.
2. Run the session through both cards.

Check:
- card 1 remains visible after completion while card 2 becomes active
- eject actions stay attached to completed cards, not the active one
- trust/eject status stays associated with the correct source
- no uneven “only second card can eject” behavior returns

Record:
- Two-card session behavior: `PASS / FAIL / N/A`
- Notes:

## B10. Background Artifact Non-Blocking Behavior
Run a two-source session with contact sheet and EXIF CSV enabled.

Check:
- after source 1 completes trust-critical work, source 2 can start without waiting for source 1 PDF/CSV completion
- `Completed Sources` shows background artifact state clearly
- `Ready to eject` reflects trust completion, not PDF/CSV completion

Record:
- Background artifact non-blocking behavior: `PASS / FAIL / N/A`
- Notes:

## B11. Cancel And Resume Real-World Workflow
Use a real source and destination pair where cancellation mid-copy is meaningful.

Steps:
1. Start an ingest and cancel after a noticeable amount of data has copied.
2. Confirm the source lands in a cancelled state.
3. Start the same source again with the same destination set.
4. Choose `Resume` if prompted.
5. Let the resumed ingest complete.

Check:
- cancelled UI uses recovery wording, not success wording
- resume is offered only when it should be
- resumed run appears shorter than a clean restart
- final manifest and MHL are written for the completed resumed ingest

Record:
- Cancel and resume workflow: `PASS / FAIL / N/A`
- Notes:

## B12. Artifact Stop / End Session Behavior
Create a run where PDF/CSV artifacts are still running after trust-critical ingest is complete.

Check:
- `Stop PDF/CSV` is available from the completed-source area
- `End Without PDF/CSV` is available from the review summary when artifact jobs are still running
- ending without PDF/CSV does not invalidate the completed verified copy
- if EXIF CSV finishes while contact sheet is still running, the UI/logs make that understandable

Record:
- Artifact stop / end-session behavior: `PASS / FAIL / N/A`
- Notes:

## B13. Post-Run Disk Validation
After the ingest run:
1. Remount the destination if needed.
2. Inspect output on disk.

Check:
- copied media is present
- MHL opens and looks intact
- receipt/log files exist and are readable
- session folder naming is correct
- files can be opened from the destination after remount

Record:
- Post-run disk validation: `PASS / FAIL`
- Notes:

---

## Section C. v2.2 Build 6–8 Feature Validation

These tests target the three new features shipped in Builds 6–8. Run them after at least one successful real-media pass in Section B so you have fresh artifacts on disk to inspect.

**Prerequisites for Section C:**
- At least one completed ingest to a real destination (APFS or exFAT)
- Destination drive mounted and artifacts accessible in Finder
- Terminal access to `~/Library/Application Support/CopyTrust/`

---

### C1. exFAT Destination — Artifacts Written Correctly

**Why this matters:** Before Build 7, MHL, per-copy logs, and receipt files were silently not written to exFAT destinations. The copy itself succeeded but no artifacts landed on the drive.

**Setup:** Run a complete ingest to an exFAT-formatted destination (e.g. Angelbird EVO, any camera offload drive formatted for cross-platform use). If you only have APFS destinations available, note that in your test record and skip to C2 — this test is specifically for exFAT.

Steps:
1. Complete a full ingest to the exFAT destination (copy + verification).
2. In Finder, open the destination's `CopyTrust_Receipts/` folder.

Check:
- `CopyTrust_Receipts/` folder exists on the exFAT destination
- a per-copy log file (`ingest_*.log`) is present
- a JSON receipt file (`ingest_*.json`) is present
- a session manifest file (`SESSION_MANIFEST_*.json`) is present
- an MHL file (`*.mhl`) is present
- no UI error mentioning `F_FULLFSYNC` or "receipt/log export failed" appeared during the run

Record:
- exFAT artifact write: `PASS / FAIL / N/A (no exFAT destination available)`
- Destination filesystem confirmed as:
- Notes:

---

### C2. Per-Copy Log — Header Block Present

**Why this matters:** Before Build 7, log files opened with raw event lines and had no way to tell which machine, app version, or session produced them without cross-referencing other files.

Steps:
1. Open a per-copy log file from the destination's `CopyTrust_Receipts/` folder (or from `~/Library/Application Support/CopyTrust/logs/`).
2. Read the first several lines.

Expected header at the top of the file:
```
── CopyTrust Session Log ──────────────────────────────────────
App:      CopyTrust 2.2 (Build 8)
macOS:    macOS [version]
Host:     [hostname]
Session:  [8-char session tag]
Source:   [source alias] — [source path]
───────────────────────────────────────────────────────────────
```

Check:
- header block is present at the top of the log, before any event lines
- `App:` line shows the correct app name, version, and build number
- `macOS:` line shows the correct macOS version for the machine that ran the copy
- `Host:` line shows the correct hostname for the machine that ran the copy
- `Session:` line shows an 8-character uppercase session tag
- `Source:` line shows the correct source alias and path
- event lines follow immediately after the closing dashes

Record:
- Per-copy log header: `PASS / FAIL`
- App line shows:
- Host line shows:
- Notes:

---

### C3. Session Log — Provenance Line Present

**Why this matters:** The session log (written to App Support, not to the destination) now opens with a one-line provenance summary so it is self-identifying when reviewed on a different machine.

Steps:
1. Open `~/Library/Application Support/CopyTrust/logs/[SESSION TAG]/session_[SESSION TAG].log`
2. Read the first line.

Expected first line:
```
[timestamp] ── session start ── app=CopyTrust 2.2 (Build 8) macOS=macOS [version] host=[hostname] session=[SESSION TAG]
```

Check:
- first line contains `── session start ──`
- app name, version, and build number are correct
- macOS version is correct
- hostname is correct
- session tag matches the folder name

Record:
- Session log provenance line: `PASS / FAIL`
- Notes:

---

### C4. Destination Label In Log Lines

**Why this matters:** Before Build 7, destination names appeared as `dest=""` in all copy and phase log lines, making the log useless for diagnosing which destination had a problem.

Steps:
1. Open any per-copy log from a run that had at least one named destination.
2. Find any `copy start`, `copy done`, `phase=copying`, or `phase=verifying` line.

Expected format:
```
[timestamp] copy start dest="EVO" file="CONTENTS/CLIPS001/A001C001..."
[timestamp] phase=verifying dest="EVO" source=Canon
```

Check:
- `dest=` shows a non-empty name (volume label or mount-point folder name)
- `dest=` is consistent across all lines for the same destination
- `dest=""` (empty string) does not appear anywhere in the log

Record:
- Destination label in log lines: `PASS / FAIL`
- Example dest= value seen:
- Notes:

---

### C5. Hostname in JSON Artifacts

**Why this matters:** Build 8 added `"hostname"` to both the session manifest and the session receipt JSON so every artifact is self-identifying without needing the log file.

Steps:
1. Open the `SESSION_MANIFEST_*.json` file from the destination's `CopyTrust_Receipts/` folder in a text editor.
2. Find the top-level fields.
3. Repeat with the `ingest_*.json` receipt file.

Check in manifest JSON:
- `"hostname"` field is present at the top level
- value matches the hostname of the machine that ran the copy (same as the log header)
- `"macOSVersion"` field is also present
- `"toolVersion"` and `"toolBuild"` are present and correct

Check in receipt JSON:
- `"hostname"` field is present at the top level
- value matches the manifest

Check in plaintext receipt (`ingest_*.txt`):
- `Host    :` line is present between `macOS   :` and `Session :`

Record:
- Hostname in manifest JSON: `PASS / FAIL`
- Hostname in receipt JSON: `PASS / FAIL`
- Host line in plaintext receipt: `PASS / FAIL`
- Hostname value shown:
- Notes:

---

### C6. Device Speed History — File Created and Populated

**Why this matters:** Build 6 introduced persistent per-volume speed tracking. After each session a JSON file in Application Support is updated with a speed sample for each device used.

Steps:
1. After completing at least one full ingest, open Terminal and run:
   ```bash
   cat ~/Library/Application\ Support/CopyTrust/device_speed_history.json
   ```
2. Inspect the output.

Expected: a JSON dictionary where each key is a volume UUID (for sources) or a `path:/Volumes/...` string (for destinations), containing a `samples` array.

Check:
- file exists at the expected path
- at least one entry exists for the source card used
- at least one entry exists for the destination used
- each sample contains `date`, `sessionId`, `bytesTransferred`, `copyDurationSeconds`, `averageSpeedBytesPerSecond`, `roleLabel`, `isMultiDestinationLeg`
- `averageSpeedBytesPerSecond` is a plausible number (e.g. 200–800 MB/s for a fast card is roughly 200,000,000–800,000,000)
- after a second session with the same device, the `samples` array grows by one entry rather than replacing the previous one

Record:
- Speed history file exists: `PASS / FAIL`
- Source entry present: `PASS / FAIL`
- Destination entry present: `PASS / FAIL`
- Sample values look plausible: `PASS / FAIL`
- Notes:

---

### C7. Two-Destination Speed History — Multi-Destination Flag

**Why this matters:** When copying to two destinations simultaneously, the per-leg throughput reflects shared source bandwidth. These samples are flagged `isMultiDestinationLeg: true` and excluded from trend calculations.

**Setup:** Run a session with two destinations active at the same time (both in the destination list, copy running to both simultaneously).

Steps:
1. Complete the two-destination session.
2. Open `device_speed_history.json` and find the entries for the two destinations.

Check:
- both destination entries have samples with `"isMultiDestinationLeg" : true`
- the source entry (if it has a sample from this session) also has `"isMultiDestinationLeg" : true` for the sample from this session

Record:
- Multi-destination flag set correctly: `PASS / FAIL / N/A (only one destination used)`
- Notes:

---

## Failure Triage Guide

### If the issue is UI-only
Examples:
- wrong button placement
- missing warning
- stale status text

Capture:
- screenshot
- step number
- exact visible text

### If the issue is trust/reporting-only
Examples:
- auto-eject fired too early
- manual eject warning did not appear
- completed source status is wrong

Capture:
- whether verification completed
- whether MHL exists
- whether receipts/logs were written
- whether the card actually ejected

### If the issue is integrity-related
Examples:
- missing copied files
- corrupt MHL
- unreadable receipts/logs

Capture immediately:
- source path
- destination path
- filesystem type
- whether destination was ejected/remounted
- whether issue reproduces twice

---

## Summary

### Section A — Fixture Sanity
- A1 Build baseline:
- A3 Fixture smoke:

### Section B — Real-Media Regression
- B3 Single-card happy path:
- B4 Manual eject after trusted run:
- B5 Manual eject warning path:
- B6 Auto-eject trusted source:
- B7 Auto-eject trust gate:
- B8 Eject failure surfacing:
- B9 Two-card session:
- B13 Post-run disk validation:

### Section C — v2.2 Build 6–8 Features
- C1 exFAT destination artifact write:
- C2 Per-copy log header block:
- C3 Session log provenance line:
- C4 Destination label in log lines:
- C5 Hostname in JSON artifacts:
- C6 Device speed history file created:
- C7 Multi-destination flag set:

## Ship Assessment
- Ready to continue beta validation: `YES / NO`
- Blocking issues found:
- Nice-to-have polish found:
- Follow-up tickets to create:
