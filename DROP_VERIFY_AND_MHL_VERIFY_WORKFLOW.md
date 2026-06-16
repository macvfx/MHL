# Drop Verify + MHL Verify Workflow

This document explains how the two tools fit together:

- **Drop Verify** creates trust artifacts from a dropped folder
- **MHL Verify** follows up by verifying MHL files created by Drop Verify or other MHL-capable tools

## Why Use Both

The two apps solve different parts of the same trust workflow.

### Drop Verify
Use Drop Verify when you want to generate new artifact files from a folder:

- `MHL (Media Hash List)`
- `Contact sheet PDF`
- `EXIF camera metadata CSV`
- `HTML directory tree/index` (optional; Project summary index is native, recursive modes require `tree`)

It is best for:

- post-copy reporting
- packaging deliverable trust artifacts
- creating an MHL for a media folder that does not already have one

### MHL Verify
Use MHL Verify when you already have an MHL and want to check files against it.

It is best for:

- re-verifying a copy later
- checking files on another drive or machine
- confirming that an archived or handed-off copy still matches the original manifest
- validating MHLs from Drop Verify, CopyTrust, Silverstack, OffShoot, YoYotta, or other compatible apps

> **ASC MHL v2.0 note:** Pomfort Silverstack 9+ writes ASC MHL v2.0 hashlists by default rather than classic MHL v1.1. As of suite v2.5.1, the whole suite reads and verifies these — including MHL Verify, which also gained a built-in **Verify** action. MHL Verify 2.4.1 and earlier showed v2.0 files as "Zero bytes" with no usable hash entries ([macvfx/MHL#1](https://github.com/macvfx/MHL/issues/1)); update to 2.5.1 if you see that.

## Recommended Workflow

### Workflow A: Create an MHL with Drop Verify, then verify it with MHL Verify

1. Open **Drop Verify**.
2. In `Settings`, enable the outputs you want:
   - `MHL (Media Hash List)`
   - `Contact sheet PDF`
   - `EXIF camera metadata CSV`
   - `HTML directory tree/index` (optional; Project summary index is native, recursive modes require `tree`)
3. Drop a media folder into Drop Verify.
4. Let Drop Verify finish writing artifacts.
5. Open the generated folder:
   - `Drop Verify_Receipts/`
6. Locate the generated `.mhl` file.
7. Open **MHL Verify**.
8. Load or drag the `.mhl` file into MHL Verify.
9. Point MHL Verify at the folder or copy you want to check.
10. Run verification and review matched, missing, or mismatched results.

This gives you:

- a freshly generated MHL from Drop Verify
- a separate verification pass using MHL Verify

That second step is useful when you want a cleaner handoff between artifact creation and later proof of integrity.

## Workflow B: Use Drop Verify for reporting, use MHL Verify for later archive checks

1. Generate artifacts with Drop Verify.
2. Keep the `.mhl` together with the media or archive package.
3. Weeks or months later, open the same `.mhl` in MHL Verify.
4. Re-verify the stored files against the recorded hashes.

This is a strong workflow for:

- archive intake
- restore checks
- vendor handoff confirmation
- QA after copying to another storage tier

## Workflow C: Verify MHLs from other apps

Drop Verify is not required for MHL Verify to be useful.

MHL Verify can also be used with MHL files created by:

- CopyTrust
- Pomfort Silverstack
- Hedge OffShoot
- YoYotta
- other MHL-capable tools

One practical pattern is:

1. Receive media plus an `.mhl` from another app or vendor.
2. Use **MHL Verify** to confirm the copy.
3. If you also want a visual report or spreadsheet, run **Drop Verify** on the verified folder to create:
   - contact sheet PDF
   - EXIF camera metadata CSV
   - a local MHL if needed for your own package

## What Each Artifact Is For

### MHL
- Integrity manifest
- Best for later verification and chain-of-custody support

### Contact sheet PDF
- Visual review
- Good for quick confidence checks and delivery packages

### EXIF camera metadata CSV
- Spreadsheet/reporting export
- Good for logging, sorting, handoff notes, and editorial/admin review

### MHL Verify result
- Follow-up proof that the files still match the manifest
- Best for later validation, archive checks, and receiving-side confirmation

## Simple Team Recommendation

If you want the cleanest operator guidance:

1. **Use Drop Verify first** when a folder needs trust artifacts.
2. **Use MHL Verify second** when you want to validate the resulting MHL against the files now or later.

That keeps the roles clear:

- Drop Verify = create trust package
- MHL Verify = verify trust package

## Command-Line Alternative: mhl-tool

`mhl-tool` does the same MHL create and verify operations from the terminal. Use it when you need scripting, automation, SSH access, or batch processing.

```bash
# Same as Drop Verify → create MHL
mhl-tool create /Volumes/RAID/A001

# Same as MHL Verify → verify MHL
mhl-tool verify /Volumes/RAID/A001
```

The full command reference is included with the `mhl-tool` installer package (see Releases).

## Notes

- Drop Verify creates media-focused artifacts and only hashes media files for its MHL output in the current implementation.
- MHL Verify is the better tool when the main question is simply: "Do these files still match this manifest?"
- `mhl-tool` is the best choice when the workflow is scripted, remote, or headless.
- Using both tools gives you both artifact creation and follow-up validation in separate steps, which can be easier to explain to operators and clients.
