# CopyTrust 2.8.5 Build 26 — beta

2026-09-21 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.1 build 21.
Everything in 2.8.4 build 25 is included unchanged — see
[RELEASE-NOTES-2.8.4.md](RELEASE-NOTES-2.8.4.md).

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Settings works again

In 2.8.4, Settings drew every tab label on top of the others in a single tab at the top of the
sheet, so only the tab already selected could be used. The settings themselves had not changed:
2.8.4 was the first build made with a newer version of Apple's developer tools, which lays out a
row of tabs differently and could no longer fit eight of them.

Settings now lists its tabs down the left side, the way Help already does. The list grows with
Interface Size, which the old row of tabs never did.

## Also in Settings

- A **CopyTrust Settings** title across the top.
- The version and build at the bottom, beside Done.
- An **About** tab at the end of the list, with the version, build and website.

Nothing in copying, verification, naming, receipts or P5 changed in this build.

## What to test

1. Open Settings and visit every tab from the list on the left. Each should open, and nothing
   should be cut off.
2. Set Interface Size to 1.5x or 2x and open Settings again: the list should grow with it.
3. Check that the version at the bottom of Settings and on the About tab matches the one beside
   the CopyTrust name in the main window.
4. Repeat the 2.8.4 checks: with an enforced naming preset loaded, switch to Folder — the preset's
   destinations should go, and Settings ▸ Folder Copy should show Quick verification.
