import Foundation

struct MHLComparison: Identifiable {
    let id = UUID()
    let leftURL: URL
    let leftDocument: MHLDocument
    let rightURL: URL
    let rightDocument: MHLDocument

    var title: String {
        "\(leftURL.lastPathComponent) vs \(rightURL.lastPathComponent)"
    }

    var summaryRows: [ComparisonRow] {
        let leftRows = Dictionary(uniqueKeysWithValues: leftDocument.summary)
        let rightRows = Dictionary(uniqueKeysWithValues: rightDocument.summary)
        let keys = Set(leftRows.keys).union(rightRows.keys).sorted()

        return keys.map { key in
            ComparisonRow(
                label: key,
                leftValue: leftRows[key] ?? "-",
                rightValue: rightRows[key] ?? "-"
            )
        }
    }

    var summaryDifferences: [ComparisonRow] {
        summaryRows.filter { !$0.isMatch }
    }

    var fileDiffRows: [FileDiffRow] {
        let leftEntries = Dictionary(uniqueKeysWithValues: leftDocument.hashes.map { ($0.file, $0) })
        let rightEntries = Dictionary(uniqueKeysWithValues: rightDocument.hashes.map { ($0.file, $0) })
        let paths = Set(leftEntries.keys).union(rightEntries.keys).sorted()

        return paths.map { path in
            let leftEntry = leftEntries[path]
            let rightEntry = rightEntries[path]
            return FileDiffRow(path: path, leftEntry: leftEntry, rightEntry: rightEntry)
        }
    }

    var fileDiffSummary: FileDiffSummary {
        FileDiffSummary(rows: fileDiffRows)
    }
}

struct ComparisonRow: Identifiable {
    let id = UUID()
    let label: String
    let leftValue: String
    let rightValue: String

    var isMatch: Bool {
        leftValue == rightValue
    }
}

struct FileDiffSummary {
    let added: Int
    let removed: Int
    let changed: Int
    let unchanged: Int

    init(rows: [FileDiffRow]) {
        added = rows.filter { $0.status == .added }.count
        removed = rows.filter { $0.status == .removed }.count
        changed = rows.filter { $0.status == .changed }.count
        unchanged = rows.filter { $0.status == .unchanged }.count
    }
}

enum FileDiffFilter: String, CaseIterable, Identifiable {
    case differencesOnly = "Differences"
    case changedOnly = "Changed"
    case addedRemoved = "Added/Removed"
    case allFiles = "All"

    var id: String { rawValue }
}

enum FileDiffStatus: String, CaseIterable, Identifiable {
    case added = "Added"
    case removed = "Removed"
    case changed = "Changed"
    case unchanged = "Unchanged"

    var id: String { rawValue }
}

struct FileDiffRow: Identifiable, Hashable {
    let path: String
    let leftEntry: MHLDocument.Entry?
    let rightEntry: MHLDocument.Entry?

    var id: String { path }

    var status: FileDiffStatus {
        switch (leftEntry, rightEntry) {
        case (nil, .some):
            return .added
        case (.some, nil):
            return .removed
        case let (.some(left), .some(right)):
            return normalizedFingerprint(for: left) == normalizedFingerprint(for: right) ? .unchanged : .changed
        case (nil, nil):
            return .unchanged
        }
    }

    var leftSize: Int64? { leftEntry?.size }
    var rightSize: Int64? { rightEntry?.size }
    var leftHash: String? { leftEntry?.xxHash64 ?? leftEntry?.xxHash64BE }
    var rightHash: String? { rightEntry?.xxHash64 ?? rightEntry?.xxHash64BE }
    var leftDate: String? { leftEntry?.hashDate ?? leftEntry?.lastModificationDate }
    var rightDate: String? { rightEntry?.hashDate ?? rightEntry?.lastModificationDate }

    var leftSizeDisplay: String { Self.byteCount(leftSize) }
    var rightSizeDisplay: String { Self.byteCount(rightSize) }

    private func normalizedFingerprint(for entry: MHLDocument.Entry) -> String {
        [
            String(entry.size),
            entry.xxHash64 ?? entry.xxHash64BE ?? "-",
            entry.hashDate ?? "-",
            entry.lastModificationDate ?? "-"
        ].joined(separator: "::")
    }

    private static func byteCount(_ bytes: Int64?) -> String {
        guard let bytes else { return "-" }
        return MHLDocument.formatByteCount(bytes)
    }
}
