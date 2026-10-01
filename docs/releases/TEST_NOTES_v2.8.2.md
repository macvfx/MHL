# CopyTrust 2.8.2 — Test Notes

**Build under test:** 2.8.2 Build 23 · **Previous release:** 2.8.1 Build 21
**Written:** 2026-09-07

**What this release is about:** making CopyTrust readable for an operator who cannot comfortably
read 10-point text. It is an **interface release**. Nothing in the copy, verification, naming,
receipt or P5 paths changed, so what is being tested is whether the app still *reads* and still
*works* when it is larger — not whether it still copies correctly.

**CopyTrust only.** Drop Verify and Folder Copy Compare are unchanged at 2.8.1 build 21.

**Build 22 is superseded.** It was published and replaced the same day: its About panel and Help
topic list cut their own text off at larger sizes. If you have build 22, replace it.

**Companions:** `COPYTRUST_FIELD_CHECKLIST.md` is the standing checklist for the whole app;
section I covers this release in short form. This document is the long form.

**Mark each item P (proven), F (failed) or S (skipped).**

---

## Why this exists

macOS resolves both `.caption` and `.caption2` to **10.0 points** — the smallest size Apple
documents for custom text on the platform — and 625 of CopyTrust's 1,032 explicit font settings
used one or the other. Over 60% of the interface was drawn at the documented floor, with no margin
beneath it and no way for an operator to ask for more.

The usual remedy does not exist here. macOS has no Dynamic Type: `dynamicTypeSize` and
`@ScaledMetric` are both no-ops, measured rather than assumed. Magnifying the finished window with
`scaleEffect` grows the pixels without giving the layout any more room, so text lands outside the
box that holds it. CopyTrust therefore carries its own scaling layer, which is why this needs
testing across the whole app rather than in one place.

---

## Session Info

- Date:
- Operator:
- Machine / macOS:
- Display(s) and resolution (a laptop screen and an external monitor behave differently here):
- Version beside the CopyTrust name in the window header (must read **2.8.2 (23)**):
- Sizes tested:

---

## A. Finding it at all

**A1 — the control in the window**
- **Do:** look at the top right of the main window.
- **Expect:** an `AA` icon and a segmented `1x · 1.25x · 1.5x · 2x`, with the current size selected.
- Result: ☐ P ☐ F ☐ S

**A2 — the menu**
- **Do:** open `View`.
- **Expect:** `Increase Interface Size` (⌘+), `Decrease Interface Size` (⌘−), `Actual Size` (⌘0)
  and an `Interface Size` submenu listing all four with their percentages. Increase is unavailable
  at Maximum and Decrease at Standard.
- Result: ☐ P ☐ F ☐ S

**A3 — Settings**
- **Do:** `Settings ▸ Appearance`.
- **Expect:** the same four as radio buttons, and a live sample — heading, instruction, a
  source-to-destination line, a warning, and two buttons — that resizes as you choose, so a size
  can be judged without closing Settings.
- Result: ☐ P ☐ F ☐ S

**A4 — the version is readable without opening About**
- **Do:** read the top left of the window.
- **Expect:** `CopyTrust` with `2.8.2 (23)` in grey beside it.
- Result: ☐ P ☐ F ☐ S

---

## B. A whole job at a larger size

**This is the important one.** Everything else on this page is a detail beside it.

**B1 — a normal card copy at 1.5x or 2x**
- **Do:** set the size, then run a normal card copy end to end — stage a source and a destination,
  start it, let it finish, and read the result.
- **Expect:** every label you need is readable, every control you need is reachable, and the copy
  behaves exactly as it does at 1x.
- **Evidence:** the receipt and session log should be indistinguishable from a 1x run. If they
  differ at all, that is a serious finding — this release should not have touched them.
- Result: ☐ P ☐ F ☐ S

**B2 — the pre-copy review**
- **Do:** at **2x**, start a copy and read the review before continuing.
- **Expect:** nothing cut off; every destination card readable; `Continue` and `Cancel` both
  present and working.
- **Why it is called out:** it is a macOS alert rather than an ordinary window, and it was the one
  surface that ignored the setting entirely until build 23. It is the most likely thing on this
  page to still be wrong.
- Result: ☐ P ☐ F ☐ S

**B3 — the queue and live progress**
- **Do:** at **2x**, watch a copy run.
- **Expect:** file names, percentages, speed, time remaining and the per-destination rows all
  readable and not overlapping. The activity list should scroll rather than spill.
- **Why it is called out:** the densest text in the app, and it was not exercised before release.
- Result: ☐ P ☐ F ☐ S

**B4 — the end of the job**
- **Do:** at **2x**, read Review Summary and open the receipt.
- **Expect:** the card verdict, Session Health and any Source Provenance card all readable.
- Result: ☐ P ☐ F ☐ S

---

## C. The rest of the app at 2x

