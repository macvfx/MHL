# MHL Verify User Guide

## Overview

`MHL Verify` gives you two main ways to work:

- review a single `.mhl` file
- compare two `.mhl` files

It also includes a secondary `Handlers` tab for checking or changing the default app macOS uses for `.mhl`.

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
