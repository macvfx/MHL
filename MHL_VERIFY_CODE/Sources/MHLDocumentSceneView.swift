import SwiftUI

struct MHLDocumentSceneView: View {
    @Binding var document: MHLFileDocument
    @State private var renderedHTML = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(document.parsedDocument.title)
                    .font(.system(size: 28, weight: .semibold))
                Text(document.sourceURL?.path ?? "Opened via document window")
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }

            summaryPanel

            HTMLPreviewView(html: renderedHTML)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(20)
        .frame(minWidth: 900, minHeight: 620, alignment: .topLeading)
        .task(id: document.parsedDocument.id) {
            refreshPreview()
        }
    }

    private var summaryPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(document.parsedDocument.summary, id: \.0) { row in
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(row.0)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 96, alignment: .leading)
                    Text(row.1)
                        .textSelection(.enabled)
                    Spacer(minLength: 0)
                }
            }
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
    }

    private func refreshPreview() {
        let darkMode = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        renderedHTML = MHLPreviewRenderer.render(document: document.parsedDocument, dark: darkMode)
    }
}
