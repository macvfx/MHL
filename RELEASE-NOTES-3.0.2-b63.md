# 3.0.2 Build 63 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-10-21 · One release carries three apps, all at 3.0.2 build 63, so each app's update check sees one version. Each app is its own
`.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. It includes everything in 3.0.1 build 60 — see
[RELEASE-NOTES-3.0.1-b60.md](RELEASE-NOTES-3.0.1-b60.md).

**CopyTrust, for laptops in the field**

- **A power chip.** On a Mac with a battery, a small chip at the right of the bottom bar shows where the power comes from: a plug and the
  charge when plugged in, or the charge and macOS's time left on battery. It turns orange when the queued copies need nearly all of the battery
  and red, with "plug in", when they will not last, and a banner appears for those two. The estimate compares the battery with the time the
  queue still needs; before a copy starts that is a rough figure from earlier copies. Nothing is ever stopped or blocked. The session log records
  the power source, each change, and a line every five minutes during a copy.
- **How each drive is connected.** Every source and destination row shows its connection: USB 10 Gbps, USB 5 Gbps, USB 2.0, Network or Internal.
  A drive or card reader on a USB 2 link is flagged in orange with what to try, because it will copy at about 40 MB/s whatever the drive can do. The
  connection is saved with each speed in the device speed history, so it is possible to see afterwards whether a port changed a drive's speed.
- **Fastest drive first.** Copying In series, the card is free once Stop 1 is verified. When a later stop is clearly faster than Stop 1, a line says
  so and **Move to Stop 1** applies it. It says nothing about a drive it has no record of.

**CopyTrust, when a copy is stopped**

- **A cancelled copy at Quick now resumes.** It used to start again from the first file, because nothing is verified one file at a time at Quick. A
  resume now keeps the files that finished and still match in size and date, and copies the rest. A half-written, touched or changed file is
  copied again.
- **Cancel Copy asks first,** and says what is kept.
- **A resume checks the destination.** A file the earlier run verified is counted as done only if it is still on the destination at the recorded size.

If CopyTrust itself stops, for a crash or a flat battery, there is still no record to resume from and the card is copied again.

**Drop Verify and Folder Copy Compare** carry the shared version and have no other change.

Test: unplug a laptop and watch the chip; stage a drive on a USB 2 port; at Quick, stop a copy part way and start the same card again.
