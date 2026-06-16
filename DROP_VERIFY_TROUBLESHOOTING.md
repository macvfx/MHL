# Drop Verify Troubleshooting

Use this when Drop Verify appears stuck, the UI still says it is working, or the session log does not clearly say whether the run is finished.

## Quick Read

Drop Verify now runs only the work required for the selected outputs:

1. If MHL is enabled, scan media, hash files, write MHL, and write a session manifest.
2. If CSV is enabled, scan media and read metadata for the CSV.
3. If contact sheet is enabled, scan media and create thumbnails/metadata for the PDF.
4. If HTML tree is enabled, generate a project summary index or recursive HTML tree files.
5. Optionally export selected artifacts to a separate folder.
6. Write success or failure log lines.

If MHL, CSV, and PDF exist but the app is still running, the selected media artifacts may be complete while HTML tree output is still running. The Project summary index mode is native; the recursive tree modes are the ones that can wait on the external `tree` process.

If only HTML tree/index is enabled, Drop Verify should log:

```text
Tree-only run - skipping media hash and metadata analysis.
```

That is expected. Tree-only mode does not create an MHL, CSV, contact sheet, or session manifest.

## Expected Finish Lines

A successful session log should end with lines like:

```text
Artifacts complete - MHL * contact sheet * CSV
  MHL: /path/to/Drop Verify_Receipts/...
  Contact sheet: /path/to/Drop Verify_Receipts/...
  CSV: /path/to/Drop Verify_Receipts/...
Session finished successfully.
```

For a no-MHL report run, the log can also include:

```text
Manifest skipped - MHL/hash output is disabled.
Session finished successfully.
```

If the last meaningful line is about previews or contact-sheet completion, Drop Verify has not reached its normal final state.

## Check Whether The App Is Still Running

```zsh
pgrep -fl "Drop Verify"
```

If a PID is returned, sample the app before quitting it:

```zsh
sample <PID> 5 -file ~/Desktop/dropverify_sample.txt
```

Check the app's current state:

```zsh
ps -o pid,ppid,stat,etime,pcpu,pmem,command -p <PID>
```

Useful interpretation:

- High or changing CPU: the app may still be working.
- Very low CPU for a long time: likely waiting on I/O, an external command, or an idle/hung state.
- No PID: the app exited or crashed. Check the session log and macOS crash reports.

## Check For External Child Processes

Drop Verify can launch external tools such as `tree`, `ffmpeg`, REDline, or ExifTool. To see child processes:

```zsh
pgrep -P <DropVerifyPID> -fl .
```

Example stuck tree result:

```text
38175 /opt/local/bin/tree -J /Volumes/MAIN-VAN/Clients/WBM Technologies/FCL IT Event Case Studies
```

If the sample shows `-[NSConcreteTask waitUntilExit]` and `pgrep -P` shows `tree -J`, Drop Verify is waiting for the HTML tree command.

## Check Open Files

Use `lsof` to see whether Drop Verify is touching receipts, exports, or external storage:

```zsh
lsof -p <DropVerifyPID> | egrep 'Drop Verify_Receipts|dropverify|contactsheet|mhl|csv|tree|\.pdf|\.html'
```

Seeing unrelated HTTP storage or SQLite files can be normal macOS framework/app state. Look for paths that point to the project, receipt folder, export folder, or an external tool.

## Check Whether The Log Is Still Changing

```zsh
stat -f "%Sm %z %N" /path/to/session_XXXX.log
tail -n 30 /path/to/session_XXXX.log
sleep 60
stat -f "%Sm %z %N" /path/to/session_XXXX.log
tail -n 30 /path/to/session_XXXX.log
```

If timestamp and size do not change while a child process is still running, the app may be blocked waiting for that child process.

## Confirm Artifacts Already Exist

```zsh
find "/path/to/project/Drop Verify_Receipts" -maxdepth 2 -type f -print -exec ls -lh {} \;
```

Look for:

- `.mhl`
- `.csv`
- `dropverify_contactsheet_*.pdf`
- optional `dropverify_tree_*.html`

Match this list to the outputs selected in Settings. Disabled outputs should not exist. If MHL is disabled, no MHL or session manifest is expected. If HTML tree is the only selected output, an HTML file is the only expected artifact.

## Recover From A Stuck HTML Tree

If `pgrep -P <DropVerifyPID> -fl .` shows a long-running `tree -J` child and any non-tree artifacts you selected are already present, terminate only the child process first:

```zsh
kill <TreePID>
```

Drop Verify may then report:

```text
tree command failed with exit code 15
```

Exit code 15 means the `tree` command received SIGTERM. This means the HTML tree artifact was stopped. It does not mean already written MHL, CSV, or PDF artifacts failed.

If Drop Verify does not recover within 30-60 seconds after killing the child process, quit Drop Verify normally.

## When To Disable HTML Tree

For very large project folders, network shares, or folders with many nested files, use **Project summary index** or **One HTML per top-level folder** unless a single complete recursive tree is required. **Entire project** can create a very large artifact.

For a fast folder-only report, enable only **HTML directory tree** and choose **Project summary index**. That path skips media scanning, hashing, metadata extraction, and the session manifest.

## Evidence To Save

When reporting a stuck run, save:

```zsh
sample <PID> 5 -file ~/Desktop/dropverify_sample.txt
pgrep -P <PID> -fl .
ps -o pid,ppid,stat,etime,pcpu,pmem,command -p <PID>
tail -n 80 /path/to/session_XXXX.log
find "/path/to/project/Drop Verify_Receipts" -maxdepth 2 -type f -print -exec ls -lh {} \;
```

These usually answer whether Drop Verify is still working, waiting on an external command, done but not updated in the UI, or missing only an optional artifact.
