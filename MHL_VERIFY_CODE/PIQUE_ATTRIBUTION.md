# Pique Attribution Notice

This project contains code derived from
[Pique](https://github.com/macadmins/pique), a macOS Quick Look extension
by **Declarative IT GmbH**.

Pique is licensed under the **Apache License, Version 2.0**.
A copy of the license is available at
<https://www.apache.org/licenses/LICENSE-2.0>.

Copyright 2025 Declarative IT GmbH

---

## What we used

Three source files in this project are derived from Pique. The original code
was adapted to work with Media Hash List (MHL) files rather than
configuration profiles.

### 1. PreviewProvider.swift

| | |
|---|---|
| **Our file** | `MHLVerifyQL/PreviewProvider.swift` |
| **Pique original** | `PiquePreview/PreviewProvider.swift` |

The Quick Look extension controller follows Pique's structure:

- `@objc(PreviewProvider)` class inheriting `NSViewController` and
  conforming to `QLPreviewingController`
- Lazy `NSTextView` / `NSScrollView` setup with the same configuration
  (non-editable, selectable, 16 pt insets, automatic substitution disabled)
- `preparePreviewOfFile(at:completionHandler:)` pipeline: read file, detect
  dark mode via `effectiveAppearance.bestMatch`, render HTML, convert to
  `NSAttributedString`, set background color
- Dark-mode background color value `NSColor(red: 0.110, green: 0.110,
  blue: 0.118, alpha: 1)`

**Changes:** The file-reading and rendering calls were replaced with
`MHLDocument.read()` and `MHLPreviewRenderer.render()`. Pique's `Logger`,
`FileReader` calls, format detection, CMS-signature stripping, and binary
plist conversion were removed.

### 2. MHLFileReader.swift

| | |
|---|---|
| **Our file** | `Sources/MHLFileReader.swift` |
| **Pique original** | `Shared/FileReader.swift` |

A simplified version of Pique's `FileReader`:

- Same caseless `enum` namespace pattern
- Same 10 MB file-size limit (`maxFileSize: UInt64 = 10_000_000`)
- Same UTF-8 then ISO Latin-1 fallback encoding chain
- Same nested `LocalizedError` enum for the file-too-large case

**Changes:** Removed CMS/PKCS#7 signature stripping, binary plist
detection/conversion, and the `readData(url:)` variant. Only the
text-reading path was kept.

### 3. MHLPreviewRenderer.swift

| | |
|---|---|
| **Our file** | `Sources/MHLPreviewRenderer.swift` |
| **Pique original** | `Shared/SyntaxHighlighter.swift` |

The HTML rendering infrastructure is adapted from Pique's
`SyntaxHighlighter`:

- `Theme` struct with the same property names (`bg`, `cell`, `sep`, `text`,
  `key`, `label`, `muted`, `accent`) and largely identical color values
- `pad = 16` layout constant
- `esc(_:)` / `escapeHTML(_:)` helpers (same implementation)
- `thinLine(theme:)`, `thinSeparator(theme:)`, `cellRow(_:_:theme:last:)`
  table-layout helpers with the same 38 % key-column width
- `wrapHTML(_:theme:)` with the same CSS and `-apple-system` font stack
- Two-section layout pattern: card-style metadata tables followed by raw
  source

**Changes:** All syntax-highlighting and tokenization code was removed. The
rendering body was rewritten to display MHL document fields (files, hashes,
sizes, creator/source info, XML source). Two accent color values were
changed from Pique's purple/violet palette to blue.

---

## License compliance

The Apache License 2.0 permits use, reproduction, modification, and
distribution of the licensed work, including derivative works, provided that:

1. A copy of the license is included (this notice and the license link above
   satisfy this requirement).
2. Modified files carry a prominent notice stating that they were changed
   (the "Changes" sections above document all modifications).
3. Any existing `NOTICE` file contents are retained (Pique does not ship a
   `NOTICE` file).

This attribution document fulfills those obligations.
