# Daily Workflow — With Enforced Naming

**For:** an operator ingesting cards at a facility whose naming convention CopyTrust applies.<br>
**Version:** current for CopyTrust 3.0.4 build 75

This is the running order for a shift. For the complete reference, see the
[CopyTrust User Guide](CopyTrust_UserGuide.md#enforced-naming-preset-activated) and **Help** inside
the app.

If the facility uses Project Folder Creator, create the new project on the required storages before
the cards arrive. Project Folder Creator duplicates the approved template; CopyTrust then discovers
and files cards into those prepared project folders. See the
[Project Folder Creator Quick Start](../project-folder-creator/ProjectFolderCreator_QuickStart.md).

If nobody has set the CopyTrust convention up yet, that is a separate setup task: choose
`Preset ▸ Build an Enforced Naming Preset…` once with the facility present. **Stage the
destinations first** — including a proxies-only destination, if used — because the wizard captures
the destinations staged when the preset is saved. Its final step lists exactly what it will carry.

---

## 1 · Confirm the preset

Open CopyTrust. Do not assume that the expected convention is loaded: a convention stays in force
across quits and may belong to an earlier job.

Three places agree when a preset is loaded, and all three name it:

- the **Preset** button in the toolbar shows the preset's name, not the word *Preset*;
- its row in the preset menu is ticked and marked **(loaded)**; and
- the Destinations panel says **Delivery folder set by "<name>"** in orange.

If the button reads **Preset**, load the intended preset. If it shows a name with a **•**, a setting
has changed since the preset was loaded; either update the preset from the current settings or load
it again to discard the change.

> A blue note instead of the orange one — *the project list is read from these destinations* —
> means naming is on but placement is off. Cards will be named correctly and land wherever they are
> staged. If the facility expects project placement, edit the preset and enable **Put the card
> inside its project folder**.

---

## 2 · Resolve destinations: on site or off site

**On site.** The preset carries its destinations. Mounted destinations stage themselves when the
preset loads and are named in the confirmation before it applies. Check that every expected row is
present, has the intended copy/proxy/P5 role and has enough room.

If a volume is missing, CopyTrust names it in **Expected volumes are not available** and asks
whether the operator is off site:

| Button | Use it when |
|---|---|
| **Try Again** | The share has just been mounted or is about to be mounted |
| **Open SMB Connect** | The share is missing and should be requested now; CopyTrust waits for it and names the volume being requested |
| **Off Site** | Facility storage is intentionally unavailable and the card should go to the drive that is present |

CopyTrust does not mount a share or hold its credentials. It hands the request to SMB Connect and
reports whether the volume appeared.

**Off site.** Choose **Off Site** and select the drive that is present. The naming convention still
applies on that drive. If the preset permits project creation, the pre-copy review lists the folders
that will be made. Follow the complete [CopyTrust Off-Site Workflow](CopyTrust_OffSite_Workflow.md)
for the location copy and the later facility ingest.

---

## 3 · Confirm the project list and landing path

Stage a card. The naming sheet opens as it is added: project, unit, roll, location and date, with a
landing preview. **Add Source** remains unavailable until required naming is valid, and **Cancel**
removes the card. Cards added together are named one after another.

Before trusting the project picker, use **Show project list…** on the Destinations panel. It lists
the projects found on every destination, the storage that could not be read and anything skipped as
a template.

Then use **Check delivery folder…** on a destination row. It lists every staged card against every
destination, including where proxies will be made and delivered. Read it before every job.

The normal prepared-project case reads:

> *project folder found · N folders to create inside it*

*project folder will be created* may be correct for a new destination, but can also mean the
convention's expected storage shape does not match the mounted volume. Stop and confirm it rather
than guessing. **Correct a Folder…** records an operator-selected path for that card and destination.

---

## 4 · Confirm proxy and P5 roles

These are per-destination choices:

- **Create proxies** — enable on the edit storage that should perform proxy generation. Proxy media
  must also be enabled in Settings.
- **Send proxies to another destination…** — use when a destination receives proxies but no
  originals. Its path is resolved through that volume's own project structure.
- **Archive to P5** — enable on the archive source destination. Automatic submission requires Full
  or Inline verification because those modes produce the hashes supplied to P5. Quick and
  copy-only jobs are deferred.

Read the pre-copy review before continuing. It shows the job topology and one destination card per
copy path, including verification, sorting, proxy and P5 choices.

---

## 5 · Choose the copy strategy

### Several cards to the same destinations

Stage and name all cards that are available. Leave `Copy` on **Simultaneously**. CopyTrust copies
the sources **one after another**, and each active source goes directly to every selected
destination. *Simultaneously* describes the destinations for the active card; it does not read
several cards concurrently.

With auto-advance enabled, the next named card starts after the current card's
copy-and-verification gate. A destination without enough room is skipped for that card as a whole,
never partly written, and the copy map records what is still owed.

### Fast destination first

When the card must be freed before a slower network destination finishes, stage **one card**, put
the fast internal flash, SSD or RAID first, put the NAS second, and set `Copy` to **In series**. The
preview should read:

```text
Card → Fast storage → NAS
```

CopyTrust copies and verifies the card at Stop 1. Stop 2 then reads that verified output instead of
the card. CopyTrust may offer **Move to Stop 1** when its speed history or connection evidence shows
that a later stop is clearly faster.

One source makes one relay chain. Queue a separate chain for each additional card taking the same
path. See the [CopyTrust Workflow Guide](CopyTrust_WorkflowGuide.md#relay-chain) for the complete
relay strategy and evidence.

---

## 6 · Keep the card readers moving

A completed card remains in **Completed This Run / Completed Sources** with its verdict. When it
says **copied & verified / Ready to eject** and the required verified-copy count is met, use
**Eject** there or enable **Auto-eject completed source cards**.

Remove the card only after macOS reports a successful eject. Insert the next card in that reader,
then add it with:

- the queue's **+ Add** button;
- the drop strip beneath the running copy; or
- **Source** on the card's Volumes tile.

The enforced-naming sheet opens for the replacement card before it can start. A card added for the
same destinations joins the run and auto-advances. Proxies, reports or P5 still active for an
earlier card do not hold its copy. A card for different destinations remains a separate queued
batch.

The earlier card's verdict, receipt and copy-map evidence stay in the session after the physical
card is removed. **Clear Done** removes completed queue rows from the display; it is not the trust
decision that makes a card safe to eject.

---

## 7 · Before releasing or wiping a card

Confirm all of the following:

- Session Health is clean on every required destination: `errors=0 mismatches=0`.
- The delivered folder is where the landing preview said it would be.
- The copy map shows the required verified-copy count and names anything still owed.
- Full and Inline jobs have their expected MHL; Quick intentionally has no content-hash MHL.
- A `Receipts` folder is present inside the delivery on every destination that received the card.
- Proxy and P5 status is understood separately from the verified-original copy result.

The JSON receipt records the project, unit, roll, whether the roll was proposed or typed, the
preset that imposed the convention and the delivered folder on each destination. Keep it with the
media evidence.

---

## If something looks wrong

| What you see | What it usually means |
|---|---|
| Picker says to add a destination | The project list is read from the destinations; none is staged yet |
| Project missing from the picker | Use **Show project list…** to distinguish missing, unreadable and template folders |
| Card landed at the top of the drive | Placement is off even though naming is on |
| Folder is named correctly but is in the wrong place | Confirm placement and the preset's storage shape |
| `UnknownRoll` appears in a folder name | The roll was deliberately recorded as unknown; it remains findable |
| Two folder names claim the same project | CopyTrust stops and asks rather than choosing silently |
| A replacement card does not start | Read the blocking reason; proxies, reports and P5 from the earlier card should not hold it |

Every required naming field has an explicit way through, including **Unknown**. An incomplete card
should still be named, copied and findable rather than silently omitted.
