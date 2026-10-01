# CopyTrust 2.9.1 Build 31 — beta

2026-10-01 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.2 build 22.
Includes everything in 2.9.0 build 30 and 2.8.8 build 29, and everything in 2.8.7 build 28 — see
[RELEASE-NOTES-2.8.7.md](RELEASE-NOTES-2.8.7.md). Every change here came from an on-site test with a
client and was tested in local builds first.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## A card with no unit has no roll

A client who files by project alone got a folder ending `_roll` — the empty roll's value was removed
from the folder template but the word written beside it stayed. A roll is a number within one unit,
so with no unit chosen the Roll field is now hidden, nothing asks for one, and the name is just the
project: `2026-014`. Choosing a unit brings the roll back, proposed as usual. For a project-only
convention set Unit to **Suggested** or **Off** in the preset; with it **Required** a unit is still
asked for.

## Renaming is offered only for the units that need it

A preset can now list the units whose files are renamed — normally the drone, whose `DJI_0001.MOV`
restarts every flight. In the preset wizard's Units step, tick **Files need renaming**. The Rename
control then appears only for those units; every other unit keeps its original names. A preset that
ticks none behaves as before. **An existing preset has to be edited once, and redeployed, to use
this.**

## A pre-copy review you can read at a glance

- A one-line banner first: green **Go**, or orange **Check before continuing** with a count. It
  never blocks; Continue is always there.
- Each destination shows its **whole path**, wrapped, below the name.
- A **Proxies-only copy** section lists every proxies-only destination and whether it will receive
  anything. If proxy generation is off, or no copy destination is set to create proxies, it reads
  **Proxies No**, says why, and the review warns **No destination set for proxies** — nothing will
  be made and nothing will be sent.
- While a loaded preset is exactly as it was loaded, the artifacts line says **Per preset** instead
  of listing the contact sheet, CSV and tree the operator did not choose.

The Session Summary has a **Proxies** block: whether proxies were made, on which destination, and
whether they reached the proxies-only destination.

## A preset can reload itself at launch

Two options in the wizard's last step, off unless ticked: **Always reload this preset when the app
launches**, and **Always open in Card (or Folder) mode**. A preset pinned with a configuration
profile is now also applied on every launch; before, it was skipped when it was already loaded, so a
setting changed mid-shoot survived a relaunch. See
[CopyTrust_ManagedPresetDeployment.md](copytrust/CopyTrust_ManagedPresetDeployment.md).

## Also included from 2.8.8

Checking **Archive to P5** while the active mode's verification cannot produce a hash — Folder
mode's Quick default — now asks first: switch to Inline or Full, or cancel. It used to save a request
P5 would never submit.

## What to test

1. Stage a card with no unit under a preset with Roll suggested: no Roll field, and the folder name
   is the project alone.
2. Edit the preset so only Drone is ticked for renaming: the Rename control shows for a Drone card,
   not for ACAM.
3. Proxies on, a proxies-only destination, no copy destination set to create proxies: the review
   warns and shows **Proxies No**. Tick Create proxies and it reads **Yes**.
4. Tick both launch options, switch to Folder mode and change a setting, relaunch: the preset is
   back, in Card mode.
