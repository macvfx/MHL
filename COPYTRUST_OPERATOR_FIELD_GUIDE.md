# CopyTrust — Operator Field Guide

A short, field-facing summary of what CopyTrust does and how to confirm a copy is
trustworthy on set or in the office. For the full walkthrough see
[CopyTrust_UserGuide.md](CopyTrust_UserGuide.md); for relay strategy see
[CopyTrust_WorkflowGuide.md](CopyTrust_WorkflowGuide.md).

Stable release: **2.5.3** (includes the 2.5.2 sorted-copy MHL verification fix +
provenance and native HTML trees). **2.5.4 Build 6** is in testing; it restores
post-copy artifacts after Quick verification and includes the contact-sheet
reliability work — see [RELEASE_NOTES.md](RELEASE_NOTES.md).

---

## What CopyTrust does

Camera-card ingest with a selectable verification chain: use **Full or Inline** for
hash verification plus an industry-standard MHL, or **Quick** for destination
existence and size verification without hashes.

| Capability | What it gives the operator |
|---|---|
| Multi-source, multi-destination copy | Offload several cards to several drives in one pass |
| Queued / walk-away sessions | Stage cards and destinations, start, walk away, return to verified results |
| Per-destination preflight | Free space, write permission, and reachability checked before copy |
| Verification levels | **None / Quick** (size) **/ Full** (xxHash64) / **Inline** (hash during copy) |
| MHL generation | MHL v1.1 written per destination in Full/Inline modes; Quick has no content hashes and intentionally writes no MHL. Reads classic v1.x **and ASC MHL v2.0** |
| Relay chain (`A → B → C`) | Fast first copy (card → SSD), then downstream copy (SSD → NAS) from the verified local copy — frees the card sooner |
| Resumable ingest | Cancelled or partially-failed runs resume without recopying verified files |
| Destination Sort (optional) | Reorganizes the copy into type folders (JPG / RAW / Video / …) **after** the trust chain is sealed |
| Receipts & artifacts | JSON + TXT receipts, per-copy log, session manifest, optional contact-sheet PDF, EXIF CSV, HTML directory tree |
| Provenance (2.5.2) | `PROVENANCE_*.json` records the settings used and the source→destination file mapping |
| Safe-to-eject + auto-eject | Eject is gated on the selected copy/verification workflow completing; Full/Inline also require their MHL |

---

## Field test — confirm a copy in 2 minutes

After a **Full or Inline** copy completes, on the destination drive:

1. **Media is there** — the subfolder (e.g. `A001_2026-06-14`) holds your files and they open.
2. **One MHL at the root** — exactly one `*.mhl` in the destination subfolder root.
3. **Receipts folder** — `CopyTrust_Receipts/` contains:
   - `ingest_*.log` (per-copy log with a header: app/build, macOS, host, session tag, source)
   - `ingest_*.json` + `ingest_*.txt` (receipt)
   - `SESSION_MANIFEST_*.json`
   - `PROVENANCE_*.json` (2.5.2)
4. **Verify it** — drag the `.mhl` back into CopyTrust (or verify with **MHL Verify**); it should report **all files matched**, 0 missing.
5. **Health verdict** — the Session Summary shows a green/clean health verdict (or clearly-labelled warnings).

If verification reports files missing on a copy you believe is good, and **Destination
Sort was on**, you are on a build older than 2.5.2 — update. 2.5.2 verifies against the
delivered (sorted) layout.

For a Quick copy, confirm the files, clean Session Health result, receipt/log, and
enabled descriptive artifacts. No MHL is expected because Quick does not calculate
content hashes.

---

## Pre-shoot smoke test (optional)

Before relying on a new build or a new machine:

- Copy one small card to two destinations (one APFS, one exFAT) with **Full** verification.
- Confirm all five receipt files above appear on **both** destinations (exFAT included).
- Cancel a copy mid-run, then **Resume** — verified files are reused, not recopied.
- Queue a relay chain (`card → SSD → NAS`) and confirm both legs copy and verify.

---

## Artifact test (contact sheet PDF / EXIF CSV / HTML tree)

Artifacts are optional and some depend on external command-line tools. Verify they
generate before relying on them on a job.

1. **Install the helper tools you need** (Homebrew, or point CopyTrust at them in
   Settings):
   - `exiftool` — richer EXIF metadata for the CSV and pro/unsupported formats
   - `ffmpeg` — contact-sheet thumbnails for MXF and **any file extension you add that ffmpeg can decode** (the `Settings > External Codecs` ffmpeg panel has an editable File extensions list — defaults include `mxf`, `m2v`, `m2ts`; add others such as DJI `lrf` low-res files)
   - `redline` (REDline) — contact-sheet thumbnails for R3D
   - HTML tree output is native; no external `tree` command is required
   *(Install only what your media needs — e.g. REDline only for RED jobs.)*
2. **Configure the artifact options** in `Settings > Post-Copy` (per Card / Folder
   mode): enable Contact sheet PDF, EXIF CSV, and/or HTML directory tree, choose Project summary index, One HTML per top-level folder, or Entire project, and under
   `Settings > External Codecs` enable ExifTool / external thumbnail codecs and
   `Auto-Detect` (or `Browse…`) each tool.
3. **Run a Folder-mode copy with Quick verification** and let its copy + size check finish.
4. **Confirm the artifacts appear** in the destination (and `CopyTrust_Receipts/`):
   - Contact sheet **PDF** — and that it **auto-opens** when configured to
   - EXIF **CSV**
   - **HTML** directory tree
   - Pro-format thumbnails render (not placeholders) for MXF, R3D, and any
     extension you've added to ffmpeg's list (e.g. DJI `lrf`) when the matching
     tool is enabled.
5. **Confirm all three artifact rows stop** at done, failed, skipped, or
   **Nothing to do** — no row should spin after the artifact task finishes.
6. Repeat with Full or Inline verification and confirm the normal hash-backed MHL
   is also present.

Artifacts run as background work after the selected verification is sealed, so a
missing or failed descriptive artifact never invalidates the copy. Build 6 uses a
delivered-file inventory for these artifacts; Quick mode still does not invent hashes.

---

## Known issues — Destination Sort only

These affect the optional **sort** step. The copy / verify / MHL trust chain is never
affected — your integrity proof is valid in every case.

1. **Relay chains sort only the final destination** *(known limitation, for now).*
   With a relay-chain queue and sort enabled, intermediate destinations keep their
   original layout. If you need every copy sorted, use a non-relay multi-destination
   session (each destination sorts independently).
2. **A destination disconnect *during* the sort can re-run it** *(bug).* If a drive
   drops while files are being sorted and you reconnect it, the sort may re-run over a
   partially-sorted folder (Flatten mode can create `…_2` duplicates). Workaround:
   don't unplug the destination until the post-copy sort/artifact step reports complete.

See the User Guide → **Destination Sort → Known Issues** for detail.
