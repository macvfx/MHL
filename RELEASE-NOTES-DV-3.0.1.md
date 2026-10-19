# Drop Verify 3.0.1 Build 52 — beta

2026-10-19 · Drop Verify only. CopyTrust is at 3.0.1 build 51 and Folder Copy Compare stays at 3.0 build 50.
It includes everything in Drop Verify 3.0 build 50.

- **Remote notifications.** *Settings ▸ Notifications* sends a push to your phone (Pushover) or a JSON
  webhook when a folder has been processed, or when Drop Verify stops before finishing. It is **off until
  you turn it on**. The message carries a fixed sentence and counts, and an optional station name you
  choose — never a folder, project or file name, and never a path. It says *finished with problems* when an
  output (contact sheet, CSV, HTML tree, proxies) failed, because a failed output does not stop the run.
- A small folder does not send a push a few seconds after you drop it: *finished* is sent only if the run
  took at least 30 seconds (you can change this, or set 0 to always send). A failure is always sent, and
  cancelling a run yourself sends nothing.
- The Pushover token and user key, or the webhook URL, are kept in the Keychain, separate from
  CopyTrust's, so setting up one app does not change the other. *Save and send test* checks the setup.
- Includes the fix from CopyTrust 3.0.1: a SAN or network volume that stops answering is listed as
  *Not responding* instead of freezing the window.
- Drop Verify does not send live progress to a CopyTrust Monitor. That stays with CopyTrust.

Test: switch it on with a Pushover account or a webhook you control, press *Save and send test*, then drop a
folder that takes more than 30 seconds and one that fails (for example, an export folder you cannot write to).
