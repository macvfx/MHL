# CopyTrust Illustrated Workflow Guide

Published from the reproducible screenshot manifest and workflow-scenario
generator in the private CopyTrust source repository.

This guide combines current UI screenshots with workflow-topology charts
for direct copying, fan-out, relay chains, post-copy actions, P5 archive,
offline handoff, restore, and hash re-verification.
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

## Workflow Possibilities

The following charts separate copy topology from optional post-copy actions.
Every arrow into a green verified destination crosses that destination's own
verification gate. P5 archive submission is later and supplementary: it never
changes the original CopyTrust copy verdict.

### 6. Direct copy: A to B

Use for one source and one destination.

```mermaid
flowchart LR
    A["Source A<br/>Camera card or folder"] -->|"copy"| V["Full or Inline<br/>xxHash64 verification"]
    V -->|"trust gate"| B["Destination B<br/>Verified copy + MHL"]
```

- Use Full or Inline when B may later be archived to P5.
- Quick proves size/existence only and does not create hash-backed MHL evidence.

### 7. Fan-out copy: A to B and A to C

Use when the same card needs two independent verified copies.

```mermaid
flowchart LR
    A["Source A"] -->|"direct copy"| VB["Copy + verify B"]
    VB --> B["Destination B<br/>Verified + MHL"]
    A -->|"direct copy"| VC["Copy + verify C"]
    VC --> C["Destination C<br/>Verified + MHL"]
```

B and C are separate results. Inspect both destination verdicts and receipts;
neither destination silently depends on the other.

### 8. Relay chain: A to B, then B to C

Use when a fast first destination should feed a slower downstream destination.

```mermaid
flowchart LR
    A["Source A<br/>Camera card"] --> L1["Leg 1<br/>Copy + verify"]
    L1 -->|"trust gate"| B["Destination B<br/>Verified intermediate"]
    B -->|"B becomes source"| L2["Leg 2<br/>Copy + verify"]
    L2 -->|"trust gate"| C["Destination C<br/>Verified final"]
```

Leg 2 waits for B to become trust-complete. A failed Leg 1 blocks downstream
copying. With Destination Sort enabled, CopyTrust currently sorts only the
final relay destination.

### 9. Copy A to B, then archive B to P5

Use when B is the verified archive-master copy.

```mermaid
flowchart LR
    A["Source A"] --> C["Copy + Full/Inline verify"]
    C -->|"trust gate"| B["Destination B<br/>Verified archive master"]
    B --> P["Post-copy actions<br/>+ request JSON"]
    P -->|"submit"| P5["Archiware P5<br/>Non-deleting archive plan"]
```

The selected P5 client must see B at the same absolute path. Confirm the P5 job,
archived paths, and searchable `CT_*` metadata in P5 Web.

### 10. Fan-out A to B and C, then archive designated B

Use when B is the archive master and C is a working or safety copy.

```mermaid
flowchart LR
    A["Source A"] --> VB["Copy + verify B"]
    VB --> B["Destination B<br/>Role: Archive Master"]
    A --> VC["Copy + verify C"]
    VC --> C["Destination C<br/>Working / safety copy"]
    B --> P["Post-copy actions<br/>+ request JSON"]
    P --> P5["P5 archive"]
```

Set a destination role such as `Archive Master` so the intended copy is
unambiguous. C remains independently verified and is not silently added to B's
archive request.

### 11. Naming, sorting, artifacts, proxies, and archive order

Naming is decided as CopyTrust builds the delivered paths. Sorting and
derivatives happen only after the trust-critical copy and verification stage.

```mermaid
flowchart LR
    A["Source A"] --> N["Render destination folder<br/>and optional file prefix"]
    N --> C["Copy + hash verification"]
    C -->|"trust gate"| B["Verified B<br/>MHL #1"]
    B --> S["Optional destination sort<br/>remap paths + MHL #2"]
    S --> E["Receipts, EXIF CSV,<br/>contact sheet, HTML tree"]
    E --> X["Optional proxies<br/>+ JSON/TXT/LOG evidence"]
    X --> P5["Optional P5 archive<br/>after enabled work"]
```

- A sorted delivery MHL describes the final layout; the source-layout MHL is
  retained as supporting evidence.
- Artifact, proxy, or P5 failure never upgrades or downgrades the verified
  original-copy result.

### 12. Offline P5 handoff, restore, and re-verification

The deferred request keeps the archive action reviewable when P5 is unavailable.

```mermaid
flowchart LR
    B["Verified B<br/>MHL + receipts"] --> J["Deferred P5 request JSON<br/>No password"]
    J --> H["Review / dry-run<br/>then explicit submission"]
    H --> P5["P5 archive job<br/>confirmed"]
    P5 --> R["P5 restore<br/>to selected path"]
    R --> V["MHL / xxHash64<br/>re-verification"]
    V --> A["Restored copy accepted"]
```

Archive presence is not restore proof. Accept restored media only after the
expected file count, paths, and hashes have been checked.
