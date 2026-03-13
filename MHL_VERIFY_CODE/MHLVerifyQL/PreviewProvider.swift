import Cocoa
import QuickLookUI

@objc(PreviewProvider)
final class PreviewProvider: NSViewController, QLPreviewingController {
    private lazy var textView: NSTextView = {
        let view = NSTextView()
        view.isEditable = false
        view.isSelectable = true
        view.autoresizingMask = [.width]
        view.textContainerInset = NSSize(width: 16, height: 16)
        view.isAutomaticQuoteSubstitutionEnabled = false
        view.isAutomaticDashSubstitutionEnabled = false
        view.isAutomaticTextReplacementEnabled = false
        return view
    }()

    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView()
        view.hasVerticalScroller = true
        view.hasHorizontalScroller = true
        view.autoresizingMask = [.width, .height]
        view.documentView = textView
        return view
    }()

    override func loadView() {
        view = scrollView
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        do {
            let document = try MHLDocument.read(from: url)
            let isDark = view.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            let html = MHLPreviewRenderer.render(document: document, dark: isDark)

            guard let htmlData = html.data(using: .utf8),
                  let attributed = NSAttributedString(html: htmlData, documentAttributes: nil) else {
                handler(nil)
                return
            }

            textView.textStorage?.setAttributedString(attributed)
            let background = isDark
                ? NSColor(red: 0.110, green: 0.110, blue: 0.118, alpha: 1)
                : NSColor(red: 0.973, green: 0.980, blue: 0.988, alpha: 1)
            textView.backgroundColor = background
            scrollView.backgroundColor = background

            handler(nil)
        } catch {
            handler(error)
        }
    }
}
