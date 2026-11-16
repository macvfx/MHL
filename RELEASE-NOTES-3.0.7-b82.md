# 3.0.7 Build 82 — CopyTrust, Drop Verify and Folder Copy Compare — beta

2026-11-16 · One release carries three apps, all at 3.0.7 build 82, so each app's update check sees one version. Each app is its
own `.dmg` with its own `.sha256.txt`; one more `.dmg` holds all three. It includes everything in 3.0.6 build 81.

**CopyTrust**

## A P5 archive job says what it archived

- **The job description now starts with the full path of the archived folder**:
  `<archived folder path> — CopyTrust verified archive (N files)`. It used to start with the source's name, which
  says which card the footage came from but not where the archived copy lives.
- **Why it matters.** P5 lists an archive submitted this way with no pool and no directories, so the description is
  the one place the job itself says what was archived. It is what P5's job monitor shows, and what
  P5 Archive Overview 2.15 reads in Job Details to fill in the Directories column.
- The path is the folder on the destination that P5 archives, written exactly as it is.
- The source card is still recorded on every archived file as `CT_CARD`.
- A job of one file says "1 file".
- Jobs already submitted keep the description they were submitted with.

## What to test

Archive a small verified copy to P5, then find the job in P5's job monitor. Its description should start with the
full path of the archived folder on the destination, followed by "— CopyTrust verified archive" and the file count.

**Drop Verify and Folder Copy Compare**

No change of their own; they move to 3.0.7 build 82 with CopyTrust.

This is a beta. Test it on media you can afford to lose, and keep a separate, verified backup made by something else.
