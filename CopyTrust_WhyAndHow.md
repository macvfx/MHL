# CopyTrust — Why, and How

A copy is not done when the files appear. It is done when you can **prove** they arrived
intact, and hand someone the evidence. CopyTrust does the copy, the proof and the
paperwork in one pass.

- **Verified, not hopeful** — every file hashed and checked, with an industry-standard MHL
- **Evidence travels with the media** — receipts, manifests and logs beside the footage
- **And to a folder you can audit** — the same evidence mirrored to shared storage
- **One preset sets the whole job** — load it, pick destinations, press Start

<div class="page-break"></div>

## Copy mode — Card or Folder

One switch that changes what a run is *for*. Everything else follows from it.

- **Card** — camera-card ingest. Inline verification, `{alias}_{date}` naming, contact
  sheet on, destination sort on, auto-advance on, camera-card exclusions active.
- **Folder** — folder backup and archive. Quick verification, plain `{alias}` naming,
  artifacts off by default, exclusion groups for file-storage and system clutter.
- **Every artifact setting is stored per mode.** Changing the contact sheet for Card
  leaves Folder alone. The mode picker is orange because it changes what a run *will* do —
  it starts nothing.
- **The pre-copy review states the mode**, so a card copied in Folder mode by accident is
  caught before any file moves rather than discovered afterwards.

<div class="page-break"></div>

## Presets — set it up once

A preset is the whole policy under one name.

- **It carries everything that decides a run** — verification level, naming and prefix,
  contact sheet, EXIF CSV, HTML tree, proxies, destination sort, external codecs, receipt
  export. Both Card and Folder profiles travel together.
- **It never carries destinations.** That is deliberate: a preset can never send a copy
  somewhere unexpected. You always pick the drives yourself.
- **One load, then pick destinations, then Start.** That is the whole setup for a
  fully-configured run with artifacts, proxies and P5.
- **A dot marks drift** — settings changed since you loaded it. Update the preset from
  current settings, or load it again to discard.
- **House presets are shared and read-only**, so every operator in the building starts
  from the same policy.

<div class="page-break"></div>

## Fan out — one card, every drive at once

The everyday shape: a card to a working drive and a backup, together.

- **`Copy: Simultaneously`** writes every destination at the same time, reading the card
  once per destination.
- **Cards go one at a time.** *Simultaneously* describes the destinations, not the cards.
  Turn `Auto` on and the next card starts by itself.
- **Every card is visible** with its own bar and status; the run's bar covers the whole
  job, not just the card in hand.
- **Each destination is verified independently** and gets its own MHL and receipts. One
  slow drive never invalidates another.
- **The card is free as soon as copying and verification finish** — artifacts and proxies
  carry on in the background while you pull the card and reload the camera.

<div class="page-break"></div>

## Relay chain — card to SSD to NAS

When the network is the slow part, do not make the card wait for it.

- **`Copy: In series`** copies card → fast local drive first, then feeds the *verified*
  local copy onward to the NAS.
- **The card is released after the first, fast stop** rather than being held for the
  length of a network copy.
- **Each stop is verified before the next begins**, so nothing downstream inherits a bad
  copy.
- **Order is visible and editable** — `Stop 1`, `Stop 2`, reorderable before you start.
- **A new chain defaults sensibly** — P5 on the first stop, proxies on the last. Camera
  archive first, editing storage last.
- **The plan is written down** — an immutable, password-free workflow plan with ordered
  step and dependency IDs, exported beside every leg's receipts.

<div class="page-break"></div>

## Artifacts — the paperwork, automatically

Generated after the trust chain is sealed, so they never delay or endanger the copy.

- **MHL** — the hash list, in the format Silverstack, OffShoot, ShotPut Pro and YoYotta
  all read. This is the portable proof.
- **Contact sheet PDF** — what is actually on the card, at a glance. Large cards split
  into numbered parts.
- **EXIF / media CSV** — camera, lens, codec, timecode, resolution, duration per clip.
- **HTML directory tree** — the delivered structure, browsable, generated natively.
- **Session receipts and logs** — JSON and plain text, plus a per-copy log with the
  operator, machine, settings and every decision the run made.
- **Two copies of the evidence.** Everything is written beside the media *and* mirrored to
  an export folder on shared storage — so an assistant, a producer or an auditor can check
  a delivery without touching the drive it went to.

