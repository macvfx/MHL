# CopyTrust 2.8.4 Build 25 — beta

2026-09-21 · CopyTrust only. Drop Verify and Folder Copy Compare are unchanged at 2.8.1 build 21.
Everything in 2.8.3 build 24 and 2.8.2 build 23 is included unchanged.

BETA. Test on media you can afford to lose, and keep a separate verified backup made by other
software — Archiware P5 or equivalent.

## Folder mode lets go of an enforced preset's card setup

Folder mode is not enforced, but until this build everything an enforced naming preset set up for
card ingest followed the operator into it when they switched from Card to Folder. Found in on-site
testing. Switching to Folder with an enforced naming preset loaded now:

- **removes the preset's destinations**, including a proxies-only destination such as a cloud
  share, and forgets preset drives that have not mounted yet, so they no longer add themselves
  later;
- **keeps destinations you added yourself**, with **Create proxies** and **Archive to P5** cleared;
- **turns Inline verification into Quick**, the Folder default — Full and None are left as set —
  and **switches proxy generation off**.

Switching back to Card restores the preset's settings but does not re-stage its destinations; load
the preset again for those.

## Proxies follow the mode

A destination added in a mode that makes no proxies — a folder picked from Available Volumes in
Folder mode, for example — is no longer ticked for proxies. The **Create proxies** box is greyed
out while proxy generation is off, the way **Archive to P5** already is while P5 is off.

## Why Folder mode had Card settings

**Add Batch** offers either mode but always took the settings of the mode that was active. A batch
queued as Folder from Card mode therefore ran with Inline hashing and proxies, and those were then
saved as the Folder settings — and captured by every preset built afterwards. Add Batch now uses
the settings of the mode you pick.

**A preset saved before this build may still carry Card settings for Folder mode.** To repair one:
load it, switch to Folder once, check Settings ▸ Folder (auto-advance is not reset automatically),
then choose **Update … from Current Settings** in the Preset menu.

## Menu bar icon

The menu bar icon is now a folder with an arrow, filled while a copy runs. It used to be the same
icon as FCP Backup Manager's.

## What to test

1. Load your enforced naming preset, let its destinations stage, then switch to Folder. The
   preset's destinations, the proxies-only one included, should disappear.
2. Add a destination by hand in Card mode, tick Create proxies and Archive to P5, then switch to
   Folder. It should stay, with both unticked.
3. After switching, Settings ▸ Folder should show Quick verification and proxies off.
4. In Folder mode, add a folder from Available Volumes: Create proxies should be unticked and
   greyed out.
5. Check the new menu bar icon, idle and during a copy.
