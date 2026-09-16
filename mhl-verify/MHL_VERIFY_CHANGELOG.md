# MHL Verify Changelog

## 2.6.0 (1) — 2026-08-08

### A verdict, so an expected difference does not read as a failure

Compare now opens with a plain-language banner — **Manifests Match**, **Match —
Timing Differs Only**, **Match — Different Layout**, or **Manifests Differ** — and
two differences that used to look like corruption are classified for what they are.

**Timestamps are no longer treated as content.** The per-file identity test folded
`hashDate` and `lastModificationDate` in alongside size and hash, so comparing two
copies of the same card reported *every* file as `Changed` while the sizes and
hashes shown in the table were plainly identical. Two manifests are never written at
the same instant — a relay chain copies in series, so the second destination is
hashed after the first has finished — and a copy that did not preserve modification
times differs there too. Identity is now size and digests only, and only digests
recorded on both sides are compared, so an xxHash64 manifest and a SHA-256 one no
longer fail on the digest each is missing. Timestamp differences are reported as
timing: the summary rows carry an amber `Timing` badge instead of a red `Different`,
and the banner says the files match.

**A sorted destination now lines up against its source.** Files were paired by full
path, so a destination copied with Destination Sort on shared no path with its
pre-sort source and every file was reported as both added and removed. Unmatched
entries now get a second pass that pairs them by name, size and hash — only when
exactly one candidate exists on each side, so duplicates are never guessed at — and
those pairs are reported as **Moved**, with both paths shown in the file details and
a `Moved` filter beside the existing ones.

Real content differences are unaffected: a changed digest, a changed size, or a file
present on one side only still reports as `Changed` / `Added` / `Removed`, and the
banner reads **Manifests Differ**.

### Compare files that live on different volumes

`Compare…` now opens a side-by-side picker — `Side A` and `Side B` — instead of one
open panel set to multiple selection.

A single open panel can only return files from one folder, so the old flow could
only ever compare two manifests sitting side by side on the same disk. That is the
rare case. The normal one is a manifest on the camera card or source volume and its
counterpart on the archive or NAS, which no single panel can reach at once, and the
app answered with "Choose exactly two MHL files to compare" no matter what was
picked.

Each side is now filled independently:

- its own `Choose…` panel, which remembers that side's last folder rather than
  sharing one "last location" that kept sending you back to the wrong volume
- its own drop well, so two Finder windows on two disks can be dragged in
- its own `Recents` menu listing files already open in the reader and recent files
- dropping two MHL files onto an empty pair fills both sides at once

Each filled side shows the volume it came from, its folder, and its file count,
total size and MHL version, so a wrong disk is visible before comparing. `Compare`
stays disabled until both sides hold a readable manifest, and `Swap Sides` flips
them without re-picking.

---


## 2.5.1 (2) — 2026-08-02

### Its own release home

MHL Verify now checks **`macvfx/MHL-Verify`** for updates rather than the shared
`macvfx/MHL` repository.

MHL Verify releases alongside CopyTrust, Drop Verify and Folder Copy Compare, which
build from a single Xcode project and version together. MHL Verify is a separate
project on its own cadence and had reached 2.5.1 while the others moved to 2.7.0 —
so "newest release" on the shared repository was rarely a version of this app.
Releases from 2.5.4 onward stopped carrying an MHL Verify build at all, meaning the
update checker sent people to a page with nothing on it for them.

Its own repository fixes that, and is where the **mhl-tool** command line version
will be published too, so both halves ship as one set. Releases up to 2.5.3 remain
in `macvfx/MHL`.

### Fixes

- **Update alert could not be dismissed:** the OK button took several attempts to
  click, because the alert attached itself as a sheet to whichever window was key —
  including transient ones that take the sheet with them — and the app did not come
  forward before presenting it.

---


## 2.5.1 (1) — 2026-06-12

### ASC MHL v2.0 support (fixes [macvfx/MHL#1](https://github.com/macvfx/MHL/issues/1))

MHL Verify now reads ASC MHL v2.0 hashlists — the default output of Pomfort Silverstack 9+, also written by Hedge OffShoot, YoYotta v4, and ShotPut Pro. Previously these files opened but showed **"Zero bytes"** with no usable hash entries, because the app's parser only understood the classic MHL v1.x element layout.

