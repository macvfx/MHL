# Media Trust Tools 2.7.8.1 Build 8 — BETA

**Released:** 2026-08-29 · CopyTrust · Drop Verify · Folder Copy Compare
**Short notes:** [the release page](https://github.com/macvfx/MHL/releases/tag/2.7.8.1%2B8) ·
**What to test:** [TEST_NOTES_v2.7.8.md](TEST_NOTES_v2.7.8.md) — section G is this build

> **This is a beta.** Run it on media you can afford to lose, and keep a separate, independently
> verified backup made by **other software** — Archiware P5 or equivalent. This is free software
> from GitHub: no guarantees, no warranty, no liability. If it matters, prove it twice with two
> different tools.

---

# Build 8 — where evidence lands, and what a preset can say

Four findings from a field pass on build 7. Two are placement faults — evidence written somewhere
other than where the person looking for it goes. Two are preset gaps, where CopyTrust could already
do the thing and there was no way to ask for it.

## One receipts folder per delivery, holding everything

2.7.7 renamed a delivery's evidence folder to **`Receipts`**. The EXIF metadata CSV was still
writing to the old `CopyTrust_Receipts`, so a delivery came out with **two** receipts folders: one
holding the receipt, the manifest, the provenance record, the HTML tree, the contact sheet and the
proxy evidence — and one holding a single CSV. The folder you open looking for the metadata export
was the one without it in.

A folder an older build delivered into keeps the name it already has, and everything joins that one
folder rather than starting a second beside it.

## Nothing is written at the top of a destination drive

The session receipt and the per-copy log were written to the folder staged in the Destinations
panel, which is usually a volume root, while every other artifact went into the delivered folder.
So every job left a receipts folder at the root of every destination drive as well as the real one
beside the footage.

They now follow the card into the folder it landed in — including under enforced naming, where the
card lands inside its project folder rather than one level down from the drive. A destination that
received nothing this session has nothing written to it. The copies in
`~/Library/Application Support/CopyTrust` and in the receipt export folder are unchanged.

## A preset says what each destination is *for*

**Preset ▸ Build…** (or **Edit…**) has a new step listing every staged destination with **Archive
to P5** and **Create proxies**. One drive can be the P5 archive source while another makes the
proxies.

CopyTrust always carried these in a preset; the only place to set them was the destination row, and
**Create proxies is on by default for every destination you add**. A facility that archives from one
drive and makes proxies on the other shipped a preset that made proxies on both, and found out by
watching an encode run on a drive that was never meant to make any.

Loading a preset now names which drive archives and which makes proxies before it stages anything.

## A preset carries the P5 server, so all that is left is the password

Address, port, API version, user, archive index, client and plan travel with the preset. Load it on
another Mac and the only thing to fill in is the password.

**The password is never in a preset file, and there is no field that could hold one.** It stays in
each operator's own Keychain, entered once in **Settings ▸ P5 Archive** and filed under the server
and user the preset fills in — which is what makes their saved password the one that gets used.

Whether a job archives to P5 is still a per-job switch. Loading a preset never turns it on.

## The exported report describes the whole preset

**Preset ▸ Save Report…** wrote out the naming decisions and nothing else, while the same file also
decides which drive archives, which makes proxies, what verification runs and what is excluded. It
now carries three more sections in all three formats: the destinations and what each is for, the P5
server with the explicit statement that the password is not carried, and every copy setting the
preset applies when it loads.

## The panel that opens on launch is the order of work

It has been a list of changes and then a test script, and both were the wrong thing for the moment
it appears in — you have just launched the app, usually with a card already in the reader. It now
carries the five steps that get a copy started correctly, in the order they have to happen: newest
build, load the preset, add the P5 password if you use P5, choose the sources, assign the project
and Start.

What changed and what to test moved to **Help ▸ What's New**, where it stays reachable.

## Why the version has a fourth number

Munki compares an app's version string and ignores its build number, so every build of 2.7.8 looked
to it like the same release and a managed Mac was never offered the newer one. **2.7.8.1** gives it
something to compare. All three apps move together — build 8 changes code all three share.

## Downloads

| File | Contents |
|---|---|
| `MediaTrustTools-2.7.8.1-b8-BETA.dmg` | All three apps |
| `CopyTrust.dmg` | CopyTrust only |
| `Drop.Verify.dmg` | Drop Verify only |
| `FolderCopyCompare.dmg` | Folder Copy Compare only |

All apps are universal (arm64 + x86_64), signed with a Developer ID, notarized and stapled.
**Requires macOS 14 (Sonoma) or later.** `mhl-tool` 2.7.7 is a separate download.

---

# Build 7 — CopyTrust reads the manifest a card arrived with

*Everything below shipped in 2.7.8 build 7 and is still in this build.*

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
| `MediaTrustTools-2.7.8-b7-BETA.dmg` | All three apps (build 7's download) |
| `CopyTrust.dmg` | CopyTrust only |
| `Drop.Verify.dmg` | Drop Verify only |
| `FolderCopyCompare.dmg` | Folder Copy Compare only |

All apps are universal (arm64 + x86_64), signed with a Developer ID, notarized and stapled.
**Requires macOS 14 (Sonoma) or later.** `mhl-tool` 2.7.7 is a separate download.
