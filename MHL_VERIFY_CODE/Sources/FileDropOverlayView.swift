import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct FileDropOverlayView: NSViewRepresentable {
    let onURLsDropped: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onURLsDropped: onURLsDropped)
    }

    func makeNSView(context: Context) -> DropHostingView {
        let view = DropHostingView()
        view.coordinator = context.coordinator
        return view
    }

    func updateNSView(_ nsView: DropHostingView, context: Context) {
        nsView.coordinator = context.coordinator
    }

    final class Coordinator: NSObject {
        let onURLsDropped: ([URL]) -> Void

        init(onURLsDropped: @escaping ([URL]) -> Void) {
            self.onURLsDropped = onURLsDropped
        }
    }
}

final class DropHostingView: NSView {
    weak var coordinator: FileDropOverlayView.Coordinator?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([.fileURL])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([.fileURL])
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        .copy
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        true
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        guard let items = pasteboard.readObjects(forClasses: [NSURL.self]) as? [URL], !items.isEmpty else {
            return false
        }

        coordinator?.onURLsDropped(items)
        return true
    }
}
