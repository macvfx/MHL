# CopyTrust 3.0.1 Build 58 — beta

2026-10-20 · CopyTrust only. Drop Verify is at 3.0.1 build 52 and Folder Copy Compare at 3.0.1 build 53. It
includes everything in CopyTrust 3.0.1 build 54 — see [RELEASE-NOTES-3.0.1-b54.md](RELEASE-NOTES-3.0.1-b54.md).

Four changes from operators on site.

- **A clean copy is not marked "check before ejecting".** After a Quick-verified copy both cards turned
  orange with a warning triangle while the Review Summary said Clean. Quick writes no MHL file and the missing
  one was counted as a warning. It is now counted only after Inline or Full verification. A clean card shows a
  green thumbs-up and "copied & verified"; a card that needs a look shows the first reason beneath the triangle.
- **Almost nothing is excluded by default.** Every exclusion starts off in Card mode; in Folder mode only the
  System group (.DS_Store, .Spotlight-V100 and the like) starts on. Receipts, manifests, proxies, camera-card rows
  and Final Cut Relink Aliases are off in both, so a facility's own Final Cut proxy folder is copied. Saved
  settings and loaded presets keep what they had; check an older preset after loading it.
- **Unload a preset.** Moving a preset's file out of the presets folder never stopped it applying, because its name,
  naming rules and destination check live in settings. **Preset ▸ Unload** clears them, with a choice to keep the
  current copy settings or reset them to the defaults. The file is not deleted. Not offered under a managed policy.
- **Build a Preset.** **Preset ▸ Build a Preset…** steps through an ordinary preset with no naming convention:
  checking a copy, reports, proxies, exclusions, folder names, notifications and, if you want, the staged
  destinations. It starts from the defaults, so nothing is inherited from a preset used before.

Test: copy a card with verification set to Quick; it should read "copied & verified" with a green thumbs-up. Open
Settings ▸ Exclusions in both modes. Load a preset, then Preset ▸ Unload. Preset ▸ Build a Preset… and read the
summary before saving.
