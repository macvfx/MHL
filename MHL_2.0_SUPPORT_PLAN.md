# MHL 2.0 Support Plan — Media Trust Tools v2.5.1

**Status:** Proposed
**Date:** 2026-06-12
**Tracking issue:** [macvfx/MHL#1](https://github.com/macvfx/MHL/issues/1) — *MHL Verify: Silverstack MHL v2.0 — "Zero bytes" display bug + no verify action available*
**Affected products:** MHL Verify (this repo), CopyCore, mhl-tool, CopyTrust, DropVerify, Folder Copy Compare (`Folder Copy Compare` repo)
**Target release:** v2.5.1 across the suite, driven by a CopyCore update

---

## 1. The issue

A user opened an MHL created by **Pomfort Silverstack XT** using the ASC MHL
v2.0 hashlist format (`<hashlist version="2.0">`, xxh64 hashes with
`action="original"`). Two symptoms were reported:

1. **MHL Verify v2.4.1** opens the file but shows **"Total Size: Zero bytes"**
   even though every `<path>` element carries a correct `size` attribute.
2. **No verify action exists** anywhere in the suite for this file — MHL
   Verify is reader-only, and `mhl-tool verify` rejects the same file with
   **"MHL file contains no hash entries."**

Net effect: a valid MHL with 31 files and 31 valid xxh64 hashes cannot be
used to verify a backup with any Media Trust Tools app. Cross-tool
interoperability with the most common Silverstack workflow is broken.

## 2. Root cause

The suite contains **two independent MHL parsers**, both written against the
MHL **v1.x element layout only**:

| Parser | Location | Used by |
|---|---|---|
| `MHLDocument.ParserDelegate` | `Sources/MHLDocument.swift` (this repo) | MHL Verify app + Quick Look extension |
| `MHLReader` / `MHLParserDelegate` | `CopyCore/Sources/CopyCore/MHLReader.swift` | `mhl-tool verify`, CopyTrust re-verify (`IngestMHLVerifier` via `IngestEngine`), Folder Copy Compare "Verify MHL" |

ASC MHL v2.0 moved every per-file field relative to v1.x:

| Data | MHL v1.x (what both parsers expect) | ASC MHL v2.0 (what Silverstack writes) |
|---|---|---|
| File path | `<file>path</file>` element | Text content of `<path>` |
| Size | `<size>123</size>` element | `size` **attribute** on `<path>` |
| Mod date | `<lastmodificationdate>` element | `lastmodificationdate` **attribute** on `<path>` |
| Hash | `<xxhash64>` / `<xxhash64be>` elements | `<xxh64>` element (also `xxh3`, `xxh128`, `md5`, `sha1`, `c4`) |
| Hash date | `<hashdate>` element | `hashdate` **attribute** on the hash element |
| Action | — | `action` attribute (`original` / `verified` / `failed`) |

Both parsers route the v2.0 element names through `default: break`, so path,
size, and hashes are all silently dropped. The two parsers then diverge in
symptom only:

- **MHL Verify** appends the empty entry anyway → *"31 files, Zero bytes,
  no hashes"* (issue symptom 1).
- **CopyCore** discards entries with an empty file path or no usable hash
  (`MHLReader.swift:291,303`) → empty manifest → `MHLError.noEntries` →
  *"MHL file contains no hash entries"* (issue symptom 2, verbatim).

Neither parser rejects `version="2.0"` outright — the version string is
stored but never checked. The failure is purely structural.

### Blast radius per tool (current behaviour on a v2.0 MHL)

| Tool | Entry point | Behaviour today |
|---|---|---|
| MHL Verify | `MHLDocument.parse` | Opens; entry count right, sizes zero, hashes missing |
| MHL Verify QL extension | same parser | Same wrong preview |
| `mhl-tool verify` | `VerifyCommand` → `IngestMHLVerifier` | Error per file, exit code 1 |
| CopyTrust re-verify | `SplitModeSessionManager` → `IngestEngine.reverifyDestinations` | MHL lands in `failedMHLs`; an all-Silverstack destination reports the misleading *"No readable MHL"* |
| Folder Copy Compare | `ContentView.verifyMHL()` | Alert: *"Failed to parse MHL: MHL file contains no hash entries"* |
| DropVerify / CopyTrust ingest | `MHLWriter` (write-only) | Unaffected — they only write v1.1 |

## 3. Two implementation traps specific to ASC MHL v2.0

These must be handled or the fix is worse than the bug:

**Trap 1 — xxHash endianness mapping.** ASC MHL v2.0 `<xxh64>` carries the
*canonical* xxhsum-style digest (64-bit value printed MSB-first). In
CopyCore's vocabulary that is `XXHasher.HashResult.xxhash64` (the `%016lx`
form — the field's "little-endian/native" doc comment notwithstanding;
`xxhash64be` is the byte-swapped string, per the test vector
`0x7841a47c6e732640 → "4026736e7ca44178"`). Therefore v2.0 `<xxh64>` must map
to `Entry.xxhash64`, **not** `Entry.xxhash64be`. Mapping it backwards makes
every file verify as **mismatched** — a false corruption report, strictly
worse than failing to parse. The mapping must be pinned by a test against a
real Silverstack file plus `xxhsum` output.

