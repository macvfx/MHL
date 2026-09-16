# CopyTrust 2.7.0 (Build 12) — Workflow, P5, and Proxy Correctness Testing Notes

Date: 2026-08-01
Status: Public prerelease for controlled testing
App: CopyTrust

## Beta focus

Build 12 probes each delivered original before proxy encoding. Test display
rotation, scaled displayed dimensions, full/limited color range, and receipt
reporting of encoded/display frames, rotation, primaries, transfer, and matrix.
Missing source color fields must remain N/A rather than claimed matches.
For a sorted destination, confirm the provenance JSON reports sorting enabled
and records the selected folder mode and categories.

This build adds an optional Archiware P5 post-copy action. It carries the
capture-time xxHash64 and bounded media metadata into GUI-visible/searchable P5
archive-index fields while preserving MHL, receipts, provenance, contact
sheets, EXIF CSV, and proxy evidence as supporting files.

Build 11 adds a visual workflow review with one destination card per active or
queued destination. Direct, fan-out, relay-chain, and current-plus-queued jobs
have distinct top-level flows. Every card states the source/relay context,
path, queue state, verification, sorting, proxy selection, and P5 selection.

Relay authoring also writes an immutable, password-free workflow plan with the
ordered destinations, queued-session and sequence IDs, dependency links,
captured settings, and per-destination P5/proxy choices. Every leg's session
and exported per-copy logs link that plan and contain structured workflow
setup/source/destination records. The same plan is exported beside each leg's
delivered receipts.

Build 10 recognizes P5 selections across the complete queued relay chain and
adds an independent **Create proxies** checkbox to each destination. Proxy and
P5 routing can target the same destination, different destinations, or both
destinations. Saved presets and queued jobs preserve these choices, while older
saved data defaults to proxy-enabled.

Build 10 includes all Build 9, Build 8, and Build 7 fixes. Build 9 corrects proxy result reporting: a successful encode is no longer failed solely because the original reports an unspecified audio language as `und` while the proxy omits that tag. Proxy metadata warnings remain visible but separate from encode failures, and Retry visibly resets the row to Running before its new result. Build 7 also hardens mixed queued work: Start Queue is a run-to-completion
command, queued jobs retain their artifact and non-secret P5 settings, and the
queue distinguishes copy completion from background artifact/P5 completion.
It also repairs the Build 6 field-test crash that occurred when a completed P5
job closed the session while a destination row still had a SwiftUI binding.

Build 8 routes Sentry events and dSYM uploads to the recreated `apple-macos`
project and adds a Debug-only privacy-safe integration test event with a
visible event ID.

Use expendable fixtures and a non-deleting P5 plan. Do not treat a green
CopyTrust copy result as P5 proof: confirm the request JSON, P5 job, archived
paths, and index metadata in P5 Web.

## Acceptance matrix

| Test | Expected result |
|---|---|
| Direct workflow review | Top flow shows one source to one destination; the destination card matches the configured path and choices |
| Fan-out workflow review | Top flow shows source(s) to destinations and every destination has a separate card |
| Relay workflow review | Top flow shows the original source followed by every ordered relay stop |
| Current plus queue review | Current source/destination and queued-job count are explicit; queued destinations have cards |
| Destination card accuracy | Source/relay context, path, queue state, verification, sort, proxy, and P5 fields match the authored job |
| Immutable relay plan | One password-free workflow-plan JSON records ordered destinations, queue/sequence/dependency IDs, settings, and P5/proxy choices; different contents cannot overwrite it |
| Workflow logs | Session and exported per-copy logs contain `workflow setup`, `workflow source`, and one `workflow destination` record per displayed destination, with a plan link for relays |
| Workflow plan export | The same plan is copied beside every delivered relay leg's receipts |
| Relay sequence isolation | A second relay using the same paths receives a new sequence identity and does not reuse the older relay's queue rows |
| Test Connection & Load | Live indexes, clients, and plans populate |
| Password storage | Password is in Keychain, never request JSON/preferences |
| Source-deleting plan | Visibly blocked from automatic submission |
| Full/Inline copy | Complete verified hashes; archive request can submit |
| Quick/copy-only | Deferred `needs_hash_verification`; no auto-submit |
| P5 client path mismatch | Actionable failure/deferred state, not false success |
| Metadata keys | `CT_*` fields are visible and searchable in P5 Web |
| Supporting evidence | Existing MHL/receipts/artifacts are included |
| P5 offline | Verified copy remains successful; request records retry details |
| Restore | P5 restores expected files; MHL verification matches every hash |
| Mixed queue | Start Queue completes Card and Folder jobs even if one captured profile has Auto Advance off |
| Per-job settings | Changing the next queued profile does not alter the previous job's running artifacts or P5 target |
| Multi-destination outputs | Artifacts/proxies exist on every eligible destination; P5 archives only the destination with **Archive to P5** checked |
| P5 destination selector | Checking a second destination clears the first; queued jobs retain their selected destination |
| Relay-chain P5 pre-check | Selecting P5 on any relay stop is recognized and named; no false no-destination warning appears |
| Per-destination proxies | Only destinations with **Create proxies** checked receive proxy media and proxy evidence |
| Independent proxy/P5 routing | Proxy and P5 checkboxes can target the same or different relay destinations |
| Background status | Queue rows progress from Copy complete to Artifacts/P5 running and then Fully complete or needs attention |
| Independent artifact status | Each completed PDF/CSV/tree row changes from its own spinner to a checkmark while a later proxy is still running; failed and no-work rows also stop independently |
| Proxy result | Every successful encode completes; equivalent `und`/omitted language metadata does not create a false failure |
| Proxy retry | Failed row changes to Running immediately, then shows the new complete or failed result |
| Sentry privacy configuration | Automated test confirms file/network tracing, failed-request capture, performance profiling, sessions, logs, and breadcrumbs are disabled |
| Sentry event filter | Confirms the documented privacy contract: a synthetic event containing a media path, media filename, P5 URL, header, client tag, and user/server value reaches the filter with all path and private-information fields removed while minimal stack symbolication data remains |
| Recreated Sentry project | Debug/Release configuration targets project slug `apple-macos`; DSN project ID ends in `4511827815235664` |
| Sentry live integration | Debug Settings → Test sends an event identified as `CopyTrustSentryIntegrationTest`; the displayed event ID appears in Sentry with the value redacted and no private fields |
| P5 polling | Routine REST polls do not flood the visible log; periodic summaries and terminal state remain visible |
| Session teardown | Closing immediately after P5 completion removes destination rows without crashing |
| Metadata diagnostics | Log contains `stage=metadata-values` with populated counts for every CT key and no metadata values |

## Deferred submission

Dry-run:

```bash
scripts/copytrust-p5-archive.py \
  "/path/to/COPYTRUST_P5_ARCHIVE_REQUEST_*.json"
```

Explicit submission after review:

```bash
scripts/copytrust-p5-archive.py --submit \
  "/path/to/COPYTRUST_P5_ARCHIVE_REQUEST_*.json"
```

The helper obtains the password interactively or from `P5_PASSWORD`; the
request file itself must remain password-free.