The fix replaces MHL Verify's private XML parser with **CopyCore**, the shared Media Trust Tools engine that also powers `mhl-tool verify`, CopyTrust re-verify, and Folder Copy Compare. One parser across the whole suite means a format fix lands everywhere at once.

- Correct file sizes, paths, modification dates, and hashes for `<hashlist version="2.0">` files, with or without the `urn:ASC:MHL:v2.0` namespace
- New per-entry fields displayed in the reader, Quick Look preview, and JSON/Markdown/RTF exports: **MD5**, **SHA-1**, **SHA-256**, and the ASC MHL **action** provenance ("original" / "verified")
- Files in an `ascmhl/` folder resolve media paths against that folder's parent automatically

### New: Verify action

The app finally does what its name says. A **Verify…** button is available in the Reader tab and in every document window:

- Re-hashes every file listed in the MHL (xxHash64 via the shared CopyCore engine; MD5/SHA-1/SHA-256 manifests also supported) and compares against the recorded digests
- Media folder is auto-detected from the MHL location (including the ASC MHL `ascmhl/` layout) and can be changed to verify a copy in another location
- Per-file progress, cancellable between files
- Results show matched / mismatched / missing counts, the creating tool, and the expected-vs-actual digests for every mismatch

### Changes

- macOS 14 (Sonoma) or later is now required, aligning MHL Verify with the rest of the Media Trust Tools suite. macOS 13 users can continue using 2.4.1.
- Version aligned with the suite at **2.5.1 (1)**; the Quick Look extension version matches.

---

## 2.4.1 (7) — 2026-05-02

### Check for Updates

MHL Verify now checks the public GitHub repo (`macvfx/MHL`) for new releases and notifies you when one is available.

- **App menu → Check for Updates…** checks immediately and shows a dialog with the result.
- On launch, the app checks silently once every 24 hours. If a newer release is found, an alert appears with a **Download** button linking directly to the GitHub release page.
- If your build is already at or ahead of the latest release, the dialog confirms that clearly — showing both the GitHub version and yours.

### Version alignment

Version number aligned with the other apps in the MHL suite (CopyTrust, Drop Verify, Folder Copy Compare) at **2.4.1 (7)**. The MHL Verify Quick Look extension version has been updated to match, resolving the App Store / archive requirement that extension and parent app share the same build number.

---

## 0.7 (2) — 2026-04-30

### Fix: scrolling broken in the main reader window

Scrolling through an MHL's content in the Reader tab did not work. The scroll bar was visible but unresponsive.

**Cause:** the reader's HTML preview area used a transparent `NSView` overlay to handle file drag-and-drop. That overlay covered the entire content area and intercepted all mouse events — including scroll wheel — before they could reach the web view underneath. The web view never received them.

**Fix:** the overlay has been removed. Drop handling is now built directly into the HTML preview's own view layer. The web view receives all scroll and mouse input without interference, and drag-and-drop continues to work as before.

The document window opened via **Open With › MHL Verify** was not affected and always scrolled correctly.

---

## 0.7 (1) — 2026-04-30

### Improved compatibility with other MHL-capable apps

MHL files created by production tools that generate their own file-type metadata are now recognised by MHL Verify. The app now registers as a compatible viewer for both of the UTIs in active use for `.mhl` on macOS, so it appears consistently in the right-click **Open With** menu regardless of which tool originated the file.

Previously, when another app had stamped a `.mhl` file with its own type identifier, MHL Verify would not appear as an option — leaving operators with no quick path to open the file in a verification-focused viewer. That gap is closed.

The app's handler role has also been updated from `Viewer` to `Editor`. On macOS, only apps declaring the `Editor` role are offered as candidates when the user picks a new default handler for a file type. The previous `Viewer` role meant MHL Verify was silently excluded from that selection in some system dialogs.

**In practice:**

- Right-clicking any `.mhl` file — including files generated by production copy tools — now offers **Open With › MHL Verify** as an explicit option.
- The first time you open an `.mhl` in MHL Verify, macOS may prompt whether to make it the default. That choice is yours to keep or dismiss.
- Operators on managed systems can now set MHL Verify as the handler for `.mhl` via System Settings, via the in-app **Handlers** tab, or via `duti`.

### Quick Look

The Quick Look extension now also previews `.mhl` files stamped with alternate type identifiers, consistent with the main app changes above.

---

## 0.6 — 2026-03-10

Initial distributed build. MHL reader, comparison view, Quick Look extension, and handler utility.
