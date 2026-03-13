import AppKit
import Foundation

struct MHLDocument: Codable, Identifiable, Hashable {
    struct Entry: Codable, Hashable, Identifiable {
        var id: String { file + "::" + (hashDate ?? "") }
        var file: String
        var size: Int64
        var lastModificationDate: String?
        var xxHash64BE: String?
        var xxHash64: String?
        var hashDate: String?
    }

    var id: String { rootPath ?? sourceInfo["Source Name"] ?? version }
    let version: String
    let rootPath: String?
    let creatorInfo: [String: String]
    let sourceInfo: [String: String]
    let hashes: [Entry]
    let sourceXML: String

    var title: String {
        sourceInfo["Source Name"]
            ?? rootPath?.split(separator: "/").last.map(String.init)
            ?? "Media Hash List"
    }

    var totalBytes: Int64 {
        hashes.reduce(Int64(0)) { $0 + $1.size }
    }

    var totalFiles: Int {
        hashes.count
    }

    var summary: [(String, String)] {
        var rows: [(String, String)] = [
            ("Files", String(totalFiles)),
            ("Total Size", Self.formatByteCount(totalBytes))
        ]
        if let started = creatorInfo["startdate"] { rows.append(("Started", started)) }
        if let finished = creatorInfo["finishdate"] { rows.append(("Finished", finished)) }
        if let firstHash = hashes.first?.hashDate { rows.append(("First Hash", firstHash)) }
        if let lastHash = hashes.last?.hashDate { rows.append(("Last Hash", lastHash)) }
        return rows
    }

    static let empty = MHLDocument(
        version: "1.0",
        rootPath: nil,
        creatorInfo: [:],
        sourceInfo: [:],
        hashes: [],
        sourceXML: "<hashlist version=\"1.0\"></hashlist>"
    )

    static func read(from url: URL) throws -> MHLDocument {
        let source = try MHLFileReader.read(url: url)
        return try parse(source: source)
    }

    static func parse(source: String) throws -> MHLDocument {
        guard let data = source.data(using: .utf8) else {
            throw MHLDocumentError.invalidEncoding
        }

        let delegate = ParserDelegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        guard parser.parse(), let version = delegate.version else {
            throw MHLDocumentError.invalidFormat
        }

        return MHLDocument(
            version: version,
            rootPath: delegate.rootPath,
            creatorInfo: delegate.creatorInfo,
            sourceInfo: delegate.sourceInfo,
            hashes: delegate.hashes,
            sourceXML: source
        )
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }

    func markdownData() -> Data {
        Data(markdown().utf8)
    }

    func rtfData(darkMode: Bool = false) throws -> Data {
        let html = MHLPreviewRenderer.render(document: self, dark: darkMode)
        guard let htmlData = html.data(using: .utf8) else {
            throw MHLDocumentError.exportFailed("Could not encode HTML for RTF export.")
        }
        let attributedString = try NSAttributedString(
            data: htmlData,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        return try attributedString.data(
            from: NSRange(location: 0, length: attributedString.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
        )
    }

    private func markdown() -> String {
        var lines: [String] = []
        lines.append("# \(title)")
        lines.append("")
        lines.append("- Version: \(version)")
        if let rootPath { lines.append("- Root Path: \(rootPath)") }
        lines.append("- Files: \(totalFiles)")
        lines.append("- Total Size: \(Self.formatByteCount(totalBytes))")
        lines.append("")

        if !sourceInfo.isEmpty {
            lines.append("## Source Info")
            lines.append("")
            for key in sourceInfo.keys.sorted() {
                lines.append("- \(key): \(sourceInfo[key] ?? "")")
            }
            lines.append("")
        }

        if !creatorInfo.isEmpty {
            lines.append("## Creator")
            lines.append("")
            for key in creatorInfo.keys.sorted() {
                lines.append("- \(key): \(creatorInfo[key] ?? "")")
            }
            lines.append("")
        }

        lines.append("## Entries")
        lines.append("")
        for entry in hashes {
            lines.append("### \(entry.file)")
            lines.append("")
            lines.append("- Size: \(Self.formatByteCount(entry.size))")
            if let modified = entry.lastModificationDate { lines.append("- Modified: \(modified)") }
            if let hashDate = entry.hashDate { lines.append("- Hash Date: \(hashDate)") }
            if let xxHash64 = entry.xxHash64 { lines.append("- xxHash64: `\(xxHash64)`") }
            if let xxHash64BE = entry.xxHash64BE { lines.append("- xxHash64 BE: `\(xxHash64BE)`") }
            lines.append("")
        }

        lines.append("## XML Source")
        lines.append("")
        lines.append("```xml")
        lines.append(sourceXML)
        lines.append("```")
        lines.append("")
        return lines.joined(separator: "\n")
    }

    static func formatByteCount(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB, .useTB]
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        return formatter.string(fromByteCount: bytes)
    }

    private final class ParserDelegate: NSObject, XMLParserDelegate {
        var version: String?
        var rootPath: String?
        var creatorInfo: [String: String] = [:]
        var sourceInfo: [String: String] = [:]
        var hashes: [Entry] = []

        private var elementStack: [String] = []
        private var currentValue = ""
        private var currentHash: Entry?
        private var currentSourceFieldName: String?

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            elementStack.append(elementName)
            currentValue = ""

            if elementName == "hashlist" {
                version = attributeDict["version"]
            } else if elementName == "hash" {
                currentHash = Entry(file: "", size: 0)
            } else if elementName == "sourceInfoField" {
                currentSourceFieldName = attributeDict["name"]
            } else if elementName == "rootPath" {
                rootPath = nil
            }
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            currentValue += string
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            let value = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)

            if let currentHash, elementStack.contains("hash"), !value.isEmpty {
                var updated = currentHash
                switch elementName {
                case "file": updated.file = value
                case "size": updated.size = Int64(value) ?? 0
                case "lastmodificationdate": updated.lastModificationDate = value
                case "xxhash64be": updated.xxHash64BE = value
                case "xxhash64": updated.xxHash64 = value
                case "hashdate": updated.hashDate = value
                default: break
                }
                self.currentHash = updated
            } else if elementStack.contains("creatorinfo"), !value.isEmpty {
                creatorInfo[elementName] = value
            } else if elementName == "rootPath", !value.isEmpty {
                rootPath = value
            } else if elementName == "sourceInfoField", !value.isEmpty, let fieldName = currentSourceFieldName {
                sourceInfo[fieldName] = value
                currentSourceFieldName = nil
            }

            if elementName == "hash", let currentHash {
                hashes.append(currentHash)
                self.currentHash = nil
            }

            _ = elementStack.popLast()
            currentValue = ""
        }
    }
}

enum MHLDocumentError: LocalizedError {
    case invalidEncoding
    case invalidFormat
    case exportFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidEncoding:
            return "The MHL file could not be decoded as text."
        case .invalidFormat:
            return "The file does not appear to be a valid Media Hash List."
        case .exportFailed(let message):
            return message
        }
    }
}
