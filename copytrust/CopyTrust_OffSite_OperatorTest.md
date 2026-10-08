# Off-site capture — operator test sheet

CopyTrust 2.9.5 (build 35) · Print this, tick as you go, write on it.

This tests copying a camera card to a drive away from the facility, and then copying that drive's
folder into the facility's storage. It is a **test**: use a card you can copy again, and **do not
wipe or reuse the card until the test is finished.** Where a line says what you should see, write
down anything different, however small. "It looked odd" is useful.

The running order, with every file each step writes, is [CopyTrust_OffSite_Workflow.md](CopyTrust_OffSite_Workflow.md).

**You need:** a Mac with the house preset; the facility storage reachable for Part 1 and *not*
reachable for Part 2 (unplug it, or work somewhere it cannot connect); a card; **two** external
drives with different names (for example `SHOOT_A_01` and `SHOOT_A_02`); and the preset's two
off-site options set as you want to test them.

Name: ______________________  Date: ______________  Drive names: __________________ / __________________

---

## Part 1 — Before you leave (storage connected)

- [ ] Open CopyTrust and load the house preset. Storage is mounted.
- [ ] **Show project list…** (under the destinations). Your job is in it. Date shown: ______________
- [ ] Quit CopyTrust.

## Part 2 — On location (storage not reachable)

Plug in both drives.

- [ ] Open CopyTrust. An orange bar says some volumes are not available.
  *Press **Off Site…**.* A window asks for a drive: choose the first one.
  **Expect:** the bar now says *Working off site*, the drive is listed, and its row has an **Off site** box ticked.
- [ ] Add the second drive as another destination.
  **Expect:** its row has **Off site** ticked too, and **Create proxies** unticked on both.
- [ ] Put in the card and pick the **project from the list**, then the unit and roll.
- [ ] Press Start. **Read the review before you confirm.**
  **Expect:** it lists the folders it will make on each drive, and the date of the project list.
  Does the project folder name look right? ☐ yes ☐ no
- [ ] Confirm. Wait for it to finish.
  **Expect:** both drives show as verified.
- [ ] Open the first drive in Finder and look inside the card folder it made.
  **Expect:** the card's files; a file ending **.mhl**; and a folder called **Receipts**.
  Open **Receipts**. **Expect:** a receipt (`ingest_…`, a text file) that says **Off site: yes** near the top.
- [ ] Do the same on the second drive.
- [ ] *(Optional)* Quit CopyTrust while the drives are still plugged in and storage is still away, then open it again.
  **Expect:** it says the off-site setting was **restored**, and both drives are listed again.

**Stop here if:** a drive shows a problem, the receipt does not say off site, or a project folder is in the wrong place. Write down what you see and tell the person running the test before going on.

## Part 3 — Back at the facility (storage connected)

Plug in the **first** drive. Keep the second one aside, untouched.

- [ ] Open CopyTrust with the house preset, **Card** mode, verification set to **Inline** or **Full**.
- [ ] Add the card folder from the drive as a source: the folder inside the project, **not** the whole drive.
  **Expect:** a line under it saying *Copied by CopyTrust on … from <card> to <drive>, off site*, and a button **Use these answers**.
- [ ] Press **Use these answers**. **Expect:** project, unit and roll fill in, and match what you chose on location. ☐ yes ☐ no
- [ ] Start, and confirm the review.
- [ ] When it finishes, open the summary and find **Source Provenance**.
  **Expect:** two entries marked **Drive**, saying the drive **still matches**, all files.
  If either says **DOES NOT MATCH**: write down the file it names. **Do not wipe either drive.**
- [ ] Open the new card folder in the facility storage, then **Receipts**.
  **Expect:** *two* receipts and *two* files starting `PROVENANCE_` (the one from the drive and the new one). At the folder's top level, *two* `.mhl` files.

## Part 4 — Optional: a drive that has changed

Use the **second** drive's card folder. In Finder, replace or edit one clip in it (copy a different file over it). Then do Part 3 again with that folder.

- [ ] **Expect:** the summary says the drive **DOES NOT MATCH**, names the clip you changed, and the copy still finishes.
- [ ] That is the right answer. Put the clip back or discard that folder afterwards.

---

## Send back

- [ ] The **Receipts** folder from each drive's card folder, and from the facility's card folder. Not the footage.
- [ ] CopyTrust's log: **Reveal Log** in the app, then the latest file.
- [ ] A screenshot of the **Source Provenance** summary from Part 3.
- [ ] This sheet, with your notes.

A small checker script is available that reads a delivered folder and prints PASS, FAIL or INFO for
each thing it expects to find. It is distributed with the CopyTrust source, not with these docs; ask for
it if you would like to use it. It prints no full path, but it does print the names of the files it reads, which can contain card and
project names, so send its output only to the person running the test. Run it on each drive's card folder with `--field`, and on the facility's with
`--facility`.

Each line starts PASS, FAIL or INFO. In Part 4, two FAIL lines about the drive check are the correct result.

## Result

| | |
| --- | --- |
| Part 2 completed as expected | ☐ yes ☐ no |
| Part 3 completed as expected | ☐ yes ☐ no |
| Part 4 (if done) found the changed clip | ☐ yes ☐ no ☐ not done |
| Anything that surprised you | |
| Signed | |
