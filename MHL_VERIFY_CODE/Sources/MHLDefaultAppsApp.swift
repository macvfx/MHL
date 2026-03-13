import SwiftUI

@main
struct MHLDefaultAppsApp: App {
    @StateObject private var store = DefaultHandlerStore()

    var body: some Scene {
        WindowGroup("MHL Verify") {
            ContentView(store: store)
                .frame(minWidth: 960, minHeight: 640)
        }
        .commands {
            MHLVerifyCommands()
        }

        DocumentGroup(newDocument: MHLFileDocument()) { file in
            MHLDocumentSceneView(document: file.$document)
        }

        Window("Help", id: "help") {
            HelpView()
        }

        Window("About MHL Verify", id: "about") {
            AboutView()
        }
    }
}

private struct MHLVerifyCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About MHL Verify") {
                openWindow(id: "about")
            }
        }

        CommandGroup(replacing: .help) {
            Button("MHL Verify Help") {
                openWindow(id: "help")
            }
            .keyboardShortcut("/", modifiers: [.command, .shift])

            Divider()

            Link("code.matx.ca", destination: URL(string: "https://code.matx.ca")!)
        }
    }
}
