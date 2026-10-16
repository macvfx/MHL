# CopyTrust, Drop Verify and Folder Copy Compare 2.9.8 Build 48 — beta

2026-10-15 · All three apps share this version. CopyTrust and Drop Verify carry the changes. It
includes everything in 2.9.7 build 39 and 40 — see [RELEASE-NOTES-2.9.7.md](docs/releases/RELEASE-NOTES-2.9.7.md).

Build 48 replaces build 47, published the same day. It changes no behaviour: the in-app help,
What's New and launch panel now describe this release, and read their version from the app instead
of showing the one they were last typed for. The user guides' status lines were corrected too.

Build 47 replaces build 45. Build 46 was never built; its changes are part of 47. What changed in 47,
since build 45:

- **A card added during a copy joins that copy.** For the same drives, the Add button or a drop on
  the queue strip now makes it one more source of the running copy (*4 sources*), measured like the
  others, not a second batch below. It gets the pre-copy review once it is named; unanswered for 90
  seconds it is queued as shown.
- **A quiet verify says Verifying.** Hashing one large file reports nothing until it is done, so it
  used to read *No data for 1m 35s*. It now says *Verifying … still checking this file* and is only
  flagged after five minutes.
- **Skip measuring.** A card still *Scanning…* has a Skip button, for a card going to a NAS or a large
  SSD where the room is known. A destination whose cards were not measured says *Size not measured*,
  not *Needs 0 bytes*. Starting a copy stops any size scan still running for that card.
- **Volumes keeps every volume.** It was *Available Volumes* and a card picked as a source left the
  list, which looked like an eject. It stays, marked Source or Destination, every drive and network
  volume has an eject icon, and **Eject All** ejects what is safe and lists what it left.
- **Folder mode shows no off-site notice**, and the action bar is leaner: *Preflight passed*, the
  P5 badge and (under enforced naming) the prefix field are gone, and so is the exclusions row.

Build 45 replaces build 43, published the day before. Build 44 was a test build and was never
published; its change is part of 45. What changed since build 43:

- **Loading a project list says so.** Off site, *Load project list… ▸ From a volume or folder…* now
  shows *Reading projects from …* while it scans and then *Project list loaded from …: N projects*
  next to the menu, in both off-site layouts. If the preset has no naming convention the load now
  says so instead of returning silently.

What changed in build 43, since build 41:

- **One name for every receipt.** The files in a delivery's `Receipts` folder are named
  `<delivered folder>_<kind>_<stamp>`, flat in the one folder, with one timestamp for the delivery.
  The EXIF CSV is now `…_metadata_….csv`, and proxy receipts are no longer in a `Proxy Media`
  subfolder. Deliveries made by earlier builds keep their names and are still read. Drop Verify uses
  the same names.
- **A card added during a copy is named when it is added**, under enforced naming. The Add button, a
  drop on the queue and a volume chosen in queue mode now ask for the project, unit and roll first;
  before, they were asked only when the batch started.
- **A Keychain prompt can no longer freeze the window** at the end of a card. Notification secrets
  are read in the background.
- The naming sheet no longer squeezes the Roll label, and the launch panel sets "New in" apart from
  the five steps.
- **The copy map is written into each delivery's Receipts folder**, not a second receipts folder
  beside the deliveries.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent. **Most of this build has been tested in software, not yet on a
full shoot.** Please run a real multi-card queue and report what you see.

## Several cards, several drives

- **One progress for the whole run.** Bytes, file copies, speed and time left cover every card, with
  a line for the card in hand.
- **A card that will not fit a drive is skipped for that drive, whole.** It is never partly written,
  the other drives still receive it, and the review names the drive and the sizes. A full drive no
  longer stops Start or an unattended queue.
- **A banner when the cards will not all fit.** It offers a destination for all cards or only for
  the extra ones. Settings ▸ Copy Behaviour ▸ *Copies of each card* sets the minimum and the
  preferred number of verified copies.
- **Copy map.** Every card against every drive, and what is still owed, written as CSV and JSON in
  each drive's Receipts folder. **Copy to N missing** copies a card to the drive it missed later.
- **Eject is guarded.** Refused while a card or drive is in use; asks first when a card has fewer
  verified copies than your minimum; a card short of preferred is not auto-ejected.
- Naming is asked as a card is added when the preset enforces it. A new drive can use the same folder
  structure as another destination. An off-site folder keeps its name on site.

## Notifications away from the Mac

**Remote notifications** (Settings ▸ Notifications): Pushover, or a JSON webhook to a URL you give.
One message when all cards finish, when a copy fails, or when a drive drops. It carries counts and
fixed sentences only — never a card, project, drive or folder name, and never a path. The webhook also
carries a random event ID and a random station ID. Secrets are kept in the Keychain.

## Better camera details

Make, model, lens, serial number, firmware and start timecode now come from the sidecar next to a
clip (Sony and Canon), ExifTool and ffprobe as well as the file itself, checked on real Atomos, Sony
and Canon cards. The metadata CSV (the EXIF CSV before build 43), in CopyTrust and in Drop Verify, has five new columns after `ISO`:
`DateNote`, `DateBasis`, `DateTakenWallClock`, `MetadataSources` and `MetadataNote`. **Read the CSV by
column name, not position.** The contact sheet shows lens and serial and lists the tools used.

## What to test

1. Four cards to two destinations with one small drive. Start stays enabled; the small drive is
   skipped whole with nothing written; **Copy to 1 missing** brings it level once there is room.
2. The same with auto-advance on, and walk away: the queue does not stop.
3. Save and send a test notification; read the message for names or paths.
4. Copy a Sony and a Canon card and open the metadata CSV: serial, lens, `StartTimecode`, `MetadataSources`.
5. Under enforced naming, add a card while a copy is running: the naming sheet should ask.
6. Look at one delivery's `Receipts` folder: one name pattern, one timestamp, nothing in a subfolder.
7. Off site, with the facility volumes ejected: load a project list from a volume or folder. The line
   *Project list loaded from …* appears at once, with a count, and the card's project picker offers them.
