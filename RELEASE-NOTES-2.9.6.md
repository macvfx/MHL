# CopyTrust, Drop Verify and Folder Copy Compare 2.9.6 Build 37 — beta

2026-10-09 · All three apps share this version. Only CopyTrust changed; it includes everything in
2.9.5 build 36 — see [RELEASE-NOTES-2.9.5.md](RELEASE-NOTES-2.9.5.md).

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Working off site without the facility's storage

Raised in field testing of the off-site flow: with an enforced-naming preset and the cloud volume
out of reach, the project picker was empty and there was no way to name a card.

- **Load project list…**, next to *Working off site*, fills the picker without making the facility's
  storage a destination. *From a saved list* reads the CSV that **Save project list…** writes, or a
  plain text file with one project per line (`2026-014 Some Project`, or number and name in two
  columns). *From a volume or folder* reads the projects once from a mounted volume or its Projects
  folder. The list is kept on disk, and the status line says it was loaded by hand and from what.
  Nothing in it has been checked against storage; the pre-copy review lists the folders that will be
  made.
- **End Off Site**, on the same line (and in the banner), ends the declaration and clears what is
  remembered for a relaunch. Drives already added stay staged but stop being recorded as off site.
  When the preset's drives were missing and are all mounted again, the line says so and suggests
  ending it. It is never ended for you, and a declaration made while nothing was missing never gets
  the suggestion.

## What to test

1. Declare Off Site, then **Load project list… ▸ From a saved list** with a CSV from **Save project
   list…**: the picker fills and the status line names the file. Try a text file with one project per
   line, and a file with no project numbers (a message; the list is unchanged).
2. **From a volume or folder**, choose the cloud volume, then its Projects folder. Neither is added
   as a destination.
3. Declared because the preset's drives were missing: mount them. The line says they are mounted
   again; off site stays declared until **End Off Site**. Afterwards a new copy's receipt does not
   say off site.

The whole running order is in [copytrust/CopyTrust_OffSite_Workflow.md](copytrust/CopyTrust_OffSite_Workflow.md).
