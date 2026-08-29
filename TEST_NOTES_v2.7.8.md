# CopyTrust 2.7.8 — Test Notes

**Build under test:** 2.7.8 Build 7 · **Previous release:** 2.7.7 Build 2
**Written:** 2026-08-28

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
- Version in About (must read **2.7.8**):
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
