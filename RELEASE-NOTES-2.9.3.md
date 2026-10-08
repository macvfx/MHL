# CopyTrust, Drop Verify and Folder Copy Compare 2.9.3 Build 33 — beta

2026-10-06 · All three apps, one version again. CopyTrust includes everything in 2.9.2 build 32 —
see [RELEASE-NOTES-2.9.2.md](docs/releases/RELEASE-NOTES-2.9.2.md). Drop Verify and Folder Copy Compare move
from 2.8.2 build 22.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Final Cut Pro relinks every proxy at once

Final Cut Pro accepted CopyTrust proxies, but only one at a time. Its **Locate All** search matches
files by name before it looks at the media, and it does not count `clip001.mov` as a match for
`clip001.MP4`, so pointing it at the proxy folder found nothing.

CopyTrust now writes a **Final Cut Relink Aliases** folder beside the proxy folder, with the same
date and card folders beneath it. Each file in it is a Finder alias named exactly like an original —
extension and case included — that opens the real proxy. To relink a batch:

1. In Final Cut Pro, select the clips, event or library.
2. **File > Relink Files > Proxy Media**, click **All**, then **Locate All**.
3. Choose the **Final Cut Relink Aliases** folder. It should read *N of N files matched*; click
   **Relink Files**.

Final Cut keeps the path of the real `.mov`, so the proxies stay linked after a relaunch and the
alias folder can be deleted afterwards. Field-tested on Final Cut Pro 12.4.

- Every alias is checked after it is written: a real Finder alias that opens its own proxy. A file
  already at that path that is not an alias is never replaced.
- The proxy receipt lists the alias folder and any alias that failed, and says *prepared for
  relinking* — nothing is connected until you relink.
- The aliases stay out of the proxy folder, so a proxies-only delivery does not carry aliases that
  point back at the first drive. Nothing is written inside a `.fcpbundle`.

## Drop Verify does the same

Drop Verify's proxies get the same **Final Cut Relink Aliases** folder, and its Settings and Help
explain the relink steps.

## One version for all three apps

All three apps check this repository for updates and compare themselves against the release marked
Latest. While their versions were split, Drop Verify and Folder Copy Compare were offered
CopyTrust's release as an update to themselves, and their own pre-releases never appeared in Check
for Updates. From 2.9.3 they share one version and one release. Folder Copy Compare has no other
change.

## What to test

1. Copy a card with proxies on and import the originals into a test library.
2. Relink Files > Proxy Media > All > Locate All on the Final Cut Relink Aliases folder: every clip
   matches, and stays linked after relaunching Final Cut.
3. If you can, a `.MOV` camera, and two cards with the same clip names.
4. Drop Verify: drop a folder with video and proxies on, then relink from its alias folder the same way.
5. Drop Verify and Folder Copy Compare: Check for Updates reports up to date on 2.9.3.
