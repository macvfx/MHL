import Foundation

enum MHLFileReader {
    static let maxFileSize: UInt64 = 10_000_000

    static func read(url: URL) throws -> String {
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))
        let size = attributes[.size] as? UInt64 ?? 0
        guard size <= maxFileSize else {
            throw ReaderError.fileTooLarge(size)
        }

        let data = try Data(contentsOf: url)

        if let text = String(data: data, encoding: .utf8) {
            return text
        }
        if let text = String(data: data, encoding: .isoLatin1) {
            return text
        }

        return String(decoding: data, as: UTF8.self)
    }

    enum ReaderError: LocalizedError {
        case fileTooLarge(UInt64)

        var errorDescription: String? {
            switch self {
            case .fileTooLarge(let size):
                let megabytes = Double(size) / 1_000_000
                return String(format: "File too large (%.1f MB). Maximum is 10 MB.", megabytes)
            }
        }
    }
}
