# Locking a preset in with MDM

**For the person who deploys CopyTrust, not the operator.** Introduced in 2.7.8.3 build 10.

A preset is a facility's whole configuration: the naming convention, what each destination is for,
the P5 server, and every copy setting. Once one has been tested and agreed, the question is how to
hold every Mac on it — and how to keep changing it while that testing is still going on.

---

## The split that makes this workable

Two things are deployed, by two different routes, and they change at different rates.

| | What it is | How it gets there | How often it changes |
|---|---|---|---|
| **Which preset** | A name, in a configuration profile | MDM | Once, at the end of testing |
| **The preset itself** | `<name>.json` in `/Users/Shared/CopyTrust/Presets` | Munki, a script, an imaging step | As often as testing needs |

**The profile pins a name, never the preset's content.** That is the whole point. If the profile
carried the convention, every changed folder template during a testing period would mean editing
the profile, re-signing it, pushing it, and waiting for each Mac to pick it up — hours, for a
one-line change. Because it pins only a name, a new convention is a new `.json` through the
channel you already use for the app itself, and the profile is written once.

CopyTrust watches `/Users/Shared/CopyTrust/Presets`. A preset replaced there is **in force within
a second or two, on a running app** — no relaunch, no profile change, nothing for the operator to
do. That is what makes it practical to iterate on a convention while people are using it.

A name rather than an id, because an id is stable when a preset is edited in place and different
when one is rebuilt from scratch on another Mac. A facility pinning `House Card Ingest` means the
preset by that name, whatever its history.

---

## The keys

Domain: `com.copytrust.app`

| Key | Type | Value |
|---|---|---|
| `CopyTrustEnforcedPresetName` | String | The preset's name, exactly as it appears in the app |
| `CopyTrustPresetEnforcementMode` | String | `enforce` (default) or `seed` |

**`enforce`** — applied at every launch, applied again whenever the preset file is replaced, and
the preset menu is locked: no loading another preset, no editing, no importing, no saving. This is
"locked in".

**`seed`** — applied once, on a Mac that has never loaded a preset, then left alone. For setting a
machine up rather than holding it there.

A missing or misspelled mode **enforces**. A preset applied when it should not have been is visible
and reversible; one silently not applied is neither, and looks exactly like a profile that has not
arrived yet.

### A profile you can install today

**[`examples/CopyTrust-Enforced-Preset.mobileconfig`](examples/CopyTrust-Enforced-Preset.mobileconfig)**
is a complete, unsigned profile. Change two things and it is ready:

1. `CopyTrustEnforcedPresetName` — the preset's name, exactly as the app shows it and exactly as the
   `.json` in the house folder carries it.
2. `PayloadIdentifier` and `PayloadOrganization` — `ca.example.copytrust` is a placeholder. Use your
   own reverse-DNS identifier, because the identifier is what an MDM replaces on update; two
   profiles sharing one identifier overwrite each other.

Its shape, for a profile you write yourself:

```xml
<key>PayloadType</key>
<string>com.copytrust.app</string>
<key>PayloadIdentifier</key>
<string>ca.example.copytrust.preset</string>
<key>CopyTrustEnforcedPresetName</key>
<string>House Card Ingest</string>
<key>CopyTrustPresetEnforcementMode</key>
<string>enforce</string>
```

The payload type **is** the app's preference domain. Everything in that dict other than the
`Payload*` keys is delivered into `com.copytrust.app` as a *forced* value, which is what makes the
app report it as managed rather than local.

`PayloadScope` is `System`, so the policy applies to every account on a shared facility Mac.

**Installing it by hand to test.** Since macOS 11 a profile cannot be installed from the command
line — `profiles install` is refused for this. Double-click the `.mobileconfig`, then approve it in
**System Settings ▸ General ▸ VPN & Device Management** (Ventura and later; **Privacy & Security ▸
Profiles** on Monterey). Pushed by an MDM it installs silently, as normal.

The example ships with `PayloadRemovalDisallowed` set to `false` so you can remove it again from
that same pane. Set it to `true` for a real deployment.

**How to know it worked:** open the Preset menu. A profile-delivered value reads *managed by your
organisation*. If it still says *pinned locally for testing*, the profile has not taken effect —
that is exactly what the distinction is for.

---

## Testing it without pushing a profile

Both routes are read, deliberately. An enforced preset that can only be tested by pushing a profile
cannot be tested at a desk, and "it did not apply" would be indistinguishable from "the profile has
not arrived yet".

```bash
defaults write com.copytrust.app CopyTrustEnforcedPresetName -string "House Card Ingest"
defaults write com.copytrust.app CopyTrustPresetEnforcementMode -string "enforce"
```

Relaunch CopyTrust, or just switch away and back — the policy is re-read when the app becomes
active.

**The app tells you which it is.** The line at the top of the Preset menu reads *managed by your
organisation* for a configuration profile and *pinned locally for testing* for a `defaults write`.
If you are testing a profile and it says "pinned locally", the profile has not landed.

To undo a local test:

```bash
defaults delete com.copytrust.app CopyTrustEnforcedPresetName
defaults delete com.copytrust.app CopyTrustPresetEnforcementMode
```

A profile-delivered value cannot be removed this way, which is the point of a profile.

---

## What an operator sees under `enforce`

- The Preset button carries a **lock** and the preset's name.
- The menu opens with one line: *"House Card Ingest" is enforced — managed by your organisation*.
- Build, Edit, Import, Save, Update, Load, Rename, Delete and Duplicate are gone.
- **Export** and **Save Report…** remain. Reading out what is in force is never what a lock is
  protecting against, and the report is how a facility proves what a job was copied under.

If the named preset is not on the Mac, the menu says so and names the folder to deploy it to. The
app does not fall back to something else.

---

## What this does not lock

**Individual settings in the Settings window.** Enforce fixes *which preset is in force*, not every
control in the app. An operator can still change verification level or turn a contact sheet off;
the Preset button shows the modified dot, and the preset is applied again at the next launch or the
next time it is redeployed.

Reverting a setting the moment it changed would fight an operator mid-keystroke, and the honest
position is the narrower claim. If a particular setting genuinely must not move, say which and it
can be handled on its own terms.

**The `.json` in the house folder.** It is world-readable by design — every user on the Mac needs
it. Nothing secret is in it: the P5 server travels, the P5 *password* does not and cannot.

---

## Rollout order

1. Build the preset on one Mac and test it. Export it with **Save Report… ▸ All three, and the
   preset (.json)** — that folder is the agreed configuration plus the documents describing it.
2. Deploy the `.json` to `/Users/Shared/CopyTrust/Presets` on the test Macs. Nothing is enforced
   yet; operators load it themselves.
3. Iterate. Replace the `.json` as often as needed — running apps pick it up.
4. When it is agreed, push the profile with `CopyTrustEnforcedPresetName`.
5. Changing the convention after that is still step 3. The profile does not change again unless the
   preset is **renamed**.

**Renaming a pinned preset breaks the pin**, because the pin is the name. Deploy the new file, push
the updated profile, then remove the old file — in that order, so no Mac is ever between the two.
