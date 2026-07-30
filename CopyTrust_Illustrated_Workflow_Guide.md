# CopyTrust Illustrated Workflow Guide

Generated from `docs/workflows/copytrust/screenshots.tsv`.

This guide shows the normal progression from choosing a copy mode through
direct copying, mixed queues, relay chains, and post-copy actions.
Use the [2.7 Workflow QA Matrix](COPYTRUST_WORKFLOW_QA_MATRIX.md) for the
matching proof checks and evidence requirements.

For the complete control reference and operating detail, see the
[CopyTrust User Guide](CopyTrust_UserGuide.md). A printable version of this
guide is available as
[CopyTrust_Illustrated_Workflow_Guide.pdf](CopyTrust_Illustrated_Workflow_Guide.pdf).

## 01. Choose a copy mode

Select Card for camera-card ingest or Folder for general folder copies; each mode keeps an independent settings profile.

![Choose a copy mode](assets/copytrust_workflows/01-copy-mode.png)

## 02. Prepare a direct session

Add one source and one or more destinations, confirm the naming preview, and check preflight before starting.

![Prepare a direct session](assets/copytrust_workflows/02-direct-session.png)

## 03. Stage mixed queued jobs

Queue separate Card and Folder jobs when different sources need different destinations or post-copy settings.

![Stage mixed queued jobs](assets/copytrust_workflows/03-mixed-queue.png)

## 04. Build a relay chain

For A to B to C, order destinations fastest first and use Queue Relay Chain so each downstream leg waits for verified upstream output.

![Build a relay chain](assets/copytrust_workflows/04-relay-chain.png)

## 05. Set post-copy actions

Use the Post-Copy tab to configure confirmation, contact sheets, metadata, HTML trees, proxy media, and destination sorting for Card or Folder mode.

![Set post-copy actions](assets/copytrust_workflows/05-post-copy-actions.png)

## 6. Archive a verified destination to P5 (testing)

In CopyTrust 2.7.0 Build 1, configure Settings > P5 Archive with the
server, archive index, P5 client, and a non-deleting plan. A Full or
Inline verified destination can be submitted only after the trust chain
and enabled post-copy work finish. Review the password-free request JSON,
the P5 job, and the searchable CT metadata in P5 Web. Restore through P5
and verify the restored files against the preserved capture MHL/xxHash64.

The P5 settings and job-state views are intentionally part of the 2.7
operator acceptance matrix; the existing post-copy screenshot remains the
visual checkpoint for the stage that precedes the archive handoff.
