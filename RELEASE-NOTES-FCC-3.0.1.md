# Folder Copy Compare 3.0.1 Build 53 — beta

2026-10-19 · Folder Copy Compare only. CopyTrust is at 3.0.1 build 51 and Drop Verify at 3.0.1 build 52.
It includes everything in Folder Copy Compare 3.0 build 50.

- **Drop folders on the Dock icon.** You do not need the window in front. Drop one or two folders on
  Folder Copy Compare's Dock icon, or on the app in Finder, or choose *Open With* on a folder. The first
  fills the empty Source side and the next the Target side, in whichever mode is showing (Compare or
  Subfolder Check), and the window comes forward. Two folders dropped together become Source then Target.
- With both sides already loaded, dropping one folder asks which to replace, and dropping two asks before
  replacing both. Files are ignored, a folder already loaded on the other side is not compared with
  itself, and more than two folders are cut to two. The app says when it left something out.
- It loads the folders as a drop on the drop zones does: in Compare mode you still click *Compare Folders*,
  and Subfolder Check starts its scan.
- Folder Copy Compare never becomes your default app for folders; opening it with a folder is always your
  choice.
- Includes the fix from CopyTrust 3.0.1: a SAN or network volume that stops answering is listed as
  *Not responding* instead of freezing the window.

Test: with Folder Copy Compare not running, drop two folders on its Dock icon or on the app in Finder;
both should load, with the window in front. Drop one more with both loaded: you are asked which to replace.
