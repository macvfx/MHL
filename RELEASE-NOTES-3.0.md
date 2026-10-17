# CopyTrust, Drop Verify and Folder Copy Compare 3.0 Build 50 — beta

2026-10-17 · All three apps share this version. CopyTrust carries the changes; Drop Verify and Folder
Copy Compare move with it and have none of their own. It includes everything in 2.9.9 build 49 — see
[RELEASE-NOTES-2.9.9.md](RELEASE-NOTES-2.9.9.md).

Written for an office where people away from the ingest Mac need to know what is running, when it
should finish, and whether someone is needed.

- **Live progress to a CopyTrust Monitor.** *Settings ▸ Notifications ▸ CopyTrust Monitor Hub* sends a
  snapshot about every five seconds during a run to a CopyTrust Monitor on your network: the phase,
  percent for the whole run and the current card, bytes, speed, time left, and file-copy and card
  counts. It is **off until you turn it on**, and it sends numbers and a fixed set of words only —
  never a card, project, drive or folder name, and never a path. It has its own link, kept in the
  Keychain, separate from Pushover and the notifications webhook, and can run alongside them. A
  hub that is slow, unreachable or refusing cannot slow or fail a copy. Live progress needs CopyTrust
  Monitor 0.3, a separate menu-bar app that is in private testing and is not part of this download.
- **Waiting for an operator.** The Monitor says when a card stopped and can be resumed, when cards are
  waiting to be named, or when the next card has to be started. It says so only after about 15
  seconds, so a normal auto-advance is not flagged, and a run with a card still to start is never
  reported finished.
- **Background jobs after the copy** (contact sheet, proxies, reports) are counted as "X of Y done"
  with the number of cards ready to eject.
- **Start Next Card.** With auto-advance off, the progress window's button after a card finishes read
  *Add Next Card* and only closed the window. It now reads *Start Next Card* and starts the next one,
  after the usual pre-copy review.
- The hub and notification fields in Settings now have a visible box to paste into.
- The version moves to 3.0, not just the build, so deployment tools that compare the version see an
  update.

**To test.** Connect a Monitor 0.3 (*Live status ▸ Copy Link* into the CopyTrust Monitor Hub section,
*Save and send test status*), copy several cards to two drives and compare the Monitor's percent and
time left with CopyTrust's own; turn auto-advance off and leave the next card unstarted; unplug a
destination mid-copy and resume it.

> **3.0 is a beta.** Test it on media you can afford to lose, and keep a separate, verified backup.
