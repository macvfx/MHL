# MHL Verify User Guide

## Overview

`MHL Verify` gives you three main ways to work:

- review a single `.mhl` file
- **verify** the files an MHL describes against the media on disk
- compare two `.mhl` files

It also includes a secondary `Handlers` tab for checking or changing the default app macOS uses for `.mhl`.

> **Supported formats (2.5.1):** classic MHL v1.0/1.1 and ASC MHL v2.0 — the default output of Silverstack 9+, including manifests in an `ascmhl/` folder. Versions 2.4.1 and earlier showed ASC MHL v2.0 files as "Zero bytes" ([#1](https://github.com/macvfx/MHL/issues/1)); update if you see that. Requires macOS 14 or later.

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
4. Choose two `.mhl` or XML files.

The compare sheet shows:

- high-level match or difference indicators
- summary values for each file
- highlighted mismatches

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

### Export a Report

- Open one file in the reader
- Use `Save As`

## Current Limits

- Dock-drop opens separate document windows; it is not the compare workflow
- Comparison currently focuses on summary readability, with a deeper file-level diff table planned next
- Folder import loads matching `.mhl` files into the picker list rather than opening a separate chooser dialog
