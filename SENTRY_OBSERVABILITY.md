# CopyTrust Sentry Observability

Date reviewed: 2026-07-31
Applies to: CopyTrust 2.7.0 Build 8 and later, including the Build 9 prerelease

## Scope

The current source tree initializes Sentry in **CopyTrust only**. Drop Verify
and Folder Copy Compare do not initialize or link Sentry in the current build.
CopyTrust also skips Sentry initialization in its deterministic documentation
screenshot mode.

Sentry is used for privacy-filtered crash and app-hang diagnostics. It is not
an advertising, analytics, or user-tracking system.

## Privacy Contract

CopyTrust is configured **not to capture or transmit media paths or private
information** in Sentry reports. This includes source and destination paths,
media filenames, P5 hosts and URLs, credentials and request headers, P5
clients/plans/indexes/job identifiers, session logs and artifacts, and
operator, customer, project, or client information.

CopyTrust disables file-I/O and network tracing, performance
tracing/profiling, failed-request capture, session tracking, breadcrumbs, and
Sentry logs. A final on-device event filter rejects breadcrumbs and removes
requests, messages, exception descriptions, filenames, paths, user/server
data, tags, extras, source context, and custom context fields before upload.

## Minimal Data Allowed

- Crash and app-hang stack functions and instruction addresses
- Mach-O image identifiers and addresses needed for dSYM symbolication
- The basename of a loaded executable or framework, never its full path
- App release/build and Sentry platform identifier

CopyTrust does not attach logs, receipts, manifests, contact sheets,
screenshots, view hierarchies, replay, media, or other artifacts. Future dSYM
uploads exclude source files while retaining the symbols needed to resolve a
crash.

## Server-Side Privacy

`sendDefaultPii` is explicitly false. Sentry's **Prevent Storing of IP
Addresses** and server-side data-scrubbing settings must also be enabled
because the application cannot control how the receiving service handles its
connection IP. Retention and deletion of events already received by Sentry are
also controlled by the Sentry project or organization.

## Integration Test

Debug builds expose **Settings → Test → Sentry Integration → Send Privacy-Safe
Test Event**. It sends a synthetic `CopyTrustSentryIntegrationTest` exception
through the normal on-device filter, waits briefly for the SDK to flush, and
displays the submitted event ID. Delivery is confirmed only when that ID
appears in Sentry. It contains no media, path, P5, credential, operator, or
client data and does not force a crash. Its received value must be `Redacted by
CopyTrust privacy filter`, with no private fields present.

This verifies DSN delivery and filtering. A separate controlled crash and
debug-file check is still required to prove crash persistence and dSYM
symbolication.

**Build 8 live result:** the synthetic event was received in the recreated
`apple-macos` project, and its exception value was `Redacted by CopyTrust
privacy filter`. This confirms that the filter ran before the event reached
Sentry; it does not yet confirm release dSYM symbolication.

Sentry references:

- [Apple SDK options](https://docs.sentry.io/platforms/apple/guides/macos/configuration/options/)
- [Apple SDK logs](https://docs.sentry.io/platforms/apple/guides/macos/logs/)
- [Sensitive-data guidance](https://docs.sentry.io/platforms/apple/guides/macos/data-management/sensitive-data/)
