# CopyTrust Field Checklist

**Version under test:** v2.2 (Build 8)  
**Use this for:** fast operator-side validation during real camera card testing  
**Full companion sheet:** `docs/COPYTRUST_QA_RUN_SHEET.md`

---

## Session Info
- Date:
- Operator:
- Machine:
- macOS version:
- App build seen in About / title bar:
- Source card type:
- Destination 1 name:
- Destination 1 filesystem: `APFS / exFAT / HFS+ / Other:`
- Destination 2 name:
- Destination 2 filesystem: `APFS / exFAT / HFS+ / Other:`
- Verification level: `None / Quick / Full`
- Auto-eject setting: `ON / OFF`

---

## Quick Preflight

- [ ] CopyTrust launches cleanly
- [ ] Source card appears with correct name and path
- [ ] Destination(s) appear correctly in the destination list
- [ ] No false preflight failure shown
- [ ] Verification level is set as intended
- [ ] Auto-eject setting confirmed before run

---

## Copy Run

- [ ] Copy starts normally after `Start This Session`
- [ ] Progress window appears and can be closed and reopened
- [ ] Progress phases advance: scanning → copying → verifying → complete
- [ ] Speed and progress updates keep moving — no obvious stall
- [ ] Verification completes without error
- [ ] MHL creation completes

---

## Completed Sources

- [ ] Completed source moves into `Completed Sources`
- [ ] Active source area does not offer an eject button
- [ ] Destination does not offer an eject button
- [ ] Completed source shows a sensible trust status
- [ ] Status for completed source remains correct after the next card becomes active

---

## Manual Eject

- [ ] Manual eject is available from `Completed Sources`
- [ ] Successful eject shows a clear success status
- [ ] Failed eject shows a clear failure status
- [ ] No false success state if the card stays mounted

---

## Warning Path

- [ ] If trust is incomplete, manual eject shows a warning before proceeding
- [ ] Warning can be cancelled without losing session state
- [ ] Warning still allows `Eject Anyway` if the operator chooses

---

## Auto-Eject

- [ ] Auto-eject only affects source cards — not destinations
- [ ] Auto-eject only fires after copy + verification + MHL complete
- [ ] Auto-eject does not fire when trust is incomplete

---

## Two-Card Check

- [ ] Card 1 remains visible in `Completed Sources` after card 2 becomes active
- [ ] Card 2 becoming active does not change card 1's eject state
- [ ] Eject controls stay tied to completed cards, not the active card

---

## Disk Validation — Basic

After the session, open the destination in Finder:

- [ ] Copied media folder is present with correct subfolder name
- [ ] MHL file (`*.mhl`) exists in `CopyTrust_Receipts/` on the destination
- [ ] Per-copy log file (`ingest_*.log`) exists in `CopyTrust_Receipts/`
- [ ] JSON receipt file (`ingest_*.json`) exists in `CopyTrust_Receipts/`
- [ ] Session manifest (`SESSION_MANIFEST_*.json`) exists in `CopyTrust_Receipts/`
- [ ] Files open and are readable

**Critical for exFAT destinations:** All five artifact files above must be present. If any are missing and the destination is exFAT, note it immediately — this was the Build 7 regression target.

- exFAT result: `All artifacts present / One or more missing / N/A`
- Notes:

---

## Log Header — Per-Copy Log (Build 7)

Open the per-copy log from `CopyTrust_Receipts/` on the destination:

- [ ] File opens with a header block, not raw event lines
- [ ] `App:` line shows `CopyTrust 2.2 (Build 8)`
- [ ] `macOS:` line shows the correct macOS version
- [ ] `Host:` line shows the correct hostname for the machine that ran the copy
- [ ] `Session:` line shows an 8-character uppercase session tag
- [ ] `Source:` line shows the correct source alias and path
- [ ] Event lines (`performCopy begin`, `copy start`, etc.) follow after the header

Host seen in log:

---

## Log Content — Destination Label (Build 7)

Still in the per-copy log:

- [ ] `dest=` values in `copy start`, `copy done`, and `phase=` lines show a real name — not `dest=""`
- [ ] The name is consistent across all lines for the same destination

Example `dest=` value seen:

---

## Hostname in JSON Artifacts (Build 8)

Open `SESSION_MANIFEST_*.json` from `CopyTrust_Receipts/`:

- [ ] `"hostname"` key is present at the top level
- [ ] Value matches the hostname shown in the log header
- [ ] `"macOSVersion"`, `"toolVersion"`, and `"toolBuild"` are also present and correct

Open `ingest_*.json` receipt:

- [ ] `"hostname"` key is present at the top level
- [ ] Value matches the manifest

Open `ingest_*.txt` plaintext receipt:

- [ ] `Host    :` line is present between `macOS   :` and `Session :`

Hostname value confirmed:

---

## Device Speed History (Build 6)

After the session, open Terminal and run:

```bash
cat ~/Library/Application\ Support/CopyTrust/device_speed_history.json
```

- [ ] File exists
- [ ] At least one entry for the source used in this session
- [ ] At least one entry for each destination used
- [ ] Each sample has `date`, `sessionId`, `bytesTransferred`, `copyDurationSeconds`, `averageSpeedBytesPerSecond`, `roleLabel`, `isMultiDestinationLeg`
- [ ] Speed value is plausible for the device type (roughly 100,000,000–2,000,000,000 bytes/sec depending on media)

If this was a two-destination session:

- [ ] Both destination entries show `"isMultiDestinationLeg" : true` for samples from this session

Speed seen for source (bytes/sec):  
Speed seen for destination (bytes/sec):

---

## Outcome

- Overall result: `PASS / FAIL / MIXED`
- exFAT artifacts written correctly: `PASS / FAIL / N/A`
- Log header present and correct: `PASS / FAIL`
- Destination label in log lines: `PASS / FAIL`
- Hostname in JSON: `PASS / FAIL`
- Speed history populated: `PASS / FAIL`
- Blocking issue:
- Trust/reporting issue:
- Data-integrity issue:
- Notes for next run:
