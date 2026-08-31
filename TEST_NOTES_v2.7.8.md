# CopyTrust 2.7.8 — Test Notes

**Build under test:** 2.7.8.5 Build 12 · **Previous release:** 2.7.8.4 Build 11
**Written:** 2026-08-28 · **Build 8 added:** 2026-08-29

**What this release is about:** the manifest a card **arrived with**. Everything else in CopyTrust
proves the copy *it* made. This proves what the footage was before CopyTrust touched it — and the
two are different claims that a damaged card makes disagree.

**Companions:** `COPYTRUST_FIELD_CHECKLIST.md` is the standing checklist for the whole app.
`COPYTRUST_SOURCE_MANIFEST_VALIDATION_PLAN.md` is the design this implements, and its decision
numbers (D1–D11) are cited below where a behaviour is deliberate rather than incidental.

---

## Why this exists

A card shot off site is frequently offloaded by somebody else — OffShoot, Silverstack, ShotPut Pro
— and reaches the facility as a folder with an MHL beside it. CopyTrust ingested that folder and
never looked at the manifest.

So a file that was **already corrupt when it arrived** was copied and verified without complaint:
CopyTrust hashes what it reads and what it writes, and those agree, because it faithfully copied a
broken file. The receipt said clean, proxies were made from bad footage, P5 archived it, and the
shuttle drive was wiped. The damage surfaced weeks later in an edit with nothing to distinguish
footage that arrived broken from footage this facility broke.

**Mark each item P (proven), F (failed) or S (skipped).**

---

## Session Info

- Date:
- Operator:
- Machine / macOS:
- Version in About (must read **2.7.8.5** — the fourth number is what Munki compares):
- Verification level (**Inline or Full** for most of this):
- Source used:
- Destinations:

---

## A. What a staged card says before anything is copied

**A1 — A card that arrived with a manifest says so, and says who wrote it**
- **Do:** stage a folder offloaded by another tool, with its `.mhl` at the root or an `ascmhl/`
  folder beside it.
- **Expect:** a line on the row naming the tool and the entry count — *Arrived with an ASC MHL from
  OffShoot 25.3.3.1879 — 412 files.*
- **Evidence:** `sourceManifest staged … author=third-party` in the session log.
- Result: ☐ P ☐ F ☐ S

**A2 — A card with no manifest says that too**
- **Expect:** *No manifest found beside this source.* Stated, not silent — an absent manifest and
  one nobody looked for are indistinguishable otherwise (D2).
- Result: ☐ P ☐ F ☐ S

**A3 — A manifest that cannot be read is not reported as absent** *(fixed in build 7)*
- **Do:** put a truncated or non-XML `.mhl` beside a source.
- **Expect:** *Arrived with a manifest that could not be read.* A corrupt manifest is evidence —
  arguably the most alarming a shuttle drive can carry — and build 4 reported it as "no manifest".
- **Evidence:** `sourceManifest unreadable … path=…`.
- Result: ☐ P ☐ F ☐ S

**A4 — The promise matches the setting** *(fixed in build 7)*
- **Do:** stage the same card under **Quick**, then under **Inline**.
- **Expect:** Quick says *Needs Inline or Full verification to be checked — this copy will not
  check it.* Inline says *Will be checked as this card copies.* Build 4 promised the check in every
  mode, including the two that cannot perform it.
- Result: ☐ P ☐ F ☐ S

**A5 — A folder CopyTrust delivered says the manifest is ours**
- **Do:** stage a folder from an earlier CopyTrust delivery.
- **Expect:** *Arrived with a manifest CopyTrust wrote — it cannot check how this footage arrived.*
  Checking footage against our own record only confirms it still matches what we recorded (D11).
- Result: ☐ P ☐ F ☐ S

---

## B. The check itself, during the copy

**B1 — An intact card matches, and it costs nothing**
- **Do:** copy the A1 card with Inline verification.
- **Expect:** Review Summary shows a **Source Provenance** card above Session Health: green,
  *Matched the manifest it arrived with — all N files*, crediting the tool.
- **Also:** the copy takes no longer than the same card without a manifest. The comparison reuses
  the hashes the copy already takes off the source (D4).
- Result: ☐ P ☐ F ☐ S

**B2 — Footage that arrived damaged is named, and the copy still succeeds**
- **Do:** alter one byte of a file *after* its manifest was written, then copy.
- **Expect:** the copy completes and verifies **clean** — it faithfully copied a broken file — and
  the Source Provenance card is **red**, naming the file. Those two facts are meant to disagree
  (D5).
- **This is the item this release exists for.** If the copy fails, or the summary shows one
  combined verdict, that is an F.
- Result: ☐ P ☐ F ☐ S

**B3 — A mismatch never blocks**
- **Expect:** every file still copies. Damaged footage is still the only footage, and the drive it
  came on is usually about to be wiped (D6).
- Result: ☐ P ☐ F ☐ S

**B4 — Quick claims nothing rather than guessing**
- **Do:** copy the B2 card with **Quick**.
- **Expect:** no Source Provenance card at all. No source hashes exist, so nothing is claimed.
- Result: ☐ P ☐ F ☐ S

---

## C. Coverage — where a green tick would overstate things

**C1 — Partly checked is amber, not green** *(fixed in build 7)*
- **Do:** use a manifest mixing xxHash64 entries with MD5 or SHA-1 entries.
- **Expect:** **amber**, *Partly checked — N of M files matched … The rest were not checked.*
  Build 4 returned a green seal whenever one entry matched, so one checked file among fifty
  unchecked ones looked like a clean pass.
- Result: ☐ P ☐ F ☐ S

**C2 — A manifest naming files this copy did not read is also partial**
- **Do:** exclude a folder the manifest covers, then copy.
- **Expect:** amber, with *N entries name files this copy did not read.*
- Result: ☐ P ☐ F ☐ S

**C3 — Files the manifest does not mention are counted, never failed**
- **Expect:** *N files were copied that this manifest does not mention* — and the verdict stays
  green if everything the manifest **did** claim matched. A manifest covering a subset of what was
  staged is normal (D8).
- Result: ☐ P ☐ F ☐ S

**C4 — A manifest in an algorithm we cannot read at all**
- **Do:** a manifest whose every entry is `xxh3`, `xxh128` or `c4`.
- **Expect:** stated as not comparable. Never green.
- Result: ☐ P ☐ F ☐ S

---

## D. Interrupted copies

**D1 — A resumed copy reports the same verdict as an uninterrupted one** *(fixed in build 7)*
- **Do:** cancel a copy part-way, then resume it.
- **Expect:** the same Source Provenance result as copying it in one run. In build 4 resumed files
  counted as *not read*, and a copy that resumed everything produced no verdict at all — the record
  changed shape depending on how the run had been interrupted.
- Result: ☐ P ☐ F ☐ S

**D2 — Reconciling an existing intact destination**
- **Do:** copy to a destination that already holds a verified copy.
- **Expect:** a source verdict, not silence.
- Result: ☐ P ☐ F ☐ S

---

## E. The record

**E1 — Two verdicts, never merged**
- **Do:** `jq '.sourceEntries[].sourceManifestVerdicts' <receipt>.json`
- **Expect:** the source verdict as its own field, separate from the copy's own verification. The
  text receipt carries `Source :` lines saying the same thing in words.
- Result: ☐ P ☐ F ☐ S

**E2 — The log tells the story once**
```bash
grep -E "sourceManifest" ~/Library/Application\ Support/CopyTrust/logs/*/session_*.log
```
- **Expect:** `staged`, then `found`, then one `verdict=` line per source — **not** one per
  destination. A fan-out printed the verdict and every differing filename twice until build 4.
- Result: ☐ P ☐ F ☐ S

---

## F. Everything else in the build

- [ ] **The card banner.** Each finished card reads *Card 1 · <alias> — copied & verified* at
      roughly twice the size of anything around it, above the artifact rows and visible whether or
      not the section is expanded. The card's name is ordinary text; only the checkmark and the
      verdict word are coloured.
- [ ] **Artifacts fold away.** Per-card disclosure, closed by default. A closed row still reads
      *Artifacts — 1 failed* or *— 2 running*, so a failure is never hidden by being demoted.
- [ ] **New conventions create project folders.** A convention built in the wizard files a new job
      rather than sending it to `_Ingest`. An existing preset keeps whatever it was saved with —
      **Preset ▸ Edit… ▸ "Let operators create a project folder that does not exist yet"**.
- [ ] **The landing preview explains itself when held open.** A card heading for the dated ingest
      folder cannot collapse the preview; it shows an amber mark and says why, rather than a
      chevron that appears to do nothing.
- [ ] **Help does not resize.** Switching topics scrolls; the window stays the shape it opened.
- [ ] **Drop Verify and Folder Compare skip the `Receipts` folder.** A second Drop Verify pass over
      a folder does not hash its own prior output, and a deep compare of a clean delivery reports
      no differences.

---

## G. Build 8 — where evidence lands, and what a preset carries

Four things field testing build 7 turned up. The first two are placement faults: evidence written
somewhere other than where an operator goes looking for it. The last two are preset gaps — the
model could already describe a facility's setup, and there was no way to say so.

**G1 — One receipts folder per delivery, holding everything**
- **Do:** copy a card with the EXIF CSV, contact sheet, HTML tree and proxies all on, to a
  destination that has never held a CopyTrust delivery. Open the delivered folder.
- **Expect:** exactly **one** `Receipts` folder. Inside it: the receipt `.txt`, the `.log`, the
  session manifest, the provenance JSON, the HTML tree, the contact sheet PDF, `Proxy Media/`, and
  the `…_copytrust_exif.csv`.
- **Was:** the CSV alone went to a second folder named `CopyTrust_Receipts` — the pre-2.7.7 name,
  left pinned in one line of the writer. A delivery carried two receipts folders and the one an
  operator opened was the one without the metadata.
- **Also check:** a folder an *older* build delivered into, which already has a
  `CopyTrust_Receipts`. A second copy must add to that one folder, not start a `Receipts` beside
  it. Both readings of "two receipts folders in one delivered folder" are now defects.

**G2 — Nothing is written at the root of a destination**
- **Do:** stage a destination as the **volume root** (`/Volumes/Copy A`, not a folder inside it)
  and run a normal card copy.
- **Expect:** `/Volumes/Copy A` gains the delivered folder and **nothing else**. No `Receipts` and
  no `CopyTrust_Receipts` at the top of the drive.
- **Was:** the session receipt `.txt` and the per-copy `.log` were written to the folder the
  operator picked rather than the folder the card landed in, so every job left a receipts folder at
  the root of every destination drive as well as the real one beside the footage.
- **Where they are instead:** beside the delivery, in the same `Receipts` folder as G1 — plus
  `~/Library/Application Support/CopyTrust/receipts/` as always, and the receipt export folder when
  one is set. A destination that received nothing this session gets nothing written to it.
- **Under enforcement:** the receipt follows the card into the project folder, not
  `destination + subfolder`, which stopped being the same place once placement could resolve a
  project deeper in the tree.

**G3 — A preset can say one destination archives to P5 and another makes proxies**
- **Do:** Preset ▸ Build… (or Edit…) and go to **What each destination is for**.
- **Expect:** every staged destination listed by volume and path, each with **Archive to P5** and
  **Create proxies**. Turning P5 on for one turns it off for the others — the copy allows exactly
  one archive source. A proxies-only destination is listed separately and takes neither.
- **Then:** save, load the preset on another Mac, and read the confirmation. It names which drive
  is the P5 source and which makes proxies before staging anything.
- **Was:** the preset always carried these, and the only place to set them was the destination row
  behind the wizard — where **Create proxies** is on for every destination added. A facility that
  archives from one drive and makes proxies on the other got proxies on both.
- **Note:** editing here writes the preset, not the job on the bench. The destinations in front of
  you keep their own settings until the preset is loaded.

**G4 — A preset carries the P5 server, so all an operator sets is the password**
- **Do:** set up P5 in Settings ▸ P5 Archive on one Mac, then Preset ▸ Build… ▸ **P5 archive
  server** and tick *Carry this Mac's P5 server settings in the preset*. Review, save.
- **Expect:** the step reads back server, port, API version, user, archive index, client and plan.
- **Then:** load the preset on a Mac with no P5 set up. All seven fields fill in; **Test
  Connection** fails only for the missing password. Enter it in Settings ▸ P5 Archive and it works.
- **Check the file:** open the saved `.json` in a text editor. The server is in it. **No password
  is, and there is no field that could hold one** — it stays in each operator's Keychain, filed
  under the `host:port|user` this preset fills in, which is what makes their saved password the
  one used.
- **Deliberately not carried:** *Archive verified copies to P5* and the deferred request. Those
  stay per-job, so loading a preset never starts submitting archive jobs on its own.

---

**G5 — The exported report covers the whole preset**
- **Do:** with destinations staged and P5 set up, Preset ▸ (your preset) ▸ **Save Report…** ▸ Rich
  Text. Do it again as CSV and as Markdown.
- **Expect:** as well as the naming decisions, three more sections — *Destinations this preset
  carries, and what each is for*, *P5 archive server*, and *Copy settings this preset also
  carries*. All three formats carry all three.
- **Read the P5 section:** it must name the server, port, user, index, client and plan, **and say
  plainly that the password is not carried**. Search all three files for `password` — every hit
  should be that sentence.
- **Read the destinations section:** which drive is the P5 source, which makes proxies, which
  receives proxies only. Volume-and-path, never this Mac's mount points.
- **Then:** compare the report against the wizard's review step. They are built from the same
  assembly of the preset, so they cannot disagree — if they do, that is the defect.

**G6 — The launch panel is five steps, and the detail is in Help**
- **Do:** launch build 8 for the first time.
- **Expect:** the panel opens headed *Start here — five steps, in this order* and lists them:
  newest build, load the preset, add the P5 password if you use P5, choose the sources, assign the
  project and Start. Not a changelog and not a test script.
- **Then:** Help ▸ **What's New** — a new topic carrying what changed in this build, what to test
  in it, and what is still worth testing from build 7. It should say the same things as section G
  above, and be reachable long after the panel has been dismissed.
- **Why:** the panel opens by itself with a card usually already in the reader. Loading the preset
  *after* staging cards is the mistake it exists to prevent, and a list of changes cannot prevent
  it.

**G7 — Build 9: the launch panel names the right menus, and points into the app**
- **Do:** launch build 9 and read the five steps.
- **Expect:** step 1 says **CopyTrust ▸ Check for Updates…** — the app menu, under About, which is
  where it is. The last line says **Help ▸ CopyTrust Help ▸ What's New**, naming the Help item that
  has to be opened first.
- **Then:** click **All release notes** at the bottom. It should open **CopyTrust Help on the
  What's New topic**, not a browser. Build 8 sent it to GitHub, which is no use on a facility
  network that cannot reach it.
- **And back:** from Help ▸ What's New, click *Open the What's New panel*. The panel should open.
  It did nothing before build 9 — two sheets cannot present at once, so the second was dropped.

**G8 — Build 9: Save Report… writes all four files at once**
- **Do:** Preset ▸ (your preset) ▸ **Save Report…** ▸ *All three, and the preset (.json) — into a
  folder*. Choose a folder name and save.
- **Expect:** the folder holds four files — the RTF, the CSV, the Markdown and a `.json` named for
  the preset — and Finder opens with all four selected.
- **Then:** copy that `.json` to another Mac and use **Preset ▸ Import a Preset…** on it. It must
  load: this is the file the app itself would save, not a description of one.
- **Check:** search the `.json` for `password`. There must be no hit. The P5 server is in it; the
  password is in the Keychain and cannot travel.

