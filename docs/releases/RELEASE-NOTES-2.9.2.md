# CopyTrust 2.9.2 Build 32 — beta

2026-10-02 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.2 build 22.
Everything in 2.9.1 build 31 is included unchanged — see
[RELEASE-NOTES-2.9.1.md](RELEASE-NOTES-2.9.1.md). Both come from an on-site test with a client.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## The pre-copy review says whether to start, first

Build 31 added a Go / Check line to the pre-copy review, below the job title, where it was easy to
read past. It is now the first thing in the review and says what to do:

- Green **Looks good — start the copy**: nothing in the review needs a decision.
- Orange **Read below before you start**, with the number of items that do.

The button reads **Start Copy** instead of Continue (still **Create Folders and Copy** when folders
will be made), so the banner and the button use the same words. Nothing blocks: the button is
always there, and the banner only says whether to stop and read first.

## Wording

What's New and Help use a neutral example project (`2026-107 Harbour Lights_ACAM_roll3` with a
unit, `2026-107 Harbour Lights` without) and say "Drone files, for example" where a preset lists
the units whose files are renamed.

## What to test

1. Press Start with nothing to check: a green banner at the very top, and a **Start Copy** button.
2. Proxies on, a proxies-only destination, no copy destination set to create proxies: an orange
   banner reading **Read below before you start**, with the count.
