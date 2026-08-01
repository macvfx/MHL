# CopyTrust 2.7.0 (Build 11) — Visual Workflow Review and Relay Evidence Beta

Build 11 makes the complete job visible and auditable before files move. The
pre-copy review begins with a visual flow for direct, fan-out, relay-chain, or
current-plus-queued work. It then shows one card per destination with its source
or relay stop, path, queue state, verification, sorting, **Create proxies**, and
**Archive to P5** choices.

When a relay is queued, CopyTrust now writes an immutable, password-free
`COPYTRUST_WORKFLOW_PLAN_<sequence-id>.json`. It preserves ordered destinations,
queued-session and sequence IDs, dependency links, captured settings, and every
destination's P5/proxy selections. Each relay leg links to the plan in its
session and exported per-copy logs, and copies the plan beside the delivered
receipts. Structured workflow log lines also record the overall job type,
sources, destinations, active queue item, relay steps, and explicit choices.

Build 11 also prevents a newly authored relay from reusing matching queue rows
from an older relay sequence.

Build 10's relay-wide P5 pre-check and independent per-destination proxy routing
remain included. A P5 selection on a later relay stop is recognized and named,
and proxies and P5 can target the same destination, different destinations, all
eligible destinations, or neither. P5 remains single-select.

CopyTrust can archive a hash-verified destination directly to Archiware P5
after the copy trust chain and enabled post-copy actions finish.

Build 9 corrects a proxy-reporting issue found during a successful real-world
copy, artifact, proxy, and P5 archive test. All 20 proxies encoded successfully,
but 14 were falsely shown as failed because the original MP4 reported an
unspecified audio language as `und` while the MOV proxy omitted the language
tag. Those equivalent values now compare correctly. Genuine metadata warnings
remain visible without being counted as encoding failures, and Retry visibly
transitions from Running to the new result.

Build 9 includes all Build 8 and Build 7 P5 and queue fixes. Build 7 keeps the copy queue moving while those post-copy actions run, captures
each queued job's artifact and P5 choices, and shows copy completion separately
from artifact and P5 completion.

It also fixes the field-test crash seen immediately after a successful P5 job:
destination rows now survive session teardown safely. Routine P5 job polls are
suppressed from the visible REST log while periodic progress and terminal
success/failure remain visible. A value-free CT metadata coverage line makes
missing source metadata diagnosable without exposing file metadata values.

Build 8 reconnects diagnostics and dSYM uploads to the recreated Sentry
project. Debug builds add a privacy-safe synthetic test-event button under
Settings → Test. It displays an event ID for lookup, passes through the normal
on-device privacy filter, and does not force a crash.

This is a **public prerelease for controlled testing**. Use expendable media and
a non-deleting archive plan until the workflow has passed your site acceptance
tests.

## What to test

- Prepare direct, fan-out, relay, and mixed queued jobs. Confirm the top-level
  flow names the correct job type and every destination has its own card.
- For each destination card, compare the displayed source/relay step, path,
  queue state, verification, sorting, proxy choice, and P5 choice with the
  setup screen before continuing.
- Queue a relay with proxies on the first destination and P5 on the second.
  Confirm the immutable workflow-plan JSON preserves that exact order,
  dependency, and selection split.
- Confirm each relay leg's session and exported per-copy logs contain
  `workflow setup`, `workflow source`, and `workflow destination` records and
  link to the same sequence workflow plan.
- Confirm the workflow plan is exported beside each leg's delivered receipts
  and cannot be overwritten with different contents.
- Configure the P5 server, Keychain password, archive index, P5 client, and
  archive plan in Settings → P5 Archive.
- Use Test Connection & Load to populate the live selectors.
- Run a small Full or Inline verified copy and confirm the request JSON, archive
  job, archived paths, and metadata in P5 Web.
- Search the GUI-visible `CT_*` fields, including xxHash64 and frame/image size.
- Restore the fixture and verify every restored file against its capture MHL.
- Stop P5 and confirm CopyTrust still completes the verified copy while writing
  an actionable, password-free deferred request.
- Queue mixed Card and Folder jobs with different artifact settings. `Start
  Queue` must run the complete list even when one queued profile has Auto
  Advance off, and each job must use its captured settings.
- In a multi-destination copy, confirm contact sheets, CSV/tree outputs, and
  proxies appear on every eligible destination while P5 receives only the
  destination whose row has **Archive to P5** checked.
- Confirm every successfully encoded proxy receives a checkmark; if Retry is
  used, confirm the row changes to Running and then to the new terminal result.
- In a Debug build, send the privacy-safe Sentry test event, locate the shown
  event ID in the `apple-macos` project, and confirm no path or private fields
  arrived.

## Safety boundaries

- Quick and copy-only jobs are never automatically submitted.
- Every automatically submitted file must have a valid 16-digit xxHash64.
- Plans reported by P5 as deleting their source are blocked.
- The selected P5 client must see the destination at the same absolute path.
- P5 failure does not change a successful copy/verification verdict.
- Restore remains a deliberate P5 operator action.
- Sentry is configured not to capture or transmit media paths, media filenames,
  P5 connection/job details, credentials, or operator/client private
  information. Collection features are disabled and a final on-device filter
  removes those values before diagnostic upload.

## Live baseline

A CopyCore Inline test against P5 8.0.4 succeeded; private fixture and job
identifiers are intentionally anonymized here.
The example archive index archived the generated PNG, text sidecar, and MHL to a
test container volume. ArchiveEntry readback returned complete hashes, the PNG's
`64x36` dimensions, and the expected CopyTrust metadata.

See `TEST_NOTES_v2.7.0.md` and `COPYTRUST_WORKFLOW_QA_MATRIX.md` before testing.
