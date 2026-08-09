# MHL Verify User Guide

## Overview

`MHL Verify` gives you three main ways to work:

- review a single `.mhl` file
- **verify** the files an MHL describes against the media on disk
- compare two `.mhl` files

It also includes a secondary `Handlers` tab for checking or changing the default app macOS uses for `.mhl`.

> **Supported formats (2.6.0):** classic MHL v1.0/1.1 and ASC MHL v2.0 — the default output of Silverstack 9+, including manifests in an `ascmhl/` folder. Versions 2.4.1 and earlier showed ASC MHL v2.0 files as "Zero bytes" ([#1](https://github.com/macvfx/MHL/issues/1)); update if you see that. Requires macOS 14 or later.

## Opening MHL Files

### Option 1: Drag to the Dock Icon

This is the fastest path when you are in Finder.

1. Drag an `.mhl` file onto the `MHL Verify` icon in the Dock.
2. The app opens a document window showing that file.

Notes:

- One dropped file opens one viewer window.
- Two dropped files open two viewer windows.
- This path is best for quick single-file review.

### Option 2: Open the App First

This is the better path when you want to review multiple files, reopen recent files, compare files, or export.

1. Open `MHL Verify`.
2. Stay in the `Reader` tab.
3. Use one of these actions:
   - click `Open MHL Files`
   - drag a single `.mhl` file into the app
   - drag a folder containing `.mhl` files into the app

Behavior:

- Dragging one `.mhl` file replaces the current reader view.
- Dragging a folder loads its `.mhl` files into the `Open Files` list.
- `Recent Files` keeps a history of previously opened files.

## Reviewing a File

When a file is open, the reader shows:

- the current file path
- a rendered summary view
- the underlying parsed MHL content

Use the `Open Files` list to switch between currently loaded files.

## Verifying Files Against an MHL

Use Verify when you want to confirm that the media files an MHL describes are still intact — after a copy, a restore, or a handoff.

1. Open the `.mhl` in the reader (or via **Open With › MHL Verify** from Finder).
2. Click `Verify…`
3. Check the **Media Folder** — it is detected from the MHL's location automatically. For ASC MHL files inside an `ascmhl/` folder, the parent folder is used. Click `Change…` to verify a copy in a different location.
4. Click `Verify`.

Every file listed in the MHL is re-hashed from disk and compared against the recorded digest. The sheet shows per-file progress and can be cancelled at any time, even partway through a large file.

Results:

- **Matched** — the file's hash matches the MHL entry
- **Mismatched** — the file exists but its content differs; the expected and actual digests are listed for each mismatched file
- **Missing** — a file listed in the MHL was not found in the media folder

Use `Verify Again` to re-run after fixing problems, or to check a second copy by changing the media folder.

## Comparing Two Files

Use comparison when you want to check whether two MHL files match or differ.

1. Open the app.
2. Go to the `Reader` tab.
3. Click `Compare…`
4. Fill `Side A` and `Side B`.

Each side is picked separately, so the two files do not have to be on the same
disk — the usual case is a manifest on the source volume and its counterpart on
the archive. For each side you can:

- click `Choose…` to browse that side's volume (each side remembers its own folder)
- drag a `.mhl` file from a Finder window straight onto that side's drop well
- use `Recents` to pick a file already open in the reader, or a recent file

Dropping two `.mhl` files at once fills both sides. A filled side shows the volume,
folder, file count, total size and MHL version, so you can confirm you have the
right disk before comparing. `Swap Sides` flips A and B; `Compare` becomes
available once both sides hold a readable file.

The compare sheet opens with a verdict banner:

- **Manifests Match** — same files, same folders, same times
- **Match — Timing Differs Only** — the files are identical in size and hash; only
  the times the manifests were written and hashed differ. Two manifests are never
  written at the same moment, and a relay chain copies in series, so this is the
  normal result when comparing two destinations from one job
- **Match — Different Layout** — every file matches by name, size and hash, but some
  sit in different folders. This is what Destination Sort produces: compare a sorted
  destination against the pre-sort MHL in the receipts folder and every file is
  reported as `Moved`, not as added and removed
- **Manifests Differ** — a real difference: a changed digest or size, or a file on
  one side only

Below that, the compare sheet shows:

- high-level match or difference indicators
- summary values for each file
- highlighted mismatches, with timestamp rows marked `Timing` rather than
  `Different` because they describe when a manifest was written, not what is in it
- a file-level table filtered by `Differences`, `Changed`, `Moved`, `Added/Removed`
  or `All`; selecting a row shows both sides' size, hash, date and — for a moved
  file — both paths

Click `Done` to close the compare view.

## Exporting

When a file is loaded in the reader:

1. Click `Save As`
2. Choose one of:
   - `Save as JSON`
   - `Save as Markdown`
   - `Save as RTF`

Use this when you want to share a readable version of the manifest or keep a derived record outside the app.

## Recent Files

`Recent Files` is intended as a lightweight working history.

- Click an item to reopen it
- Opening a new file does not erase the history
- The reader itself focuses on the current file or currently loaded folder set

## Default App Handling

The `Handlers` tab is optional. Use it only when you need to inspect or change how macOS opens `.mhl` files.

Typical reasons to use it:

- verify that `MHL Verify` is registered as a compatible app
- switch the system default away from another app
- inspect what macOS currently resolves for `.mhl`

## Recommended Usage Patterns

### Quick Review

- Drag one `.mhl` onto the Dock icon

### Review Several Files

- Open the app first
- Drag a folder into the reader
- Use `Open Files` and `Recent Files`

### Compare Two Files

- Open the app first
- Click `Compare…`
- Fill `Side A` and `Side B` separately — they can be on different volumes

### Export a Report

- Open one file in the reader
- Use `Save As`

## Current Limits

- Dock-drop opens separate document windows; it is not the compare workflow
- Compare includes summary differences plus a file-level table with
  changed/added/removed/unchanged filters, left/right sizes and hashes, and
  selected-file details
- The Compare sheet does not yet export a dedicated comparison report;
  **Save As** exports the active MHL document
- Folder import loads matching `.mhl` files into the picker list rather than opening a separate chooser dialog
