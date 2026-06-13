# Release Notes

One line per release, newest first. Detailed changes live in each app's own documentation
([MHL Verify changelog](MHL_VERIFY_CHANGELOG.md), per-app READMEs and user guides).

## Media Trust Tools suite (CopyTrust, Drop Verify, Folder Copy Compare, mhl-tool)

| Version | Date | Summary |
|---|---|---|
| **2.5.1** | 2026-06-12 | ASC MHL v2.0 (Silverstack 9+) read/verify support in the shared CopyCore engine — fixes [#1](https://github.com/macvfx/MHL/issues/1); `ascmhl/` folder layouts; mid-file verification cancellation; mhl-tool version aligned |
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
