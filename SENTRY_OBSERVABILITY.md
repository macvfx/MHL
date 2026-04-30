# Sentry Observability — What It Is and What It Collects

**Applies to:** FolderCopyCompare, CopyTrust, Drop Verify (all v2.3+)

---

## What Sentry Is

Sentry is a third-party crash reporting and performance monitoring service. When one of these apps crashes, hangs, or throws an unhandled error, Sentry captures a diagnostic report and sends it to a private project dashboard at sentry.io. The dashboard is accessible only to the developer (Mat X, org: `macvfx`).

Sentry is used here purely for development diagnostics — to understand where crashes happen and how the apps perform under real conditions. It is not used for analytics, advertising, or user tracking of any kind.

---

## What Sentry Collects

### Crash and Error Reports
- Full symbolicated stack trace at the point of crash (the exact file and line number, resolved via dSYM debug symbols uploaded at build time)
- Unhandled Swift errors and exceptions
- NSErrors that propagate without being caught
- The sequence of events leading up to the crash (breadcrumbs: recent UI interactions, network requests, log messages — up to the last 100)

### Performance Traces
- App launch duration
- SwiftUI view render times
- File I/O operation timing (relevant for folder scans and hash runs)
- Network request URLs, HTTP methods, status codes, and durations for any outgoing requests made by the app

### Profiling
- CPU flame graphs sampled during active traces — shows which functions are consuming time during operations like folder scanning or file hashing
- Used to identify performance bottlenecks in scan and hash workflows

### Device and App Context
- macOS version and CPU architecture
- App version and build number
- Available memory and disk space at the time of the event
- Whether the app was in the foreground or background

---

## What Sentry Does Not Collect

| What | Why not |
|------|---------|
| IP addresses | `sendDefaultPii` is explicitly disabled (it is off by default; the setup wizard enables it — we removed it) |
| User identity | `SentrySDK.setUser()` is never called; no name, email, or user ID is attached to any event |
| File paths or folder contents | Sentry only sees the app's own code execution, not the data it processes |
| File names, sizes, or hash values from user scans | These never enter the Sentry SDK |
| Keystrokes, clipboard, or pasteboard content | Not collected by the SDK |
| Screenshots or view hierarchy | `attachScreenshot` and `attachViewHierarchy` are not enabled |
| Location data | Not requested and not available to the SDK |
| Any data while the app is not running | Sentry is inactive between launches |

---

## Data Handling

- Events are sent to Sentry's EU ingest endpoint (`ingest.de.sentry.io`) under the developer's private project
- No data is shared with third parties beyond Sentry's own infrastructure
- Sample rates are currently set to 1.0 (100%) for development; these will be reduced before any public release
- Sentry integration is present from v2.3 onwards and is noted in the changelog for each affected app

---

*Last updated: 2026-04-24 — v2.3 Build 1*
