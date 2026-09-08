# Project Folder Creator Quick Start

Version 0.5.0 build 22. This is the one page that gets a project made; the full document is the
`Project Folder Creator User Guide`, at **Help → Open User Guide** in the app.

> **Development build.** Not released, and not through acceptance on real facility storage.
> Create a project on storage you can throw away before you create one that matters.

## The window it opens in

A new Mac opens in **simple mode**, and so does one that has never been switched out of it. It
asks for a project number and a project name, shows the projects already on the storage, and
shows each storage: whether it is loaded, and how much room is left on it.

Nothing in simple mode can change *what* gets created — no template, no copy rules, no renaming,
no destinations. That is what makes it safe to hand to somebody on their first morning.

The **Simple | Advanced** picker in the header switches between this window and the whole
bench, and the same picker is in the same place in both; View ▸ Advanced (⇧⌘M) does it from the
keyboard. The choice is remembered per Mac.

## If somebody handed you a profile

A profile is the whole set-up under a name — the template, the storage, and which branches of the
template each storage receives. Import it once and the job is two fields.

1. **Profile → Import Profile…** and choose the `.pfcprofile` folder. Once, on this Mac. A Mac
   with nothing set up yet offers this on its opening screen.
2. Type the **project number** (`2026-123`) and the **project name**, or press **Use 2026-124** to
   take the next free number in that year.
3. Check the **storage rows**. A storage that is not loaded says so, in orange, before you create
   anything; a storage that is loaded says what is free of what it holds.
4. **Create Project**, and confirm the paths it lists.
5. Check each destination says **verified**, above the button.

That is the whole daily loop. A profile whose archive drive is not plugged in still loads and
still says so; but every destination in the plan has to be mounted before the run, so mount it —
or remove that card for today and add it back when the drive is there.

## If you are setting it up yourself

Setting up happens in **Advanced**; simple mode has none of these controls on purpose.

1. **Drop the main template** onto *Main template*. It is read, never modified.
2. **Project number and name** — `YYYY-NNN`, and a name. Neither may contain `{ } [ ]`.
3. **Add Edit, Archive, Cloud or Custom Storage…** for each destination, then on each card set:
   - *Projects in* — the relative folder that holds projects, such as `Projects`, or blank if the
     folder you chose is already it;
   - *Arrangement* — projects directly in that folder, or inside a `YYYY` folder.

   The grey path under the card is where the project will really go. Read it.
4. **Edit Copy Rules** on each destination and tick what that storage receives. Edit might take
   the whole template; Archive might take only `1n {project}` and everything under it. Every
   destination needs at least one item.
5. **The pencil** beside any template name that should change — `1n 2026-xxx` becomes
   `1n {project}`. A name in orange is one the app thinks is still a placeholder.
6. **Create Project**, confirm, and check every destination.
7. **Save as Profile…** once it is right, and **Export Profile…** to hand it to somebody else.

## Before you press Create

- The plan panel is the authority, not the cards. Expand **Show the folders this creates**.
- Green preview text is the name that will be written. Orange is a warning to read.
- The button stays disabled while the plan is invalid; the panel says why.
- An existing project number is refused. So is a storage whose volume is not really mounted —
  a folder under `/Volumes` looks identical whether the drive is there or not.

## Afterwards

A receipt — JSON and text — is written to this Mac on every run, at
`~/Library/Application Support/Project Folder Creator/Receipts`. There is nothing to switch on.
**Reveal Receipt** opens it. Set a receipts folder in section 4 if a copy should also land
somewhere the facility can see.

- **Retry Incomplete** replans only what failed and reverifies what already committed.
- **New Project** clears the number and name and keeps everything else.
- A failed destination may leave a hidden staging folder. It is listed with a Reveal button, and
  the app never deletes one — it may be the only record of what the failed copy achieved.

## When something is wrong

| What you see | What it means |
| --- | --- |
| Create is disabled | Read the plan panel; it names the refusal. A receipts folder is not required |
| *not there yet* under a card | The project directory does not exist. Only the year folder is created for you |
| A storage is not mounted | Mount it. The refusal prints the mount table, because a volume's name and the folder it mounts at can differ |
| A name is orange | It still looks like a template placeholder. Use the pencil |
| Unknown token | Fix the brackets, or confirm the name really is a literal folder |
| The project list is incomplete | A destination could not be read. Do not assume a number is free |
| A storage row says *Free space could not be read* | The volume answered neither capacity question. It is not a full disc; check it yourself |
| A storage row says *not there* about a project folder | The storage is loaded but the folder it keeps projects in is missing. It is never created for you |
