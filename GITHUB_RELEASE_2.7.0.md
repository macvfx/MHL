# CopyTrust 2.7.0 (Build 1) — P5 Archive Integration Beta

CopyTrust can now archive a hash-verified destination directly to Archiware P5
after the copy trust chain and enabled post-copy actions finish.

This is a **public prerelease for controlled testing**. Use expendable media and
a non-deleting archive plan until the workflow has passed your site acceptance
tests.

## What to test

- Configure the P5 server, Keychain password, archive index, P5 client, and
  archive plan in Settings → P5 Archive.
- Run a small Full or Inline verified copy and confirm the request JSON, archive
  job, archived paths, and metadata in P5 Web.
- Search the GUI-visible `CT_*` fields, including xxHash64 and frame/image size.
- Restore the fixture and verify every restored file against its capture MHL.
- Stop P5 and confirm CopyTrust still completes the verified copy while writing
  an actionable, password-free deferred request.

## Safety boundaries

- Quick and copy-only jobs are never automatically submitted.
- Every automatically submitted file must have a valid 16-digit xxHash64.
- Plans reported by P5 as deleting their source are blocked.
- The P5 client must see the destination at the same absolute path.
- P5 failure does not change a successful copy/verification verdict.

Live baseline: P5 8.0.4 job `10029` archived a CopyCore Inline-verified PNG,
sidecar, and MHL. Readback returned complete hashes, `64x36` image dimensions,
and the expected CopyTrust metadata.

See `TEST_NOTES_v2.7.0.md` and `COPYTRUST_WORKFLOW_QA_MATRIX.md`.
