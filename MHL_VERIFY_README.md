# MHL Verify

`MHL Verify` is a macOS app for opening, reviewing, comparing, and exporting `.mhl` files.

It started as a default-handler utility, but the current app is primarily an MHL reader with comparison tools and a secondary Handlers tab for inspecting macOS file associations.

## What It Does

- Open `.mhl` files as native macOS documents
- Open files by dragging onto the Dock icon, dragging into the app, or using the Open button
- Review a single MHL in the reader
- Compare two MHL files side by side
- Export the active MHL as JSON, Markdown, or RTF
- Inspect and change the default macOS app for `.mhl`

## Main Workflows

### Open From the Dock

If `MHL Verify` is in the Dock, you can drag one or more `.mhl` files onto the Dock icon.

- Dropping one file opens one document window
- Dropping two files opens two document windows
- This is the quickest way to review files directly from Finder

### Open Inside the App

Launch the app normally and use the `Reader` tab.

- Click `Open MHL Files`
- Drag a single `.mhl` into the reader to replace the current file
- Drag a folder into the reader to load all `.mhl` files from that folder into the `Open Files` list
- Reopen earlier files from `Recent Files`

This is the better path when you want to review several MHL files in one session or prepare files for comparison.

### Compare Two MHL Files

Use the `Compare…` button in the `Reader` tab.

- Select exactly two `.mhl` or XML files
- The app opens a comparison sheet
- The comparison view highlights matching and differing summary values
- Use `Done` to dismiss the comparison view

### Export

With a file loaded in the reader, use `Save As`.

- `Save as JSON`
- `Save as Markdown`
- `Save as RTF`

## Handler Utility

The `Handlers` tab remains available for macOS file-association work.

It can:

- resolve `.mhl` to a type identifier
- list candidate apps that can open the type
- show the current default app
- set a selected app as the default handler

The app uses the `io.macadmins.pique.mediahashlist` type identifier for `.mhl`, which aligns with the related `PiqueMHL` Quick Look work.

## Build

### SwiftPM

```bash
swift build
```

### Xcode

Open MHLDefaultApps.xcodeproj and build the `MHLDefaultApps` scheme.

Command-line build:

```bash
xcodebuild -project MHLDefaultApps.xcodeproj -scheme MHLDefaultApps -configuration Debug -derivedDataPath /tmp/MHLDefaultAppsDerivedData CODE_SIGNING_ALLOWED=NO build
```
## License

Copyright 2026 Mat X Network Consultants / MacVFX

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for
the full terms.

If you use or redistribute this code, please attribute
[Mat X Network Consultants / MacVFX](https://github.com/macvfx/MHLVerify)
as required by the license.

## Acknowledgements

The Quick Look extension and parts of the preview rendering infrastructure
are derived from [Pique](https://github.com/macadmins/pique) by
Declarative IT GmbH, licensed under the Apache License 2.0.
See MHL_VERIFY_PIQUE_ATTRIBUTION.md for the full list of
derived files and the changes made.

## Documentation

- [User Guide](MHL_VERIFY_USER_GUIDE.md)
- [Pique Attribution](MHL_VERIFY_PIQUE_ATTRIBUTION.md)

