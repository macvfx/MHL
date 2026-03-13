import AppKit
import Foundation
import UniformTypeIdentifiers

enum AppTab: Hashable {
    case reader
    case handlers
}

struct HandlerApp: Identifiable, Hashable {
    let url: URL
    let displayName: String
    let bundleIdentifier: String?

    var id: String { bundleIdentifier ?? url.path }
}

struct HandlerLookupResult {
    let fileExtension: String
    let typeIdentifier: String?
    let currentDefault: HandlerApp?
    let candidateApps: [HandlerApp]
}

@MainActor
final class DefaultHandlerStore: ObservableObject {
    struct ReaderFile: Identifiable, Hashable {
        let url: URL
        let document: MHLDocument

        var id: String { url.path }
        var title: String { document.title }
    }

    @Published var extensionText = "mhl"
    @Published var explicitTypeIdentifier = "io.macadmins.pique.mediahashlist"
    @Published var selectedTab: AppTab = .reader
    @Published var resolvedTypeIdentifier = ""
    @Published var currentDefaultName = ""
    @Published var apps: [HandlerApp] = []
    @Published var selectedAppID: HandlerApp.ID?
    @Published var statusMessage = "Enter a file extension and load registered handlers."
    @Published var isLoading = false
    @Published var readerFiles: [ReaderFile] = []
    @Published var selectedReaderFileID: ReaderFile.ID?
    @Published var openedFileSummary = "No file opened."
    @Published var renderedHTML = """
    <html><body style="font: 14px -apple-system; color: #334155; background: #f8fafc; padding: 24px;">
    <h2 style="margin: 0 0 8px 0;">MHL Reader</h2>
    <p style="margin: 0;">Open an <code>.mhl</code> file to preview its manifest summary and XML source.</p>
    </body></html>
    """
    @Published var recentFilePaths: [String] = []
    @Published var readerStatusMessage = "Drop one or more .mhl files here, or use Open."
    @Published var activeComparison: MHLComparison?

    private let recentFilesDefaultsKey = "MHLDefaultApps.recentFiles"
    private let lastOpenedDefaultsKey = "MHLDefaultApps.lastOpenedFile"
    private static let emptyReaderHTML = """
    <html><body style="font: 14px -apple-system; color: #334155; background: #f8fafc; padding: 24px;">
    <h2 style="margin: 0 0 8px 0;">MHL Reader</h2>
    <p style="margin: 0;">Open an <code>.mhl</code> file to preview its manifest summary and XML source.</p>
    </body></html>
    """

    func load() async {
        let trimmedExtension = normalizedExtension(from: extensionText)
        guard !trimmedExtension.isEmpty else {
            statusMessage = "Enter a file extension such as mhl."
            resolvedTypeIdentifier = ""
            currentDefaultName = ""
            apps = []
            selectedAppID = nil
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try Self.lookup(
                fileExtension: trimmedExtension,
                explicitTypeIdentifier: normalizedTypeIdentifier(from: explicitTypeIdentifier)
            )
            extensionText = result.fileExtension
            resolvedTypeIdentifier = result.typeIdentifier ?? "No UTI found"
            currentDefaultName = result.currentDefault?.displayName ?? "No default app"
            apps = result.candidateApps
            selectedAppID = result.currentDefault?.id ?? result.candidateApps.first?.id

            if result.typeIdentifier == nil {
                statusMessage = "macOS did not resolve a UTI for .\(trimmedExtension). This usually means no installed app declares it."
            } else if result.candidateApps.isEmpty {
                statusMessage = "Resolved .\(trimmedExtension), but no capable apps were found."
            } else {
                statusMessage = "Loaded \(result.candidateApps.count) app(s) for .\(trimmedExtension)."
            }
        } catch {
            resolvedTypeIdentifier = ""
            currentDefaultName = ""
            apps = []
            selectedAppID = nil
            statusMessage = error.localizedDescription
        }
    }

