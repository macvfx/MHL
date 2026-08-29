# Media Trust Tools 2.7.8 Build 7 — BETA

**Released:** 2026-08-28 · CopyTrust · Drop Verify · Folder Copy Compare
**Short notes:** [the release page](https://github.com/macvfx/MHL/releases/tag/2.7.8%2B7) ·
**What to test:** [TEST_NOTES_v2.7.8.md](TEST_NOTES_v2.7.8.md)

> **This is a beta.** Run it on media you can afford to lose, and keep a separate, independently
> verified backup made by **other software** — Archiware P5 or equivalent. This is free software
> from GitHub: no guarantees, no warranty, no liability. If it matters, prove it twice with two
> different tools.

---

## CopyTrust checks the manifest a card arrived with

A card shot off site is usually offloaded by somebody else — OffShoot, Silverstack, ShotPut Pro —
and reaches the facility as a folder with its own MHL beside it. CopyTrust ingested that folder and
**never looked at the manifest**.

So a file that was already corrupt *when it arrived* was copied and verified without complaint:
CopyTrust hashes what it reads and what it writes, and those agree — because it faithfully copied a
broken file. The receipt said clean, proxies were built from bad footage, and the shuttle drive was
wiped. The damage surfaced weeks later in an edit, with nothing left to say whether it arrived that
way.

## New

**A staged card says what it came with, and who wrote it** — before anything is copied. It says so
either way: an absent manifest and one nobody looked for are otherwise indistinguishable.

**The check happens during the copy, at no extra cost.** It reuses the hashes the copy already
takes off the source as it reads it. It needs **Inline or Full** verification — under Quick the row
says the check will not happen, rather than promising one it cannot perform.

**The result is kept apart from CopyTrust's own verification**, in a Source Provenance card above
Session Health. They are different claims by different authors: a card that arrived damaged copies
and verifies perfectly, and only the arrival check can say otherwise.

**A mismatch never blocks a copy.** Damaged footage is still the only footage, and the drive it came
on is usually about to be wiped.

**A manifest CopyTrust wrote gives no arrival verdict.** Checking footage against our own record only
confirms it still matches what we recorded. Authorship is read from inside the manifest rather than
from its filename, so a rename does not change the answer.

**Green means everything was checked.** A partly-checked manifest is amber and says how much — one
matching entry among fifty unreadable ones is not a card that matched its manifest. A manifest that
will not parse is reported as unreadable, never as absent.

## Changed

- Each finished card reports **copied & verified** at roughly twice the size of anything else on
  screen, above the artifact rows — what an operator needs on walking back to the machine.
- Artifacts fold away under each card, closed by default. A closed row still says if one failed.
- A convention built in the wizard now **creates the project folder** for a new job instead of
  falling back to a dated ingest folder. Existing presets keep whatever they were saved with —
  **Preset ▸ Edit… ▸ "Let operators create a project folder that does not exist yet"**.
- The in-app Help window keeps one size instead of resizing to whichever topic is showing.

## Fixed

- Drop Verify and Folder Copy Compare no longer scan the `Receipts` folder they write into. A
  second Drop Verify pass was hashing its own prior output, and a deep compare of a clean delivery
  reported that delivery's evidence as differences.
- A partly-checked manifest no longer shows a green seal.
- A manifest that cannot be parsed is reported as unreadable rather than as absent.
- The staging row only promises the arrival check when the verification level can perform it.
- A resumed copy reports the same source verdict as an uninterrupted one; previously its resumed
  files counted as never read, and a fully resumed copy produced no verdict at all.
- In-app Help no longer says the footage is not checked against an incoming manifest, which sent
  operators to run a separate verification they no longer need.

## Known limits

- **Individual manifests are read; an ASC MHL *history* is not.** `ascmhl_chain.xml`, manifest C4
  identifiers and multiple generations are not parsed — "the chain was checked" is **not** a claim
  this build makes.
- CopyTrust still **writes MHL v1.1**, so another vendor's chain can be read here but not extended.
- `xxh3`, `xxh128` and `c4` are parsed but not computed. Entries using them are counted and
  reported, never skipped silently.
- Discovery looks in two places: the source root, and an `ascmhl/` folder at the source root. Never
  a recursive walk. A manifest elsewhere can still be checked with MHL Verify or `mhl-tool verify`.

## Downloads

| File | Contents |
|---|---|
| `MediaTrustTools-2.7.8-b7-BETA.dmg` | All three apps |
| `CopyTrust.dmg` | CopyTrust only |
| `Drop.Verify.dmg` | Drop Verify only |
| `FolderCopyCompare.dmg` | Folder Copy Compare only |

All apps are universal (arm64 + x86_64), signed with a Developer ID, notarized and stapled.
**Requires macOS 14 (Sonoma) or later.** `mhl-tool` 2.7.7 is a separate download.