**G9 — Build 10: a preset can be locked in**

*For whoever deploys CopyTrust. Full setup in `COPYTRUST_MANAGED_PRESET_DEPLOYMENT.md`.*

- **Pin one locally**, which needs no MDM:
  ```
  defaults write com.copytrust.app CopyTrustEnforcedPresetName -string "House Card Ingest"
  ```
  Relaunch CopyTrust.
- **Expect:** the Preset button carries a **lock** and the preset's name. The menu opens with
  *"House Card Ingest" is enforced — pinned locally for testing*. Build, Edit, Import, Save,
  Update, Load, Rename, Delete and Duplicate are all gone. **Export** and **Save Report…** are
  still there.
- **The wording matters:** *pinned locally for testing* is what a `defaults write` must say. A
  configuration profile must say *managed by your organisation*. If you push a profile and it still
  says "pinned locally", the profile has not landed — that distinction is the point.
- **Change the convention without touching the profile.** With the app **still open**, replace that
  preset's `.json` in `/Users/Shared/CopyTrust/Presets` with an edited one. Within a second or two
  the new convention should be in force — check a card's resolved delivery path. No relaunch.
- **Pin a name that does not exist.** The menu should say so and name the folder to deploy it to,
  and nothing else should load in its place.
- **Try `seed`:** add `CopyTrustPresetEnforcementMode -string "seed"`. On a Mac that has already
  loaded a preset it should do nothing at all; the menu is unlocked and normal.
- **A typo enforces.** Set the mode to `enforced` — not a real value — and confirm it locks rather
  than silently doing nothing.
- **Undo:** `defaults delete com.copytrust.app CopyTrustEnforcedPresetName` and relaunch.
- **Known and deliberate:** individual settings are *not* locked. Change the verification level
  under an enforced preset — it changes, the modified dot appears, and it is put back at the next
  launch. That is the documented behaviour, not a defect.

**G10 — Build 11: the settings for the mode you are not in**
- **Do:** with **Card** mode active in the toolbar, open Settings ▸ **Folder Copy**. Uncheck two
  exclusion patterns and change the verification level.
- **Expect:** every control holds where you put it. Before build 11 they sprang straight back — the
  change was saved and the window simply never redrew.
- **Then:** switch the toolbar to Folder mode and reopen Settings ▸ Folder Copy. Your changes
  should be there.
- **And the other half:** go to Settings ▸ **Card Copy** and change an exclusion. Folder's must not
  move. The two modes have always been stored separately; the old behaviour only made it look
  otherwise.
- **Post-Copy too:** Settings ▸ Post-Copy, set its picker to the mode you are *not* in, and change
  the contact sheet split limit. It should hold, and the other mode's should not change. That tab
  had a workaround for this bug and now uses the same mechanism as the rest.
- **Not a defect:** Folder mode showing **Inline**. That is whatever your folder profile says.
  `Quick` is only the factory default for folder mode — check Settings ▸ Folder Copy ▸ Post-Copy
  Verification for what yours is actually set to, and the session log's `verificationLevel=` for
  what a copy ran at.

**G11 — Build 11: the Unit menu lists units, not keystrokes**
- **Do:** with a convention loaded, open a staged card's **Unit** menu.
- **Expect:** under **Used before**, whole units only. Any `S`, `So`, `Son` fragments an earlier
  build collected are cleared on this build's first launch.
- **Then type a new unit** the preset does not list — say `SOUND-B` — and **tab to Roll**. Stage
  another card and open its Unit menu: `SOUND-B` should be there. Pressing Return instead of
  tabbing must work the same way.
- **And check nothing is recorded early:** type `DR` and then delete it without leaving the field.
  `DR` must not appear in the menu.
- **Forget:** the menu has a **Forget** submenu listing the remembered ones. Removing one takes it
  out of the list.
- **Worth knowing:** the one-time cleanup drops any remembered unit that is a strict prefix of
  another, so a Mac that legitimately had both `Canon` and `Canon C300` will lose `Canon`. Type it
  once and it stays — the cleanup does not run again.

