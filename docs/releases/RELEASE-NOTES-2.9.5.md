# CopyTrust, Drop Verify and Folder Copy Compare 2.9.5 Build 36 — beta

2026-10-08 · All three apps share this version. CopyTrust includes everything in 2.9.3 build 33 — see
[RELEASE-NOTES-2.9.3.md](RELEASE-NOTES-2.9.3.md). A 2.9.4 build was made and tested but never
released; its changes are in this one. Build 36 replaces build 35, published earlier the same day; the
only difference is in-app Help wording.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Off-site capture: card, to drive, to facility

A card shot away from the facility is copied to a drive on location, and that drive's folder is copied
into the facility's storage days later, often by someone else. This release makes that journey
provable from the files alone.

**On location.** When a preset's drives are not reachable, an orange banner offers **Off Site…**;
when they are reachable but you are still away, **Declare Off Site…** sits under the drives. Pick the
drive. It is a declaration you make, recorded in the session log, never automatic. A drive you add by
hand afterwards is an off-site drive too, with an **Off site** box on its row.

The drive's receipt and its `PROVENANCE` file now say the copy was made off site and name the drive by
its volume name and volume ID, so two drives called the same thing can be told apart afterwards. The
`PROVENANCE` file also records the project, unit and roll you chose.

Two preset options (the wizard's last step) control what a declared drive does:

- *Let operators create a project folder on an off-site drive* — off by default. When on, the project
  you pick from the list CopyTrust last scanned gets its folders made on the drive, in your storage's
  layout, listed in the pre-copy review first with the date of that list. Only that drive is written
  to. Left off, the card goes to the dated ingest folder, named correctly, as before.
- *Proxies on an off-site drive* — don't make them (the default), make them, or let the operator
  decide. It sets the drive's **Create proxies** box; you can change the box. Slow encoding belongs at
  the facility, made from the verified copy.

If the laptop restarts mid-shoot the declaration comes back — only while the preset's drives are still
missing, for the same preset and the same physical drive, within 14 days — and the banner says so.

## The second ingest reads the first

Stage the card folder from the drive and CopyTrust finds the earlier copy's `PROVENANCE` file, matches
it to the drive by volume ID, and shows *Copied by CopyTrust on … from <card> to <drive>, off site*
with **Use these answers**. Nothing is filled in until you press it, and the receipt says the answers
were taken from the earlier copy.

With Inline or Full verification, as it reads the files CopyTrust checks the drive against the `.mhl`
the first copy wrote **and** against the per-file list in the `PROVENANCE` record. The `.mhl` is used
only if the record, on the same drive, lists exactly the same files and hashes. The results are reported
as **Drive** in the summary and receipt — the drive still holds what was written — kept apart from how
the footage arrived, which is a different claim. The facility copy's own `PROVENANCE` records the chain
(`continuedFrom`) and the outcome (`driveCheck`).

In a P5 archive, **Source Card** is the camera card, not the folder name, and the archive request
carries the chain.

## Proxies and aliases from an earlier copy

If the folder arrives with proxies and a proxy receipt from the first copy, the new proxies go in a
separate `Proxies <date>` folder and the earlier ones are left alone. Before, the generator replaced a
proxy at the same path. The `Final Cut Relink Aliases` folder is now left out of a copy by default: its
aliases point at proxies on the drive they were made on. It is the only exclusion that starts on.

## Also in this build

- **ffmpeg.** The pre-copy review warns when ffmpeg is missing and proxies or contact sheets are
  selected; Drop Verify asks the same before it starts.
- **Appearance.** Settings now offers Always Dark or Follow System, in CopyTrust and Drop Verify. The
  pre-copy review follows it.
- **Off Site is offered when a preset is loaded**, not only at launch.
- Drop Verify and Folder Copy Compare are otherwise unchanged.

## What it needs, and what it does not do

- Declaring off site, the marker in receipts, project folders and the proxy default need an
  enforced-naming preset, in Card mode. Without one the workflow still works and is still provable —
  the drive's receipts record its volume ID, and at the facility the folder is matched, checked and
  carried forward — but nothing says "off site", and you pick project, unit and roll yourself.
- The drive check needs **Inline** or **Full** verification, and the answer arrives **with** the copy,
  not before it. A changed file is found after it is already in the facility copy; the receipt names
  it. To know first, run MHL Verify on the folder before staging it.
- A drive copied before this build has no volume ID in its record, so it cannot be matched and is not
  checked.
- Only the project folder and its landing folder are made on the drive, not the facility's whole
  folder template.

## What to test

A printable sheet is in [copytrust/CopyTrust_OffSite_OperatorTest.md](../../copytrust/CopyTrust_OffSite_OperatorTest.md),
and the whole running order, with every file each step writes, is in
[copytrust/CopyTrust_OffSite_Workflow.md](../../copytrust/CopyTrust_OffSite_Workflow.md). In short:

1. With the preset's drives unreachable, take **Off Site…**, pick a drive, add a second by hand, and
   copy a card with a project from the list. Both drives should show verified, the receipt should say
   **Off site: yes** and name the drive, and the review should have listed the folders first.
2. Back with the storage connected, stage the card folder from a drive. You should see the line about
   the earlier copy; press **Use these answers**; the summary should show two **Drive** entries that
   still match.
3. Change one clip on a drive and repeat 2. The summary should say the drive does not match, name the
   clip, and the copy should still finish.
4. Quit and reopen mid-shoot with the drives still plugged in. The declaration should come back.