    func setSelectedAppAsDefault() async {
        guard let selectedApp = apps.first(where: { $0.id == selectedAppID }) else {
            statusMessage = "Select an app first."
            return
        }

        let trimmedExtension = normalizedExtension(from: extensionText)
        guard let utType = resolvedUTType(for: trimmedExtension) else {
            statusMessage = "No resolvable UTI exists for .\(trimmedExtension). Try the explicit UTI field."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await NSWorkspace.shared.setDefaultApplication(at: selectedApp.url, toOpen: utType)
            currentDefaultName = selectedApp.displayName
            statusMessage = "Set \(selectedApp.displayName) as the default app for .\(trimmedExtension)."
        } catch {
            statusMessage = "Failed to set default app: \(error.localizedDescription)"
        }
    }

    func selectedApp() -> HandlerApp? {
        apps.first(where: { $0.id == selectedAppID })
    }

    func bootstrapReaderState() {
        recentFilePaths = UserDefaults.standard.stringArray(forKey: recentFilesDefaultsKey) ?? []
        clearOpenFiles()
    }

    func openMHLFile(url: URL) {
        openMHLFiles(urls: [url])
    }

    func openMHLFiles(urls: [URL]) {
        let expandedURLs = expandedMHLURLs(from: urls)
        guard !expandedURLs.isEmpty else {
            readerFiles = []
            selectedReaderFileID = nil
            openedFileSummary = "No file opened."
            readerStatusMessage = "No supported .mhl files were provided."
            selectedTab = .reader
            return
        }

        var loadedFiles: [ReaderFile] = []
        var errors: [String] = []

        for url in expandedURLs {
            do {
                let document = try MHLDocument.read(from: url)
                let readerFile = ReaderFile(url: url, document: document)
                loadedFiles.append(readerFile)
                noteRecentFile(url: url)
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            } catch {
                errors.append("\(url.lastPathComponent): \(error.localizedDescription)")
            }
        }

        readerFiles = loadedFiles

        if let firstLoaded = loadedFiles.first {
            selectReaderFile(id: firstLoaded.id)
            if loadedFiles.count == 1 {
                readerStatusMessage = errors.isEmpty
                    ? "Loaded \(firstLoaded.url.lastPathComponent)."
                    : "Loaded \(firstLoaded.url.lastPathComponent), with \(errors.count) error(s)."
            } else {
                readerStatusMessage = errors.isEmpty
                    ? "Loaded \(loadedFiles.count) files."
                    : "Loaded \(loadedFiles.count) files, with \(errors.count) error(s)."
            }
        } else {
            selectedReaderFileID = nil
            openedFileSummary = "No file opened."
        }

        if loadedFiles.isEmpty, let firstError = errors.first {
            readerStatusMessage = firstError
            renderedHTML = """
            <html><body style="font: 14px -apple-system; color: #7f1d1d; background: #fff7ed; padding: 24px;">
            <h2 style="margin: 0 0 8px 0;">Preview Error</h2>
            <p style="margin: 0;">\(Self.escapeHTML(firstError))</p>
            </body></html>
            """
        }

        selectedTab = .reader
    }

    func selectReaderFile(id: ReaderFile.ID?) {
        selectedReaderFileID = id
        guard let current = currentReaderFile else {
            openedFileSummary = "No file opened."
            return
        }

        let darkMode = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        renderedHTML = MHLPreviewRenderer.render(document: current.document, dark: darkMode)
        openedFileSummary = current.url.path
        UserDefaults.standard.set(current.url.path, forKey: lastOpenedDefaultsKey)
    }

    var currentReaderFile: ReaderFile? {
        guard let selectedReaderFileID else { return readerFiles.first }
        return readerFiles.first(where: { $0.id == selectedReaderFileID }) ?? readerFiles.first
    }

