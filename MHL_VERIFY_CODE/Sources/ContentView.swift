import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {
    @ObservedObject var store: DefaultHandlerStore
    @Environment(\.openWindow) private var openWindow
    @State private var isImporterPresented = false

    var body: some View {
        TabView(selection: $store.selectedTab) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("MHL Verify")
                            .font(.system(size: 28, weight: .semibold))
                        Text("Drop an `.mhl` file to replace the current view, or drop a folder to load its MHL files into the picker below.")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 10) {
                    statusRow(label: "Current File", value: store.openedFileSummary)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(nsColor: NSColor.windowBackgroundColor).opacity(0.4))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )

                HStack(spacing: 10) {
                    Button("Open MHL Files") {
                        isImporterPresented = true
                    }

                    Button("Compare…") {
                        store.startComparison()
                    }

                    Menu("Save As") {
                        ForEach(ExportFormat.allCases) { format in
                            Button(format.title) {
                                store.exportCurrentDocument(as: format)
                            }
                        }
                    }
                    .disabled(store.currentReaderFile == nil)

                    Button("Help") {
                        openWindow(id: "help")
                    }

                    Spacer()
                }
                .padding(.horizontal, 2)

                readerPreview
                    .frame(maxWidth: .infinity, minHeight: 360, maxHeight: .infinity)

                HStack(alignment: .top, spacing: 16) {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Open Files")
                                    .font(.headline)
                                Spacer()
                                Button("Clear") {
                                    store.clearOpenFiles()
                                }
                                .buttonStyle(.link)
                                .disabled(store.readerFiles.isEmpty)
                            }

                            if store.readerFiles.isEmpty {
                                Text("No files loaded yet. Files you open or drop will appear here.")
                                    .foregroundStyle(.secondary)
                            } else {
                                List(selection: $store.selectedReaderFileID) {
                                    ForEach(store.readerFiles) { file in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(file.title)
                                            Text(file.url.lastPathComponent)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .tag(file.id)
                                    }
                                }
                                .frame(minHeight: 150)
                                .onChange(of: store.selectedReaderFileID) { newValue in
                                    store.selectReaderFile(id: newValue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Recent Files")
                                    .font(.headline)
                                Spacer()
                                Button("Clear") {
                                    store.clearRecentFiles()
                                }
                                .buttonStyle(.link)
                                .disabled(store.recentFilePaths.isEmpty)
                            }

                            if store.recentFilePaths.isEmpty {
                                Text("No recent files yet.")
                                    .foregroundStyle(.secondary)
                            } else {
                                List(store.recentFilePaths, id: \.self) { path in
                                    Button {
                                        store.reopenRecentFile(path: path)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(URL(fileURLWithPath: path).lastPathComponent)
                                                .foregroundStyle(.primary)
                                            Text(path)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(minHeight: 150)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .tag(AppTab.reader)
            .tabItem {
                Label("Reader", systemImage: "doc.richtext")
            }

            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Default Handler Utility")
                        .font(.system(size: 28, weight: .semibold))
                    Text("Inspect the registered macOS handler for a file extension and set a new default app.")
                        .foregroundStyle(.secondary)
                }

                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("File extension")
                            .font(.headline)
                        TextField("mhl", text: $store.extensionText)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 180)
                            .onSubmit {
                                Task { await store.load() }
                            }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Explicit UTI")
                            .font(.headline)
                        TextField("io.macadmins.pique.mediahashlist", text: $store.explicitTypeIdentifier)
                            .textFieldStyle(.roundedBorder)
                            .frame(minWidth: 260)
                    }

                    Button("Load Handlers") {
                        Task { await store.load() }
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(store.isLoading)

                    Button("Set Selected App") {
                        Task { await store.setSelectedAppAsDefault() }
                    }
                    .disabled(store.isLoading || store.selectedApp() == nil)
                }

                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        LabeledContent("Resolved UTI", value: store.resolvedTypeIdentifier)
                        LabeledContent("Current Default", value: store.currentDefaultName)
                        LabeledContent("Status", value: store.statusMessage)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text("PiqueMHL declares `.mhl` as `io.macadmins.pique.mediahashlist`. If Finder does not resolve `.mhl` automatically on this Mac, keep that UTI here and load again.")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Candidate Apps")
                        .font(.headline)

                    if store.apps.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 34))
                                .foregroundStyle(.secondary)
                            Text("No apps loaded")
                                .font(.headline)
                            Text("Load an extension to see the apps macOS says can open it.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(store.apps, selection: $store.selectedAppID) { app in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.displayName)
                                Text(app.bundleIdentifier ?? app.url.path)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .tag(app.id)
                        }
                        .listStyle(.inset)
                    }
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .tag(AppTab.handlers)
            .tabItem {
                Label("Handlers", systemImage: "arrow.up.forward.app")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [UTType(importedAs: "io.macadmins.pique.mediahashlist"), .xml],
            allowsMultipleSelection: true
        ) { result in
            if case .success(let urls) = result {
                store.openMHLFiles(urls: urls)
            }
        }
        .onOpenURL { url in
            store.openMHLFile(url: url)
        }
        .sheet(item: $store.activeComparison) { comparison in
            CompareView(comparison: comparison)
        }
        .task {
            store.bootstrapReaderState()
            await store.load()
        }
    }

    @ViewBuilder
    private var readerPreview: some View {
        Group {
            if store.currentReaderFile == nil {
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text("Drop `.mhl` Files Here")
                        .font(.system(size: 22, weight: .semibold))
                    Text("Drop a single `.mhl` file to replace the current view, or drop a folder to populate the Open Files list below. Use Save As to export JSON, Markdown, or RTF.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: 560, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(nsColor: NSColor.windowBackgroundColor).opacity(0.45))
                )
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [8, 8]))
                            .foregroundStyle(.quaternary)
                        FileDropOverlayView { urls in
                            store.openMHLFiles(urls: urls)
                        }
                    }
                )
            } else {
                ZStack {
                    HTMLPreviewView(html: store.renderedHTML)
                    FileDropOverlayView { urls in
                        store.openMHLFiles(urls: urls)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )
            }
        }
    }

    private func statusRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .textSelection(.enabled)
            Spacer(minLength: 0)
        }
    }
}

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("How To Use MHL Verify")
                        .font(.system(size: 24, weight: .semibold))
                    Text("Open, review, compare, and export MHL files.")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }

            GroupBox("Quick Start") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Drag one `.mhl` onto the Dock icon to open it in its own viewer window.")
                    Text("Open the app first when you want to review several files, use recents, compare two files, or export.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox("Reader") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("`Open MHL Files` loads one or more files into the reader.")
                    Text("Dragging one `.mhl` into the app replaces the current reader view.")
                    Text("Dragging a folder loads its `.mhl` files into `Open Files`.")
                    Text("`Open Files` is the current working set. `Recent Files` is your history.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox("Compare And Export") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Use `Compare…` and choose exactly two `.mhl` or XML files.")
                    Text("Use `Save As` to export the current file as JSON, Markdown, or RTF.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox("Handlers") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("The `Handlers` tab is for checking or changing the macOS default app for `.mhl`.")
                    Text("Use it only when you need file-association control, not normal reading or compare work.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Link("code.matx.ca", destination: URL(string: "https://code.matx.ca")!)
                .font(.headline)

            Spacer()
        }
        .padding(24)
        .frame(minWidth: 620, minHeight: 460, alignment: .topLeading)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private var versionString: String {
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        return "Version \(shortVersion) (\(buildVersion))"
    }

    var body: some View {
        VStack(spacing: 18) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 96, height: 96)

            VStack(spacing: 6) {
                Text("MHL Verify")
                    .font(.system(size: 24, weight: .semibold))
                Text("Open, review, compare, and export MHL files.")
                    .foregroundStyle(.secondary)
                Text(versionString)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Link("code.matx.ca", destination: URL(string: "https://code.matx.ca")!)

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(28)
        .frame(minWidth: 360, minHeight: 320)
    }
}
