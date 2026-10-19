# CopyTrust, Drop Verify and Folder Copy Compare 2.9.9 Build 49 — beta

2026-10-16 · All three apps share this version. CopyTrust carries the changes. It includes
everything in 2.9.8 build 48 — see [RELEASE-NOTES-2.9.8.md](RELEASE-NOTES-2.9.8.md).

Found after a large on-site copy of many cards to several drives, with proxies sent to a cloud
volume: the cloud volume had no Final Cut relink aliases and fewer proxies than the edit volume,
and nothing said so until a remote editor tried to relink.

- **Relink aliases on the receiving drive.** Proxies delivered to a proxies-only drive now get a
  *Final Cut Relink Aliases* folder there, beside the delivered proxies and pointing at them. Before,
  the aliases existed only beside the edit copy and resolved to that drive.
- **A delivery that comes up short says so.** After each proxy delivery the proxies are checked
  against the receiving drive by name and size. A shortfall fails the Proxy Delivery row and names the
  missing files, instead of the run looking complete.
- **Proxy deliveries run one at a time**, and a proxy still being encoded (`.partial.mov`) is never
  sent. Each card's delivery copies the whole proxy folder, and two running together could read
  another card's proxy mid-encode. This is the likely cause of the partial file, inferred from the
  code and not reproduced.
- The version moves to 2.9.9, not just the build, so deployment tools that compare the version see an
  update.

**To test.** Copy several cards to an edit drive and a proxies-only drive. The proxies-only drive should
hold the same number of proxies as the edit drive, plus a *Final Cut Relink Aliases* folder, and Final
Cut Pro should relink from it in one pass (Relink Files > Proxy Media > Locate All).

> **2.9 is a beta.** Test it on media you can afford to lose, and keep a separate, verified backup.
