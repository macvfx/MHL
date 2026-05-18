# CopyTrust Release Notes — v2.4.2 and v2.4.3

Date: 2026-05-17
Branch: `codex/v2.2`

---

## v2.4.2 Build 1 — Destination File Sorting

### New Feature: Sort on Destination

After copy, verify, and MHL are complete, CopyTrust can now reorganize files on the destination into type-based subfolders. The trust chain is sealed before any files are moved.

**Setup:** Settings > Post-Copy > Sort files into type folders on destination.

**Default categories:**

| Folder | Extensions |
|--------|------------|
| JPG | jpeg, jpg, heic, heif, png, tiff, tif, bmp, gif |
| RAW | cr3, cr2, arw, nef, dng, raf, orf, rw2, pef, srw, iiq, 3fr, fff, erf, nrw, gpr |
| Video | mov, mp4, m4v, avi, mts, m2ts, m2t, m2v, vob |
| Pro Video | mxf, r3d, braw, ari, cdng |
| Audio | wav, mp3, aac, aiff, bwf, flac |
| Sidecar | xmp, thm, aae, lrv, srt |

**Two folder modes:**
- **Flatten** (default) — all files of a type go directly into the type folder, with automatic `_2`, `_3` rename on collision
- **Preserve Structure** — keeps the source directory tree inside each type folder

Categories are fully customizable: enable/disable, rename folders, edit extensions, add or remove categories, reset to defaults. All settings persist across launches.

Contact sheet PDFs and EXIF CSVs reflect the sorted file locations.

### Bug Fix: Case-Insensitive Exclusions

- Exclusion patterns starting with `.` (e.g. `.MP4`) are now treated as case-insensitive suffix matches regardless of the selected pattern type
- All exclusion pattern types (Exact, Suffix, Prefix, Contains, Regex) are now case-insensitive

---

## v2.4.3 Build 1 — Start Button Visibility and Polish

### Pinned Action Bar

The Start button and session controls are now pinned to the bottom of the window, always visible regardless of scroll position. On smaller screens or narrow windows the Start button was previously scrolled off-screen.

### Auto-Collapse Available Volumes

The Available Volumes panel collapses automatically when both a source and destination are loaded. The panel can still be expanded manually at any time.

### Reduced Empty Space

Source and destination panels use less vertical space when cards are loaded, making more room for the queue and action bar.

### Sort Extension Matching Fix

Sort category extensions now strip leading dots and match case-insensitively. Typing `.lrf`, `lrf`, or `.LRF` in the extensions field all work identically. The placeholder text now shows `jpg, mov, cr3, …` (without dots) to guide correct input.

### Clean Session Launch

The app no longer restores previous session state on launch unless it was a cancelled or failed session with resume available. Completed and idle sessions start fresh.
