# CopyTrust 2.8.6 Build 27 — beta

2026-09-21 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.2 build 22.
Everything in 2.8.5 build 26 is included unchanged — see
[RELEASE-NOTES-2.8.5.md](RELEASE-NOTES-2.8.5.md).

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Reveal goes to the folders the files were copied into

Found in on-site testing. With enforced naming and more than one destination, **Reveal** on a
finished source opened the volumes instead of the folders the card was copied into. It looked for
the files where they would have gone before enforced naming placed them in project folders, did
not find that folder, and fell back to the top of each drive.

Reveal now uses the folder each copy actually wrote to. If a folder is genuinely missing — the drive
was ejected, or the delivery was moved — it opens the nearest folder above it that still exists,
and the session log says so.

## Reveal is a menu, one section per destination

Each destination is listed by name with:

- **Copied Files** — the folder the card was copied into;
- **Receipts & Artifacts** — the manifest, MHL, contact sheet, metadata CSV and file tree;
- **Proxies** — only when a preset keeps proxies somewhere other than beside the copy.

Each item opens exactly that folder, and its path is shown beneath it, so where everything went can
be read without opening Finder. With more than one destination, **All Copied Files** and **All
Receipts & Artifacts** open every one at once.

## The same wrong folder, fixed in three more places

The next leg of a relay chain, **Retry MHL export**, and **Deep Compare** each looked for the files
in the same wrong folder. Under enforced naming each would have found an empty or missing folder.
All three now use the folder the copy wrote to.

## What to test

1. With your enforced naming preset and two destinations, copy a card. Open the **Reveal** menu on
   its row: each destination should be listed with its project folder's path, not a volume.
2. Choose **Copied Files**, then **Receipts & Artifacts**, for each destination. Finder should open
   exactly that folder; the contact sheet and CSV should be in the receipts folder.
3. Choose **All Copied Files** and **All Receipts & Artifacts**.
4. Eject one destination and use Reveal again: it should open the nearest folder that still exists.
5. If you use relay chains, Retry MHL export or Deep Compare after an enforced-naming copy, check
   each finds the copied files.