**C1 — every Settings tab**
- **Do:** at **2x**, open Settings and visit Card Copy, Folder Copy, Post-Copy, P5 Archive,
  External Codecs, Notifications, Appearance and Test.
- **Expect:** nothing cut off, overlapping, or hidden behind another control.
- **Known and not a defect:** the tab strip across the top does not grow. macOS draws it.
- Result: ☐ P ☐ F ☐ S

**C2 — Help**
- **Do:** at **2x**, open `Help ▸ CopyTrust Help` and click through every topic.
- **Expect:** the topic list down the left reads in full — `Troubleshooting` on one line, not two —
  and the new `Interface Size` topic is present.
- Result: ☐ P ☐ F ☐ S

**C3 — About, and the panels**
- **Do:** at **2x**, open `CopyTrust ▸ About CopyTrust`, then the What's New panel, then the preset
  wizard (`Preset ▸ Build…`).
- **Expect:** each sizes itself to its text rather than clipping it.
- Result: ☐ P ☐ F ☐ S

**C4 — Available Volumes**
- **Do:** at **2x**, expand Available Volumes.
- **Expect:** each tile reads `Source` and `Dest` in full — not `S…` and `D…` — and volume names
  are not cut short.
- Result: ☐ P ☐ F ☐ S

**C5 — the destinations panel on a smaller screen**
- **Do:** at **2x**, make the window narrow, or run on a laptop display.
- **Expect:** the controls on a destination row move onto their own line beneath the name and path.
  They must not overlap the Sources column or spill outside the panel.
- **Why:** where the window can grow the rows stay on one line; where it cannot, the layout is
  meant to reflow instead. Both are correct; overlapping is not.
- Result: ☐ P ☐ F ☐ S

---

## D. The window itself

**D1 — the window grows with the setting**
- **Do:** note the window size, then raise the setting.
- **Expect:** the window grows by the same ratio, clamped to the screen. Doubling the text in a
  window that stays put would only mean less fits.
- Result: ☐ P ☐ F ☐ S

**D2 — and comes back**
- **Do:** go up to 2x and back to 1x.
- **Expect:** the window returns to roughly where it started rather than shrinking a little each
  time.
- Result: ☐ P ☐ F ☐ S

**D3 — the saved window is not lost**
- **Do:** position and size the window deliberately, quit, relaunch.
- **Expect:** it comes back where you left it, and at the size you left it.
- **Why it is called out:** an early version of this work silently discarded every saved window
  frame. It is fixed, and it is exactly the kind of thing that would go unnoticed.
- Result: ☐ P ☐ F ☐ S

**D4 — a manual resize then a size change**
- **Do:** drag the window to a new size by hand, then change Interface Size.
- **Expect:** it scales from the window's *original* size, so it will jump. **Known limit, not a
  defect.** Relaunching settles it. Report it only if it does something worse than jump.
- Result: ☐ P ☐ F ☐ S

---

## E. Where the setting lives

**E1 — it is remembered**
- **Do:** set 1.5x, quit, relaunch.
- **Expect:** still 1.5x.
- Result: ☐ P ☐ F ☐ S

**E2 — a preset never changes it**
- **Do:** at **2x**, load a preset. Then load one on a Mac set to 1x.
- **Expect:** the size does not move in either case. Interface size is a personal accessibility
  preference belonging to the Mac, and is deliberately never written into an operator or
  destination preset.
- **Why it matters:** if a preset could carry it, one operator's choice would be imposed on
  everyone the preset is deployed to.
- Result: ☐ P ☐ F ☐ S

**E3 — changing size mid-copy**
- **Do:** start a copy, change size while it runs.
- **Expect:** the copy carries on untouched and the window does not lose the running operation.
- Result: ☐ P ☐ F ☐ S

---

## F. 1x must be unchanged

**F1 — nothing moved at Standard**
- **Do:** at 1x, compare against 2.8.1 build 21 — same window size, same session.
- **Expect:** identical. Anything that moved, resized or re-wrapped at Standard is a fault, not a
  feature. Most operators will never change this setting and must not notice the release.
- Result: ☐ P ☐ F ☐ S

---

## Known limits — not defects

- **The tab strip along the top of Settings does not grow.** macOS draws it.
- **The update alert does not grow.** `CopyTrust ▸ Check for Updates…` is a plain system alert
  raised by shared code, with no part of it under this app's control.
- **Resizing by hand and then changing size jumps**, because the scale is applied to the window's
  original size. Relaunching settles it.
- **Control chrome stops growing before the text does.** macOS offers four control sizes; past
  that, buttons stay put while their labels keep growing.
- **Only CopyTrust is migrated.** Drop Verify and Folder Copy Compare are untouched.

---

## What to send back

- This page, marked up.
- The session log and receipt from at least one full copy run at 1.5x or 2x.
- A screenshot of anything cut off, overlapping or unreadable, with the size it happened at and
  the display you were on.
- Whether you would actually use it — and at which size. A setting nobody reaches for is worth
  knowing about too.
