# What Is MHL And Why Use It

## Short Answer

**MHL** stands for **Media Hash List**.

It is a manifest format that records file hashes and related metadata so you can later verify that media files are still exactly what they were when the MHL was created.

In plain language:

- it is a file that describes a set of media files
- it records checksums/hashes for those files
- it helps prove whether later copies still match

## Why MHL Exists

Modern media workflows involve constant copying:

- camera card to shuttle drive
- shuttle drive to RAID
- RAID to editorial
- editorial to archive
- archive back to restore

Any of those steps can introduce problems:

- missing files
- incomplete copies
- modified files
- damaged transfers
- broken folder structures

MHL exists to make those problems detectable instead of invisible.

According to [mediahashlist.org](https://mediahashlist.org/), MHL was created to help ensure that source media is transferred completely and without alteration, and to detect changes to both files and folder structure. The site also describes MHL as a human-readable XML inventory of a folder and its subfolders. [Source](https://mediahashlist.org/)

## What An MHL Contains

At a practical level, an MHL usually contains:

- file paths
- file sizes
- modification dates
- one or more hash values
- metadata about the tool or process that created the MHL

The original MHL site explains that the format lists the files in a folder and subfolders together with checksums and creation details, and that the manifest contains enough information to detect whether files or structure changed after the MHL was created. [Source](https://mediahashlist.org/)

## Why Hashes Matter

A hash is a fingerprint of a file.

If the file changes, the hash changes.

That means you can compare:

- the stored hash from the MHL
- the newly calculated hash from a file on disk

If they match, the file is expected to be the same.
If they do not match, something changed.

This is the core reason MHL is valuable: it turns "I think this copy is fine" into "I checked this copy against recorded hashes."

## Why MHL Is Better Than Just Looking At File Names

File names and sizes are not enough.

Two files can:

- have the same name
- live in the same folder
- even have the same size

and still not be identical.

MHL gives you a stronger integrity check because it relies on hashes, not just filenames or folder appearance.

## Why MHL Is Useful In Real Workflows

The ASC MHL reference implementation describes ASC MHL as a format used to create a **chain of custody** from the initial media download all the way through final archival. It also describes the format as human-readable XML with hashes and essential file metadata. [Source](https://github.com/ascmitc/mhl)

That idea of chain of custody is the real operational value:

- on set, it proves copied media matches the original ingest
- in post, it supports handoffs between teams and tools
- in archive, it lets you re-check stored media later
- in restores, it lets you confirm that recovered files still match the trusted manifest

## Why MHL Helps Even When Folder Structure Changes

One of the practical advantages of MHL is that it records more than a simple loose checksum list.

The Frame.io article explains that MHL workflows help when files are reorganized, because the MHL can record folder-structure information and support later reconstruction or validation of what changed. It also notes that MHL is robust enough to support workflows across different tools rather than forcing you to stay inside one vendor's software. [Source](https://blog.frame.io/2022/08/22/mhl-media-hash-lists-workflow/)

That matters because real-world media workflows are messy:

- folders get renamed
- assistants reorganize files
- archives repackage material
- different facilities use different tools

MHL helps maintain trust even when the workflow is bigger than one app.

## Why Use MHL Instead Of A Proprietary Log

MHL is valuable partly because it is a published, interoperable format.

The original MHL site describes it as a human-readable XML format designed to work with existing checksum-based workflows and tools. [Source](https://mediahashlist.org/)

The ASC MITC work and reference implementation push that further by defining an openly documented specification and a reference implementation. [Source](https://github.com/ascmitc/mhl)

In practice, that means:

- you are not locked into one application
- another tool can often verify the same MHL
- the manifest is still understandable later
- it is more archive-friendly than an opaque internal database

## Why Use It With Drop Verify

Drop Verify gives you a simple way to generate:

- an `MHL`
- a `Contact sheet PDF`
- an `EXIF camera metadata CSV`

That combination is useful because each artifact answers a different question:

- `MHL`: Are these files still identical?
- `Contact sheet PDF`: What is in this folder visually?
- `CSV`: What metadata and file-path information do I need for reporting?

So MHL is not the whole story, but it is the integrity backbone of the package.

## Good Practical Reasons To Use MHL

- You want proof that a copied media set matches the original.
- You want to verify files later without trusting memory or assumptions.
- You want a handoff artifact that another tool can also read.
- You want stronger archive confidence.
- You want to detect missing, altered, or incomplete files quickly.

## External References

- [MHL: Media Hash List](https://mediahashlist.org/)
- [ASC Media Hash List reference implementation](https://github.com/ascmitc/mhl)
- [ASC Media Hash List page](https://theasc.com/society/ascmitc/asc-media-hash-list)
- [Frame.io: Media Hash Lists 101](https://blog.frame.io/2022/08/22/mhl-media-hash-lists-workflow/)
