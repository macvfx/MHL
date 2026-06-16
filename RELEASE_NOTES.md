# Release Notes

One line per release, newest first. Detailed changes live in each app's own documentation
([MHL Verify changelog](MHL_VERIFY_CHANGELOG.md), per-app READMEs and user guides).

## Media Trust Tools suite (CopyTrust, Drop Verify, Folder Copy Compare, mhl-tool)

| Version | Date | Summary |
|---|---|---|
| **CopyTrust 2.5.4 / Drop Verify 2.5.3 (native HTML tree)** *(testing)* | 2026-06-15 | CopyTrust and Drop Verify: Project summary index, One HTML per top-level folder, and Entire project now use built-in file enumeration and no longer require the external `tree` command. Recursive output preserves the existing collapsible HTML format without waiting on `tree -J` child processes; the `tree` path is legacy diagnostics only. |
| **2.5.2 (Drop Verify docs update)** *(testing)* | 2026-06-15 | Drop Verify: output toggles are exact; disabled artifacts are skipped before work starts. MHL is the hash-producing artifact and controls session manifest creation. CSV/contact-sheet-only runs can avoid hashes, and HTML-tree-only runs can skip media scanning, metadata extraction, hashing, and session manifest creation. |
| **2.5.2** *(testing)* | 2026-06-13 | CopyTrust: fixes MHL verification reporting all files missing ("0 matched", "MHL file not found") on **sorted** copies — a delivery MHL now describes the sorted layout and every verify action targets it, while the original source MHL is kept in `CopyTrust_Receipts/`; a destination drop/reconnect no longer re-runs a sort that already completed (one-shot); new per-copy `PROVENANCE_*.json` records the settings used and the source→destination file mapping. **2.5.1 remains the stable release.** Known issues (Destination Sort only — trust chain unaffected): relay chains sort only the final destination; a disconnect *during* the sort can still re-run it over a partial tree — see the CopyTrust User Guide. |
| **2.5.1** *(stable)* | 2026-06-12 | ASC MHL v2.0 (Silverstack 9+) read/verify support in the shared CopyCore engine — fixes [#1](https://github.com/macvfx/MHL/issues/1); `ascmhl/` folder layouts; mid-file verification cancellation; mhl-tool version aligned |
| 2.5.0 | 2026-06-09/10 | CopyTrust Session Health Report: structured error classification, per-mismatch explanations, health verdicts in Session Summary, receipts, and logs; per-mode artifact settings |
| 2.4.9 | 2026-06-07 | Folder Copy Compare reference-folder (3-way) compare, saved profiles with folder watch, two-phase scan progress; CopyTrust HTML tree artifact; Drop Verify session history |
| 2.4.8 | 2026-06-06 | Drop Verify HTML directory tree output (ProjectToHTML) with in-app Drop Verify Help; exclusion verification tests; version alignment; Sentry scoped to CopyTrust only |
| 2.4.1 (7) | 2026-05-01 | Copy progress: smallest-first ordering, within-file byte progress; NAS/SMB copy hang fixes; Check All Hashes; Clean Windows Files; Check for Updates in all apps |
| 2.3 | 2026-04-25/29 | Subfolder Check repair workflows, guided symlink recovery, P5 stub cleanup |

## MHL Verify

| Version | Date | Summary |
|---|---|---|
| **2.5.1 (1)** | 2026-06-12 | ASC MHL v2.0 support via the shared CopyCore engine (fixes [#1](https://github.com/macvfx/MHL/issues/1)) + new **Verify** action that re-hashes files against the MHL; requires macOS 14 |
| 2.4.1 (7) | 2026-05-02 | Check for Updates; version aligned with the suite |
| 0.7 (2) | 2026-04-30 | Reader scroll fix; Editor-role handler registration for both MHL UTIs |
| 0.6 | 2026-03-10 | Initial reader, compare, export, and Handlers utility |

## mhl-tool (CLI)

| Version | Date | Summary |
|---|---|---|
| **2.5.1** | 2026-06-12 | Verifies ASC MHL v2.0 manifests (auto-detects `ascmhl/` roots); version aligned with the suite |
| 1.0.0 | 2026-03 | Initial release: create/verify MHL v1.1, media-only or all-files, JSON output, signed pkg |
