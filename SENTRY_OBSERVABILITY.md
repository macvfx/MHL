# CopyTrust Sentry Observability

Date reviewed: 2026-07-29
Applies to: CopyTrust 2.6 public beta

## Scope

The current source tree initializes Sentry in **CopyTrust only**. Drop Verify
and Folder Copy Compare do not initialize or link Sentry in the current build.
CopyTrust also skips Sentry initialization in its deterministic documentation
screenshot mode.

Sentry is used for crash, hang, performance, profiling, and diagnostic-log
visibility. It is not an advertising or product-analytics system.

## Current Configuration

CopyTrust currently configures:

- crash and unhandled-error reporting;
- performance tracing with `tracesSampleRate = 1.0`;
- profiling with `sessionSampleRate = 1.0` and trace lifecycle;
- Sentry's experimental logs integration;
- the configured regional Sentry ingest endpoint for the app's telemetry
  project.

The two `1.0` values mean the beta source requests 100% trace and profiling
sampling. There is no in-app Sentry toggle in the current build.

## Data That May Be Sent

Depending on the event and SDK integrations, diagnostic events may contain:

- symbolicated stack traces and exception/error descriptions;
- app version/build, macOS version, CPU architecture, memory, and runtime state;
- performance spans, profiling samples, and operation timing;
- breadcrumbs or diagnostic log messages recorded before an error;
- network request metadata or error context captured by an SDK integration;
- text values emitted by CopyTrust or an underlying framework.

Because logs, breadcrumbs, and error descriptions can contain dynamic text,
this document does **not** promise that a file name or path can never appear.
CopyTrust is not designed to upload media files, folder contents, MHL files,
receipts, hashes, or generated artifacts to Sentry as attachments, but
operator-derived names or paths may still occur in diagnostic text and should
be treated as potentially present until client-side scrubbing is implemented
and verified.

## Data Not Explicitly Enabled By CopyTrust

The current initialization code does not:

- call `SentrySDK.setUser`;
- add custom file attachments;
- explicitly enable screenshot attachments;
- explicitly enable view-hierarchy attachments;
- request location, clipboard, or keystroke data.

The source also does not explicitly set `sendDefaultPii`, `beforeSend`, or
`beforeBreadcrumb`. IP handling, server-side data scrubbing, access controls,
and retention are Sentry project settings and cannot be proven from this
repository alone.

## Required Review Before Stable Release

Before promoting this beta configuration to a stable public release:

1. reduce or deliberately approve the trace and profiling sample rates;
2. add and test client-side filtering for events, breadcrumbs, and logs;
3. review representative production events for paths, filenames, and other
   operator-derived values;
4. confirm Sentry project IP scrubbing, data-scrubbing, access, and retention
   settings;
5. decide whether CopyTrust needs an in-app diagnostics opt-out;
6. update this document from the released source and verified project settings.

Sentry references:

- [Apple SDK options](https://docs.sentry.io/platforms/apple/guides/macos/configuration/options/)
- [Apple SDK logs](https://docs.sentry.io/platforms/apple/guides/macos/logs/)
- [Sensitive-data guidance](https://docs.sentry.io/platforms/apple/guides/macos/data-management/sensitive-data/)
