# 3.0.1 Build 60 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-21 · One release carries three apps, all at 3.0.1 build 60, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. It includes everything in CopyTrust 3.0.1 build 59 and 58 —
see [RELEASE-NOTES-3.0.1-b58.md](RELEASE-NOTES-3.0.1-b58.md) and [RELEASE-NOTES-3.0.1-b59.md](RELEASE-NOTES-3.0.1-b59.md).

**CopyTrust**

- **Folder mode says folder.** The copy progress read "Card 1 of 2" while copying folders. It now says *Folder 1 of 2*, and the finished
  banner and the menu bar say folder and folders. Card mode still says Card.
- **A folder dropped under an enforced naming preset.** The naming sheet asked a plain folder for a project, unit and roll as if it were
  a camera card, and closing the sheet removed the source, which looked like the mode change had lost it. The sheet now says it looks
  like a folder and offers **Switch to Folder Mode**, which keeps the source. Escape still removes it, and the session log records which
  happened.
- **Hidden files are no longer skipped by default.** *Skip hidden files* started on and dropped files without saying so. It starts off in
  both modes. A Mac with a saved setting keeps it.

**Drop Verify**

- **Exclusions start as CopyTrust's do.** Only the System group (`.DS_Store`, `Thumbs.db`) is on. The Receipts & Manifests rows
  (including the broad `.mhl` pattern, `contactsheet_` and `dropverify_`) are offered but unchecked, so a verify no longer skips a manifest
  written by ShotPut, Hedge or OffShoot. Verifying the same folder a second time now hashes Drop Verify's own earlier receipts and `.mhl`
  unless those rows are ticked. A saved list keeps what it had.

**Folder Copy Compare**

- **Favourites.** The bookmark button is now a star. **Recheck** scans a favourite's two folders quietly, in its own Quick or Full mode,
  and records what it found; **Recheck All** does every favourite in turn; **History** lists the last 25 checks. History holds counts
  only, no file names or paths. A quiet recheck compares source and target only. Saved profiles carry over.

Test: copy two folders in Folder mode and read the progress; open Settings ▸ Exclusions in CopyTrust and Drop Verify on a fresh install;
add a comparison to Favourites, Recheck it, change a file, Recheck again, and open History.