<div class="page-break"></div>

## Proxies — editorial can start immediately

Optional, off by default, and never able to affect the verified result.

- **H.264 or HEVC Main 10 MOV** at 12.5%, 25% or 50%.
- **Final Cut layout** — `Final Cut Proxy Media/YYYY-MM-DD/…` with the exact original
  basename, which is what makes Final Cut relink cleanly.
- **Only verified files get a proxy**, and proxies are written beside the media, never
  into the evidence export — they are footage, not proof.
- **Rotation and colour are carried across**, so portrait drone and phone footage is not
  reported with swapped dimensions.
- **A failed encode is reported and skipped.** It never changes the copy's verdict.
- **Every run writes its own evidence** — JSON, an operator summary and an encode log
  comparing original and proxy.

<div class="page-break"></div>

## Archiware P5 — straight to the archive

Hand a verified destination to the tape or disk archive without a second tool.

- **It runs after verification**, on a destination that has already passed, so nothing
  unverified is ever archived.
- **The provenance goes with it** — xxHash64, frame size, codec, frame rate, timecode,
  reel, source card, camera and capture date land as searchable P5 fields.
- **Safety is enforced, not assumed** — Quick copies are never auto-archived, plans that
  delete source files are blocked, and a P5 failure never changes a successful copy result.
- **Offline is handled** — if P5 is unreachable, a password-free request JSON preserves
  paths, hashes, metadata and job state for submission later.
- **Chosen per destination**, so the archive drive goes to P5 while the editing drive gets
  proxies.

<div class="page-break"></div>

## The rest of the suite — after a CopyTrust run

Three small tools that answer questions CopyTrust's own receipts cannot.

- **Drop Verify** — for media you were *handed*, with no copy involved. Drop a folder and
  get an MHL, contact sheet, CSV and tree. Use it on an incoming drive from another unit
  before you accept it.
- **MHL Verify** — open any `.mhl` and re-verify the files still match, or compare two
  manifests side by side from different volumes. Use it weeks later on an archive restore,
  or to prove a delivery matches what left the set. It understands a destination-sorted
  copy and reports it as `Moved` rather than a failure.
- **Folder Copy Compare** — the blunt "did the copy work?" check on any two folders,
  whatever made them: Finder, rsync, Hedge, P5 Sync. Also spots Archiware P5 stub files.
- **They share one MHL engine**, so a manifest written by any of them verifies in all of
  them — and in other vendors' tools.

<div class="page-break"></div>

## In short

- **The copy is verified, and the proof is portable.** MHL is not a CopyTrust format.
- **The evidence exists in two places** — with the media, and in an auditable folder on
  shared storage.
- **One preset plus destinations configures everything**, so the operator makes one
  decision rather than fifteen.
- **The card is released as early as it safely can be**, and the slow work continues
  without holding anyone up.
- **Nothing optional can damage the result.** Proxies, artifacts and P5 all run after the
  trust chain is sealed, and a failure in any of them leaves the verified copy intact.

<div class="page-break"></div>

## For the IT admin — deploying it

Everything is signed and notarized, so nothing needs a Gatekeeper exception.

- **The apps** — CopyTrust, Drop Verify, Folder Copy Compare and MHL Verify ship as
  Developer-ID signed, notarized DMGs. Each checks GitHub for its own updates, so
  operators are not chasing versions.
- **Dependencies deploy like any other managed package**, separately from the apps, via
  Munki, MDM or whatever you already use:
  **ffmpeg and ffprobe** to `/usr/local/bin/ffmpeg`, from the supplied installer — needed
  for professional-format thumbnails and for proxy encoding;
  **ExifTool** — richer metadata on pro formats;
  **REDline** — only if the house shoots R3D.
  CopyTrust auto-detects each one, or you point it at the path.
- **No `tree` binary.** HTML directory trees are generated natively. The setting still
  exists in External Codecs for diagnostics — leave it unset.
- **House presets deploy read-only** from `/Users/Shared/CopyTrust/Presets`. That path
  exists on a fresh Mac and needs no user account, so MDM or a script can place a preset
  before the operator's first launch. Personal saves go to Application Support, so
  re-deploying can never clobber them.
