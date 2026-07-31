# CopyTrust 2.7.0 (Build 8) — P5 Archive, Queue, and Sentry Integration Beta

CopyTrust can now archive a hash-verified destination directly to Archiware P5
after the copy trust chain and enabled post-copy actions finish.

Build 8 includes all Build 7 P5 and queue hardening: an explicit **Archive to
P5** checkbox per destination; required `CT_*` metadata-key preflight with an
operator-approved install action; captured artifact/P5 settings for queued
jobs; independent artifact completion states; and bounded asynchronous P5 job
polling so archive completion does not hold the next queued copy. It also fixes
the crash observed after successful P5 completion and adds richer, quieter job
diagnostics.

The recreated Sentry integration filters paths and private diagnostic values
on device before transmission. A live synthetic Build 8 test event reached the
`apple-macos` project with its exception value already redacted. Release dSYM
symbolication remains a separate pipeline check.

This is a **public prerelease for controlled testing**. Use expendable media and
a non-deleting archive plan until the workflow has passed your site acceptance
tests.

## What to test

- Configure the P5 server, Keychain password, archive index, P5 client, and
  archive plan in Settings → P5 Archive.
- Confirm the selected destination says **Archive to P5**, and that preflight
  names the chosen archive index, client, and non-deleting plan.
- Confirm missing required `CT_*` keys block submission until the explicit
  metadata-key install succeeds.
- Run a small Full or Inline verified copy and confirm the request JSON, archive
  job, archived paths, and metadata in P5 Web.
- Search the GUI-visible `CT_*` fields, including xxHash64 and frame/image size.
- Restore the fixture and verify every restored file against its capture MHL.
- Stop P5 and confirm CopyTrust still completes the verified copy while writing
  an actionable, password-free deferred request.
- Queue mixed jobs and confirm copies keep advancing while artifact rows and P5
  status reach independent terminal states.
- In a Debug build, send the Sentry integration event and confirm the received
  exception value is `Redacted by CopyTrust privacy filter`.

## Safety boundaries

- Quick and copy-only jobs are never automatically submitted.
- Every automatically submitted file must have a valid 16-digit xxHash64.
- Plans reported by P5 as deleting their source are blocked.
- The P5 client must see the destination at the same absolute path.
- P5 failure does not change a successful copy/verification verdict.
- CopyTrust will not automatically archive without its required `CT_*`
  tracking keys.

Tested baseline (private fixture identifiers anonymized): P5 8.0.4 archived a
CopyCore Inline-verified PNG,
sidecar, and MHL. Readback returned complete hashes, `64x36` image dimensions,
and the expected CopyTrust metadata.

See `TEST_NOTES_v2.7.0.md` and `COPYTRUST_WORKFLOW_QA_MATRIX.md`.