**G12 — Build 11: editing a convention from Settings keeps the destinations**
- **Do:** load a preset that carries destinations. **Settings ▸ Card Copy ▸ Edit Enforced
  Naming…**, go to *What each destination is for*.
- **Expect:** it says it was opened from Settings and cannot see the staged destinations, and lists
  the ones the preset already carries. It must **not** say "nothing is staged".
- **Save it, then check the preset still has them** — Preset ▸ Save Report… and read the
  destinations section, or open the `.json`. Before build 11 this save emptied them, and took the
  P5 and proxy roles with them.
- **And check it edited rather than duplicated:** the preset list should have the same number of
  presets as before, with the same name — not a second one beside it. (A **Shared** preset is
  read-only, so editing one from Settings still creates a new preset. That is by design; use
  Duplicate as My Preset in the Preset menu.)
- **From the main window** — Preset ▸ Build an Enforced Naming Preset… — the step still lists the
  staged destinations with their Archive to P5 and Create proxies choices, as in build 8.

**G13 — Build 11: the wizard warns as well as blocks**
- **Do:** in the wizard, set a folder template using `{location}` — say
  `{project}_{location}_{unit}_roll{roll}` — and leave *"Also ask where the card was shot"* **off**.
  Go to the review step.
- **Expect:** *"Worth checking before you save — none of these stop the preset working"*, naming the
  delivered folder name as using `{location}` while nothing asks for one. It must not block saving:
  an empty location drops the token cleanly and the convention still works.
- **Then turn locations on** and confirm the warning goes, and that a card row now shows a
  **Location** field beside Unit and Roll.
- **Also:** clear the units list with the unit policy on, and confirm the long-standing "no units"
  warning appears. It has been computed since the feature shipped and displayed nowhere until now.

**G14 — Build 12: launch, with a preset carrying destinations**

*Needs a preset carrying two destinations that take originals and one proxies-only.*

- **Do:** load it, quit, relaunch.
- **Expect:** all three staged before you touch anything. From build 11 and earlier only the very
  first launch staged them; every launch after restored the name and nothing else.
- **Then:** Preset menu ▸ **Stage This Preset's Destinations Again**. It should re-stage, and it
  must be present even under an enforced preset, where Load is not.
- **Unmount one footage drive and relaunch.** **One** prompt about it, not three. Check the session
  log: one `presetDestination staged` group, one `mountRequest`.
- **Now unmount only the proxies-only volume and relaunch.** You should **not** be asked whether you
  are off site — both drives that take originals are there. Staging still reports the share as
  unavailable, which is the right place for it.
- **Under an enforced preset, replace the .json while running.** It must still take effect within a
  second or two: the once-only guard is keyed on the preset's timestamp, so a redeployed preset is
  a new mark.

---

## Known limits — not defects

- **Individual manifests are read; an ASC MHL history is not.** CopyTrust verifies the entries a
  manifest names. It does not parse `ascmhl_chain.xml`, verify manifest C4 identifiers, or resolve
  multiple generations — so "the chain was checked" is not a claim this build makes (D9).
- **CopyTrust still writes MHL v1.1.** An incoming ASC MHL chain can be read here and not extended.
- **`xxh3`, `xxh128` and `c4` are parsed but not computed**, so entries using only those cannot be
  compared. They are counted and reported rather than skipped silently (D7).
- **Discovery looks in two places** — the source root and an `ascmhl/` folder at the source root.
  Never a recursive walk (D1). A manifest elsewhere can still be checked with MHL Verify or
  `mhl-tool verify`.
- **Nothing is written back to the incoming manifest.** CopyTrust reports; it does not append a
  verification generation.

---

## What to send back

1. The Source Provenance card for **B2**, screenshotted.
2. The `grep sourceManifest` output from **E2**.
3. `jq '.sourceEntries[].sourceManifestVerdicts'` from one receipt.
4. Anything marked **F**, with the session log folder.