**Trap 2 — root resolution.** ASC-MHL files conventionally live in an
`ascmhl/` subfolder with paths relative to that folder's **parent**.
`IngestMHLVerifier` resolves entries relative to the MHL's own directory, and
`VerifyCommand.inferRoot` only recognises `_Receipts` / `Receipts` patterns.
Without an `ascmhl` rule, every file resolves one level too deep and reports
*missing*.

## 4. Proposed fixes, ranked

Ranking criteria, in order: **(a) usefulness** — does it let the suite verify
MHLs created by other apps (the core interop ask)? **(b) difficulty** of code
implementation. **(c) impact on already-created MHL files** — none of the
read-side fixes touch existing files; only F8 carries write-side risk.

| # | Fix | Where | Usefulness | Difficulty | Impact on existing MHLs |
|---|---|---|---|---|---|
| F1 | Dual-format parsing (v1.0/1.1 **and** v2.0) in `MHLReader` | CopyCore | **Critical** — single change unblocks `mhl-tool`, CopyTrust re-verify, Folder Copy Compare | Low-Medium (~100 lines, one delegate) | None (read-only) |
| F2 | Correct `xxh64` → `Entry.xxhash64` canonical mapping + capture `action`, skip `action="failed"` entries | CopyCore | **Critical** — wrong mapping = false mismatches | Low (part of F1, but needs a pinned test) | None |
| F3 | `ascmhl/` root inference in `VerifyCommand.inferRoot` and `IngestMHLVerifier` | MHLToolPackage + CopyCore | High — without it v2.0 files parse but report all-missing | Low (a few lines + tests) | None |
| F4 | MHL Verify adopts CopyCore as SPM dependency, deleting its duplicated parser | This repo | High — fixes "Zero bytes" and ends the two-parser drift permanently | Medium (cross-repo packaging; see §5) | None |
| F5 | Add a **Verify** action to MHL Verify using `IngestMHLVerifier` + `XXHasher` (folder picker, progress, results sheet) | This repo | High — directly answers issue symptom 2 | Medium (UI + security-scoped bookmarks; engine comes free with F4) | None |
| F6 | Renderer/exports show all parsed hash algorithms + `action` provenance (HTML preview, markdown, QL) | This repo | Medium — display correctness for v2.0 files | Low | None |
| F7 | Clear unsupported-version diagnostics: if a future hashlist version parses to zero entries, report *"MHL version X.Y not supported"* instead of *"no hash entries"* / *"No readable MHL"* | CopyCore | Medium — turns silent failure into actionable error for v3.0+ | Trivial | None |
| F8 | `xxh3` / `xxh128` support in `XXHasher` (newer Silverstack defaults) | CopyCore | Medium — only needed when users switch Silverstack off xxh64 | Medium-High (new algorithm impl or dependency) | None |
| F9 | *Write* ASC MHL v2.0 (`MHLWriter`, `ascmhl/` chain file, generations) | CopyCore | Low for this issue — nothing in the suite needs to emit v2.0 yet | High (chain-of-custody spec, signing, generations) | **Yes if default changes** — keep v1.1 the default, v2.0 strictly opt-in; defer to v2.6 |

**v2.5.1 scope: F1–F7.** F8 and F9 get their own tracking issues.

### F1 sketch (CopyCore `MHLParserDelegate`)

```swift
// didStartElement — normalise name first (lowercase, strip namespace prefix,
// since ASC MHL may declare xmlns="urn:ASC:MHL:v2.0")
case "path":                       // v2.0: metadata lives in attributes
    guard inHash else { break }
    hashSize    = Int64(attributes["size"] ?? "") ?? 0
    hashLastMod = isoFormatter.date(from: attributes["lastmodificationdate"] ?? "")
case "xxh64", "md5", "sha1", "sha256", "xxh3", "xxh128", "c4":
    guard inHash else { break }
    currentHashAction = attributes["action"]      // original | verified | failed
    if let d = attributes["hashdate"] { hashDate = isoFormatterFractional.date(from: d) ?? hashDate }

// didEndElement
case "path":  hashFile = trimmed                  // v2.0: file path is element text
case "xxh64": if currentHashAction != "failed" { hashXXH64 = trimmed }  // canonical form — Trap 1
```

