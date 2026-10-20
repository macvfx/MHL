# CopyTrust 3.0.1 Build 54 — beta

2026-10-19 · CopyTrust only. Drop Verify is at 3.0.1 build 52 and Folder Copy Compare at 3.0.1 build 53. It
includes everything in CopyTrust 3.0.1 build 51 — see [RELEASE-NOTES-3.0.1.md](RELEASE-NOTES-3.0.1.md).

Two changes from operators on site.

- **No Eject beside a volume that is copying.** The Volumes strip showed an eject icon beside every volume
  that could be ejected at all, including a card that was copying; pressing it was refused, but the icon
  invited the press. It is now hidden for a card that is copying or verifying, for a destination of the
  copy in progress, and for a volume with proxies or reports still being written to it, and comes back when
  that ends. A card that has not started, or a finished one with a warning, still shows Eject and asks first.
  Nothing is ever ejected during a copy.
- **A quiet spell is not an alarm.** After 30 seconds with no update the progress line turned orange with a
  warning triangle and read "no new data". On a healthy copy of a large file that frightened people. The
  line now stays grey. While a file is being checked it says **Verifying <file>**, however long it is quiet.
  While copying it adds the time of the last update in lighter type, for example "last update 14:02:11". The
  gap is written to the session log when updates resume. A copy that has really failed, for example on a
  volume that went away, is still reported by the copy itself.

Test: start a copy of a large file with inline verification and look at the Volumes strip (no Eject on the
card, or on a destination) and at the line beside the spinner (grey; "Verifying" while the file is checked).
When the card finishes, Eject returns on it.
