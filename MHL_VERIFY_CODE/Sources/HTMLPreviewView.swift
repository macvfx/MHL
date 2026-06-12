import SwiftUI
import WebKit

struct HTMLPreviewView: NSViewRepresentable {
    let html: String
    var onFilesDropped: (([URL]) -> Void)? = nil

    func makeNSView(context: Context) -> HTMLHostView {
        let host = HTMLHostView()
        host.onFilesDropped = onFilesDropped
        return host
    }

    func updateNSView(_ host: HTMLHostView, context: Context) {
        host.onFilesDropped = onFilesDropped
        if html != host.loadedHTML {
            host.loadedHTML = html
            host.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

// Container NSView that owns the WKWebView as a subview.
// WKWebView fills the container completely, so all mouse and scroll events
// reach it naturally through hit testing. File-URL drags from Finder are
// intercepted here; WKWebView does not register for that pasteboard type.
final class HTMLHostView: NSView {
    let webView: WKWebView
    var onFilesDropped: (([URL]) -> Void)?
    var loadedHTML: String = ""

    override init(frame frameRect: NSRect) {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: frameRect, configuration: config)
        webView.setValue(false, forKey: "drawsBackground")
        super.init(frame: frameRect)
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        registerForDraggedTypes([.fileURL])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        onFilesDropped != nil ? .copy : []
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        onFilesDropped != nil
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let onFilesDropped else { return false }
        let items = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self]) as? [URL] ?? []
        guard !items.isEmpty else { return false }
        onFilesDropped(items)
        return true
    }
}