v1.x element cases remain untouched, so the same delegate handles both
formats with no version switch. Note the v2.0 `hashdate` carries fractional
seconds (`2026-04-09T13:00:18.472344+02:00`) — the ISO formatter needs
`.withFractionalSeconds` fallback.

## 5. Architecture: one MHL engine, tracked in one place

Today a parser bug must be found and fixed twice, and (as this issue proved)
the two copies fail in different ways, which doubles support cost. Proposal:

1. **Extract CopyCore into its own repository** (or promote it to the
   canonical shared package within the Folder Copy Compare repo) with
   **semantic version tags** (`copycore-2.5.1`). It already builds as a
   standalone SPM package with its own test suite.
2. **All five consumers depend on it via SPM**: CopyTrust, DropVerify,
   Folder Copy Compare, mhl-tool, and — new in 2.5.1 — **MHL Verify**.
   MHL Verify deletes `MHLDocument.ParserDelegate` and maps
   `MHLReader.MHLManifest` into its existing `MHLDocument` view model
   (the Quick Look extension included).
3. **mhl-tool ships as the suite's reference CLI for MHL Verify**: same
   parse + verify code paths, so "works in the CLI" and "works in the app"
   can never diverge. Optionally bundle the `mhl-tool` binary inside MHL
   Verify.app/Contents/MacOS for a one-download install.
4. **Shared fixture corpus** in CopyCore tests: real MHLs from CopyTrust,
   DropVerify, Silverstack v1.1, Silverstack ASC v2.0 (the anonymised file
   from issue #1), Hedge OffShoot, YoYotta, ShotPut Pro. Every consumer CI
   run exercises the same corpus.
5. **Lockstep versioning**: suite version == CopyCore version. A CopyCore
   change bumps every app together (the v2.4.1 "align version with MHL
   suite" commit already established this convention). One CHANGELOG entry
   per behaviour change, referenced by all apps.

This makes every future format change (v3.0, new hash algorithms) a
single-PR, single-review, all-apps event.

## 6. Compatibility / migration

- **Existing MHL files are untouched.** F1–F7 are read-side only. v1.0 and
  v1.1 files produced by CopyTrust, DropVerify, OffShoot, YoYotta, ShotPut,
  and Silverstack continue to parse through the unchanged v1.x code path —
  guarded by the existing `MHLRoundTripTests`.
- **Output format does not change in 2.5.1.** `MHLWriter` keeps emitting
  v1.1, so downstream consumers of suite-generated MHLs see zero difference.
- **No API breakage for consumers**: `MHLReader.Entry` gains optional fields
  (`action`, plus future `xxh3`/`xxh128` slots); all existing fields keep
  their meaning.

## 7. Test plan

1. **Endianness pin (Trap 1):** fixture file + `XXHasher` round-trip
   asserting the parsed v2.0 `xxh64` equals `XXHasher.hashFile(...).xxhash64`
   and verification passes against `xxhsum` reference output.
2. **Format matrix:** parse fixtures for v1.0, v1.1, v2.0 (with and without
   `xmlns`), asserting entry count, per-entry size, total size, hash kinds.
3. **Root inference (Trap 2):** `ascmhl/` layout fixture verifying files
   resolve against the parent directory in both `mhl-tool` and
   `IngestMHLVerifier`.
4. **Regression:** full existing `MHLRoundTripTests` + `XXHasherTests`
   unchanged and green.
5. **End-to-end:** `mhl-tool verify` against a real Silverstack ASC v2.0
   card backup exits 0; MHL Verify displays correct totals and completes a
   Verify run on the same folder.

## 8. Suggested rollout

| Step | Deliverable |
|---|---|
| 1 | CopyCore 2.5.1: F1, F2, F3, F7 + test plan items 1–4 |
| 2 | mhl-tool 2.5.1: rebuild against CopyCore 2.5.1 (F3 CLI side) |
| 3 | MHL Verify 2.5.1: F4 (CopyCore adoption), F5 (Verify UI), F6 (renderers) |
| 4 | CopyTrust / DropVerify / Folder Copy Compare 2.5.1: dependency bump, re-verify messaging picks up F7 |
| 5 | Close issue #1 with the Silverstack fixture verifying end-to-end; open follow-up issues for F8 (xxh3/xxh128) and F9 (ASC MHL writing, v2.6) |
