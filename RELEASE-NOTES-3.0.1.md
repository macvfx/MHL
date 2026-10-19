# CopyTrust 3.0.1 Build 51 — beta

2026-10-19 · CopyTrust only. Drop Verify and Folder Copy Compare stay at 3.0 build 50 for now and will follow.
It includes everything in 3.0 build 50 — see
[RELEASE-NOTES-3.0.md](RELEASE-NOTES-3.0.md).

- **A volume that stops answering no longer freezes CopyTrust.** On a Mac with a SAN (Xsan or
  StorNext) or network volume mounted, a volume whose lock got stuck made CopyTrust stop responding —
  for hours in one case — and again at every launch, until the Mac was restarted. CopyTrust read the
  top level of every mounted volume on the thread that draws the window, and a stuck volume never
  answers. Volumes are now read in the background, each for up to three seconds. One that does not
  answer is listed as **Not responding** with a red badge, and the others keep their capacity and
  card detection.
- Adding a card or folder as a source no longer waits on a stuck volume either; it is added with its
  folder name as the alias.
- A copy to or from a volume that is genuinely stuck still cannot proceed. This fix keeps CopyTrust
  usable and tells you which volume is not responding. The stuck lock itself belongs to the SAN or
  share: restart it, or restart the Mac.
- **Troubleshooting for a stuck or crashed CopyTrust** is new in the user guide and in Help ▸
  Troubleshooting: restart the Mac first, check for a stuck volume, confirm your copies are safe, find
  the crash report (or `sample CopyTrust 5` for a hang), and move saved state aside one item at a time.
- The version moves to 3.0.1, not just the build, so deployment tools that compare the version see
  an update.

Test: with a SAN or network volume mounted, open CopyTrust and the Volumes panel — it opens at once. If
a volume is unresponsive, its tile says Not responding and the others still show capacity.