    func exportCurrentDocument(as format: ExportFormat) {
        guard let current = currentReaderFile else {
            readerStatusMessage = "Open an MHL file before exporting."
            return
        }

        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = current.url.deletingPathExtension().lastPathComponent + "." + format.fileExtension
        panel.allowedContentTypes = [format.contentType]

        guard panel.runModal() == .OK, let destination = panel.url else {
            return
        }

        do {
            let data = try format.data(for: current.document, darkMode: NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua)
            try data.write(to: destination, options: .atomic)
            readerStatusMessage = "Exported \(destination.lastPathComponent)."
        } catch {
            readerStatusMessage = "Export failed: \(error.localizedDescription)"
        }
    }

    func reopenRecentFile(path: String) {
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else {
            readerStatusMessage = "Recent file is no longer available: \(path)"
            return
        }
        openMHLFile(url: url)
    }

    func clearRecentFiles() {
        recentFilePaths = []
        UserDefaults.standard.removeObject(forKey: recentFilesDefaultsKey)
        UserDefaults.standard.removeObject(forKey: lastOpenedDefaultsKey)
    }

    func clearOpenFiles() {
        readerFiles = []
        selectedReaderFileID = nil
        openedFileSummary = "No file opened."
        renderedHTML = Self.emptyReaderHTML
        readerStatusMessage = "Open or drop an .mhl file to begin."
    }

    func startComparison() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [UTType(importedAs: "io.macadmins.pique.mediahashlist"), .xml]
        panel.message = "Choose exactly two MHL files to compare."

        guard panel.runModal() == .OK else { return }

        let urls = expandedMHLURLs(from: panel.urls)
        guard urls.count == 2 else {
            readerStatusMessage = "Choose exactly two MHL files to compare."
            return
        }

