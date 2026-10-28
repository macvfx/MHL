# 3.0.4 Build 75 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-28 · One release carries three apps, all at 3.0.4 build 75, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. The marketing version moved from 3.0.3 to 3.0.4 with no
functional change of its own — Munki compares that string, not the build number, so a Mac already on 3.0.3 now sees this as an
update. It includes everything in 3.0.3 build 70 — see [RELEASE-NOTES-3.0.3-b70.md](RELEASE-NOTES-3.0.3-b70.md). Builds 71
through 74 were built but never published on their own; everything they contain ships in this one.

**CopyTrust**

- **A proxies-only delivery destination was silently dropped on every queued or relay-chain copy.** Proxies were made
  correctly, but a destination set up to receive proxies only — and nothing else — could end up with nothing delivered to it,
  with no error and no note in the session log saying why. Starting a queued copy now carries that destination across
  correctly, the same way it already carried the regular destinations and sources.
- **A relay chain's Proxies review no longer looks only at the last stop.** Relaying a card through two or more drives, with
  proxies made at an earlier stop, used to report "Proxies: none made" and "not delivered" once the chain moved past that
  stop — even though the proxies really were made. The review now looks across every stop in the chain.
- **A relay chain's later stops now say which drive they are actually copying from.** The header, log and receipts used to
  repeat the original card's name at every stop, which read as copying from the card again; a later stop now names the drive
  it is relaying the already-verified copy from.
- **A destination still waiting on a card's size no longer looks unsure about its own size.** "Size not measured" used to sit
  right beside the destination's free-space figure, reading as if the destination itself were the thing not measured. It now
  just shows the free space until a card's size is known.
- **The What's New panel's highlighted line no longer goes stale.** It kept announcing an older release after two builds had
  shipped past it; it is kept current with each build now.

Test: build a relay chain of two or more drives, put a proxies-only destination in the mix, and check that destination for the
proxies after the run finishes; in the session's Review & Verify, confirm the Proxies section names every stop that actually
made proxies, not just the last one.
