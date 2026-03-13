import SwiftUI
import UniformTypeIdentifiers

struct MHLFileDocument: FileDocument {
    static let readableContentTypes: [UTType] = [
        UTType(importedAs: "io.macadmins.pique.mediahashlist"),
        .xml
    ]

    var parsedDocument: MHLDocument
    var sourceURL: URL?

    init(parsedDocument: MHLDocument = .empty, sourceURL: URL? = nil) {
        self.parsedDocument = parsedDocument
        self.sourceURL = sourceURL
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }

        let text: String
        if let utf8 = String(data: data, encoding: .utf8) {
            text = utf8
        } else if let latin1 = String(data: data, encoding: .isoLatin1) {
            text = latin1
        } else {
            text = String(decoding: data, as: UTF8.self)
        }

        parsedDocument = try MHLDocument.parse(source: text)
        sourceURL = configuration.file.filename.map(URL.init(fileURLWithPath:))
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(parsedDocument.sourceXML.utf8)
        return .init(regularFileWithContents: data)
    }
}
