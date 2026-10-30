# 3.0.5 Build 78 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-29 · One release carries three apps, all at 3.0.5 build 78, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. The marketing version moved from 3.0.4 to 3.0.5 with no
functional change of its own — Munki compares that string, not the build number, so a Mac already on 3.0.4 now sees this as an
update. It includes everything in 3.0.4 build 75 — see [RELEASE-NOTES-3.0.4-b75.md](RELEASE-NOTES-3.0.4-b75.md). Builds 76 and
77 were local test builds, never published.

**CopyTrust**

- **The ingest receipt now records the source's size before the copy, next to what was actually copied.** Before this, the
  plain-text and JSON receipts only ever recorded what landed on the destination — a shortfall from a dropped connection or a
  failed file was visible only as an error flag, with no way to see how much was missing without opening the session log and
  doing the arithmetic by hand. The plain-text receipt now shows a `Scanned` line directly above the existing `Copied` line
  for each source, in the same files-then-size order so the two compare at a glance. The JSON receipt carries the same two
  numbers as `scannedSourceFiles` and `scannedSourceBytes`.
- **The receipt also now names the copy mode the job ran in** — `Mode    : Card` or `Mode    : Folder` in the plain-text
  header, and a top-level `copyMode` key in the JSON.
- **The launch panel is five steps again, with nothing else in it.** Build 75's panel carried the quick-start steps plus a
  stack of per-version highlights that was drifting back toward being a changelog — exactly what the panel was changed to stop
  doing. It is back to the five steps alone; what changed in the build, and what to test in it, stay in **Help ▸ What's New**.

Test: run one Card-mode copy and one Folder-mode copy, click Finish / Close Session on each, and check the `.txt` receipt in
the destination's Receipts folder for a `Mode` line in the header and a `Scanned` line above `Copied` for the source. Check
the matching `.json` receipt for `copyMode`, `scannedSourceFiles` and `scannedSourceBytes`.