        do {
            let left = try MHLDocument.read(from: urls[0])
            let right = try MHLDocument.read(from: urls[1])
            activeComparison = MHLComparison(
                leftURL: urls[0],
                leftDocument: left,
                rightURL: urls[1],
                rightDocument: right
            )
            readerStatusMessage = "Comparing \(urls[0].lastPathComponent) and \(urls[1].lastPathComponent)."
        } catch {
            readerStatusMessage = "Compare failed: \(error.localizedDescription)"
        }
    }

    static func lookup(fileExtension: String) throws -> HandlerLookupResult {
        try lookup(fileExtension: fileExtension, explicitTypeIdentifier: nil)
    }

    static func lookup(fileExtension: String, explicitTypeIdentifier: String?) throws -> HandlerLookupResult {
        let normalized = fileExtension.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))

        guard !normalized.isEmpty else {
            throw LookupError.invalidExtension
        }

        guard let utType = resolvedUTType(
            from: normalized,
            explicitTypeIdentifier: explicitTypeIdentifier
        ) else {
            return HandlerLookupResult(
                fileExtension: normalized,
                typeIdentifier: nil,
                currentDefault: nil,
                candidateApps: []
            )
        }

        let workspace = NSWorkspace.shared
        let defaultApp = workspace.urlForApplication(toOpen: utType)
            .map(Self.handlerApp(for:))
            .flatMap { Self.isPreferredHandlerCandidate($0) ? $0 : nil }
        let candidates = (
            workspace.urlsForApplications(toOpen: utType)
                + Self.fallbackEditorAppURLs()
        )
            .map(Self.handlerApp(for:))
            .filter(Self.isPreferredHandlerCandidate)
            .uniqued()
            .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }

        return HandlerLookupResult(
            fileExtension: normalized,
            typeIdentifier: utType.identifier,
            currentDefault: defaultApp,
            candidateApps: candidates
        )
    }

    private func resolvedUTType(for fileExtension: String) -> UTType? {
        Self.resolvedUTType(
            from: fileExtension,
            explicitTypeIdentifier: normalizedTypeIdentifier(from: explicitTypeIdentifier)
        )
    }

    private func normalizedExtension(from value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
    }

    private func normalizedTypeIdentifier(from value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func handlerApp(for url: URL) -> HandlerApp {
        let bundle = Bundle(url: url)
        let displayName =
            FileManager.default.displayName(atPath: url.path)
                .replacingOccurrences(of: ".app", with: "")

        return HandlerApp(
            url: url,
            displayName: displayName,
            bundleIdentifier: bundle?.bundleIdentifier
        )
    }

    private static func resolvedUTType(from fileExtension: String, explicitTypeIdentifier: String?) -> UTType? {
        if let explicitTypeIdentifier, let explicitType = UTType(explicitTypeIdentifier) {
            return explicitType
        }

        return UTType(filenameExtension: fileExtension)
    }

    private static func fallbackEditorAppURLs() -> [URL] {
        let knownPaths = [
            "/Applications/Visual Studio Code.app",
            "/Applications/BBEdit.app",
            "/Applications/CotEditor.app",
            "/Applications/Sublime Text.app",
            "/Applications/Nova.app",
            "/Applications/Xcode.app",
            "/System/Applications/TextEdit.app"
        ]

        return knownPaths
            .map(URL.init(fileURLWithPath:))
            .filter { FileManager.default.fileExists(atPath: $0.path) }
    }

    private static func isPreferredHandlerCandidate(_ app: HandlerApp) -> Bool {
        let composite = "\(app.displayName) \(app.bundleIdentifier ?? "")".lowercased()
        let blockedTerms = ["logic", "comet", "scrub"]
        return blockedTerms.allSatisfy { !composite.contains($0) }
    }

    private static func escapeHTML(_ text: String) -> String {
        text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    private func noteRecentFile(url: URL) {
        let path = url.path
        recentFilePaths.removeAll { $0 == path }
        recentFilePaths.insert(path, at: 0)
        recentFilePaths = Array(recentFilePaths.prefix(8))
        UserDefaults.standard.set(recentFilePaths, forKey: recentFilesDefaultsKey)
        UserDefaults.standard.set(path, forKey: lastOpenedDefaultsKey)
    }

    private func expandedMHLURLs(from urls: [URL]) -> [URL] {
        var results: [URL] = []

        for url in urls {
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
                continue
            }

            if isDirectory.boolValue {
                if let enumerator = FileManager.default.enumerator(
                    at: url,
                    includingPropertiesForKeys: [.isRegularFileKey],
                    options: [.skipsHiddenFiles]
                ) {
                    for case let childURL as URL in enumerator {
                        let ext = childURL.pathExtension.lowercased()
                        if ext == "mhl" {
                            results.append(childURL)
                        }
                    }
                }
            } else {
                let ext = url.pathExtension.lowercased()
                if ext == "mhl" || ext == "xml" {
                    results.append(url)
                }
            }
        }

        var seen = Set<String>()
        return results
            .sorted { $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending }
            .filter { seen.insert($0.path).inserted }
    }
}

enum ExportFormat: String, CaseIterable, Identifiable {
    case json
    case markdown
    case rtf

    var id: String { rawValue }

    var fileExtension: String {
        switch self {
        case .json: return "json"
        case .markdown: return "md"
        case .rtf: return "rtf"
        }
    }

    var contentType: UTType {
        switch self {
        case .json: return .json
        case .markdown: return UTType(filenameExtension: "md") ?? .plainText
        case .rtf: return .rtf
        }
    }

    var title: String {
        switch self {
        case .json: return "Save as JSON"
        case .markdown: return "Save as Markdown"
        case .rtf: return "Save as RTF"
        }
    }

    func data(for document: MHLDocument, darkMode: Bool) throws -> Data {
        switch self {
        case .json: return try document.jsonData()
        case .markdown: return document.markdownData()
        case .rtf: return try document.rtfData(darkMode: darkMode)
        }
    }
}

enum LookupError: LocalizedError {
    case invalidExtension

    var errorDescription: String? {
        switch self {
        case .invalidExtension:
            return "The file extension is empty."
        }
    }
}

private extension Array where Element == HandlerApp {
    func uniqued() -> [HandlerApp] {
        var seen = Set<HandlerApp.ID>()
        return filter { seen.insert($0.id).inserted }
    }
}
