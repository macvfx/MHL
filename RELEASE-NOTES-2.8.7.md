# CopyTrust 2.8.7 Build 28 — beta

2026-09-21 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.2 build 22.
Everything in 2.8.6 build 27 is included unchanged — see
[RELEASE-NOTES-2.8.6.md](RELEASE-NOTES-2.8.6.md). Every change here was tested on site in local
builds before release.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## One pre-copy review instead of up to three windows

Pressing Start could raise the pre-copy review, then a Camera Card exclusions warning, then a
"Folders will be created" dialog that printed every destination and folder as one paragraph of
wrapped text. The exclusions and the delivery are now sections of the review:

- **Camera Card files will be skipped** — the active patterns, with **Edit Exclusions…** to change
  them.
- **Folders will be created** / **Where this card will be delivered** — one row per destination,
  with its path and each folder to create on lines of their own.

Continue reads **Create Folders and Copy** when folders will be made. Neither warning could ever be
switched off, so the review still appears when either has something to say, even with the routine
review turned off.

## Contact sheets for MKV

An MKV card produced no contact sheet ("no media") while its proxies were made. Extensions listed
in Settings › External Codecs are now sent to ffmpeg for contact-sheet thumbnails too — before,
only a fixed list (MXF, R3D, BRAW and the like) was, and MKV went to macOS's own decoder, which
cannot read it.

## P5 status in plain words

P5 reports a job as "failure" until it finishes, and CopyTrust showed that on the artifacts row for
the whole run. Progress now reads **Archiving in P5 job …**, and the finished line **Archived by P5
job …**. The raw P5 detail is still in the session log.

## Proxy Delivery and P5 listed from the start

Both now appear as soon as the artifacts start, waiting their turn with a clock, instead of
appearing out of nowhere when they begin. A finished proxy delivery no longer reads "Nothing to do".

## Settings in the header

A gear beside the size control at the top of the window opens Settings. The Settings button lower
in the window, which several destinations pushed out of sight, is gone.

## What to test

1. Press Start with your enforced preset and two destinations: one review window, with the
   exclusions and folders inside it.
2. Copy an MKV card with `mkv` listed under External Codecs: the contact sheet has thumbnails.
3. With proxies, a proxies-only destination and P5 on: both appear waiting when the copy finishes,
   then finish with their real results; P5 never reads "failure" unless the job really failed.
