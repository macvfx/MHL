# CopyTrust, Drop Verify and Folder Copy Compare 2.9.7 Build 39 — beta

2026-10-09 · All three apps share this version. Only CopyTrust changed; it includes everything in
2.9.6 build 37 — see [RELEASE-NOTES-2.9.6.md](RELEASE-NOTES-2.9.6.md).

Build 39 replaces build 38, published earlier the same day. It fixes a hang: with a cloud volume
(LucidLink) staged, choosing a different project could freeze CopyTrust for up to a minute while the
project folder was looked for on the slow volume. The window now carries on and says it is still
looking, and Start waits for the answer; the copy itself is unchanged. The project list may still
flicker briefly when the project changes. Nothing else differs.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Project folders for the loaded list

With a project list loaded (a saved list, or read from a volume), **Create project folders…** — on
the *Working off site* line — makes the folders for those projects on a drive before you leave.

- Choose a volume or a folder. It does not have to be a destination.
- Every project is listed as *already there*, *will make* or *blocked*, with the missing ones ticked,
  and the folders that will be made are listed in full. Nothing is written until you confirm.
- Only project folders are made, empty: the project folder and the year or client folder above it
  that the preset's layout calls for. A card's landing folders are made when the card is copied.
- A project that already has a folder under any of the preset's roots is left alone, whatever it is
  called. Two folders for one project number is blocked, never guessed. A volume that is only a
  leftover mount point is refused.
- The preset has to allow it: *Let operators create a project folder on an off-site drive*, or the
  facility option. Without it the sheet says so and creates nothing.

**Template…** on a row opens that project in Project Folder Creator 0.7.0 or later with its number
and name filled in, to make it from the facility's full template instead.

## What to test

1. With the preset's off-site creation option off, open *Create project folders…*: it says the preset
   does not allow it. Turn the option on.
2. Load a list, plug in a blank drive, *Create project folders…* ▸ choose the drive. Untick one
   project, press Create. Only the ticked projects have folders, empty. Open it again: they read
   *already there*.
3. Rename one project's folder on the drive to `2026-014_old` and reopen: it reads *already there*
   under that name and no second folder is made.

The whole running order is in [copytrust/CopyTrust_OffSite_Workflow.md](copytrust/CopyTrust_OffSite_Workflow.md).
