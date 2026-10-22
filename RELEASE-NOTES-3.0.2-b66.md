# 3.0.2 Build 66 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-22 · One release carries three apps, all at 3.0.2 build 66, so each app's update check sees one version. It includes everything in
3.0.2 build 64 — see [RELEASE-NOTES-3.0.2-b64.md](RELEASE-NOTES-3.0.2-b64.md). Build 65 was not published separately; its changes are here.

**CopyTrust**

- **Volume filters.** The Card, Drive and Network labels above the Volumes strip are buttons: click one to show only that kind, and All (or the same
  label again) brings the list back. A volume that is not responding, or has just mounted, is always shown.
- **Get Info on a volume** (right-click) groups its facts under Volume, Space and Connection, including the USB port and whether it is behind a hub.
  Eject sits at the far right of a tile, clear of Source and Dest.
- **A card added after the run finished** (only artifacts still going) joins the run and is started by auto-advance, instead of waiting as a separate batch.
- **Less blank space** on the copy progress screen while the Files list is closed.
- **Camera Card exclusions warning:** a new **Turn Off Exclusions and Copy** answer, and wording that says what each button does.
- **Start blocked says why:** the reason sits beside the chip, **Why?** opens the full explanation and the way forward, and a destination that cannot be used is named.
- **Session Summary** keeps its title and buttons in view and scrolls everything between them (build 65).
- **Not responding clears itself:** a volume that missed the probe is asked again every 4 seconds, up to four more times (build 65).
- **New Folder** in the Dest panel of Volumes, the batch destination picker and Drop Verify's artifact-folder picker (build 65).
