# CopyTrust, Drop Verify and Folder Copy Compare 2.9.8 Build 43 — beta

2026-10-14 · All three apps share this version. CopyTrust and Drop Verify carry the changes. It
includes everything in 2.9.7 build 39 and 40 — see [RELEASE-NOTES-2.9.7.md](RELEASE-NOTES-2.9.7.md).

Build 43 replaces build 41, published earlier the same day. What changed since build 41:

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
