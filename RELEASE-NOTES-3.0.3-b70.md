# 3.0.3 Build 70 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-26 · One release carries three apps, all at 3.0.3 build 70, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. The marketing version moved from 3.0.2 to 3.0.3 with no
functional change of its own — Munki compares that string, not the build number, so a Mac already on 3.0.2 now sees this as an
update. It includes everything in 3.0.2 build 67 — see [RELEASE-NOTES-3.0.2-b67.md](RELEASE-NOTES-3.0.2-b67.md).

**CopyTrust**

- **Eject no longer fails with a bare "OSStatus error -36".** A disk image's volume can unmount itself before you click Eject —
  the mount point under `/Volumes` disappears while the image stays attached underneath it, leaving nothing for the ordinary
  eject call to act on. CopyTrust now finds that disk by volume name and detaches it directly instead of showing the raw error.
- **Eject shows a spinner, and a volume that is gone stops lingering in the list.** The Eject button had no busy state at all,
  so a click showed nothing until it finished; it now turns into a spinner immediately and disables itself while working. An
  ejected volume's tile used to sit exactly as it was until you pressed Refresh — it now drops out of the list the moment the
  eject finishes.
- **Show in Finder refuses to reveal something unrelated.** On a volume that had already gone, Show in Finder could open an
  unrelated, same-named item elsewhere on disk instead of doing nothing. It now checks the volume still exists first.

**Folder Copy Compare**

- **Favourites rows are easier to read.** Each row is now laid out in layers — name and badges, then Source, Target and
  Reference each on their own line, then the result and history — instead of one crowded line of truncated text.
- **The star brings the current folders in.** Opening a favourite now shows the Source, Target and Reference already loaded,
  with a pre-filled name and one **Add to Favourites**.
- **Compare and Subfolder Check keep their results** when you switch between them, instead of clearing a finished comparison
  every time.
- **The main window no longer squashes** in a short window — the mode picker used to draw over the drop zones.

Test: eject a card or drive and watch for the spinner and the tile dropping on its own; try Show in Finder right after ejecting
something; in Folder Copy Compare, star a comparison, reopen it, and switch between Compare and Subfolder Check without losing
results.
