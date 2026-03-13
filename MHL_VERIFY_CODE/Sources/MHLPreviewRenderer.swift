import Foundation

enum MHLPreviewRenderer {
    static func render(_ source: String, dark: Bool = false) -> String {
        guard let document = try? MHLDocument.parse(source: source) else {
            return wrapHTML("<pre>\(escapeHTML(source))</pre>", theme: dark ? .dark : .light)
        }
        return render(document: document, dark: dark)
    }

    static func render(document: MHLDocument, dark: Bool = false) -> String {
        let theme = dark ? Theme.dark : Theme.light
        var html = ""

        let firstHash = document.hashes.first?.hashDate
        let lastHash = document.hashes.last?.hashDate

        html += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"\(theme.cell)\"><tr><td style=\"padding: 20px \(pad)px 16px \(pad)px;\">"
        html += "<font color=\"\(theme.accent)\" size=\"1\"><b>MEDIA HASH LIST</b></font><br>"
        html += "<font size=\"5\" face=\"-apple-system, Helvetica\" color=\"\(theme.text)\"><b>\(esc(document.title))</b></font>"
        html += "<br><font size=\"1\" face=\"Menlo\" color=\"\(theme.muted)\">version \(esc(document.version))</font>"
        if let tool = document.creatorInfo["tool"] {
            html += "<br><font size=\"2\" color=\"\(theme.label)\">\(esc(tool))</font>"
        }
        if let rootPath = document.rootPath {
            html += "<br><font size=\"1\" face=\"Menlo\" color=\"\(theme.muted)\">\(esc(rootPath))</font>"
        }
        html += "</td></tr></table>"

        html += sectionHeader("Summary", theme: theme)
        html += groupStart(theme: theme)
        html += cellRow("Files", "<font size=\"2\" color=\"\(theme.accent)\"><b>\(document.totalFiles)</b></font>", theme: theme)
        html += cellRow("Total Size", "<font size=\"2\" color=\"\(theme.text)\">\(esc(MHLDocument.formatByteCount(document.totalBytes)))</font>", theme: theme)
        if let startDate = document.creatorInfo["startdate"] {
            html += cellRow("Started", "<font size=\"2\" color=\"\(theme.text)\">\(esc(startDate))</font>", theme: theme)
        }
        if let finishDate = document.creatorInfo["finishdate"] {
            html += cellRow("Finished", "<font size=\"2\" color=\"\(theme.text)\">\(esc(finishDate))</font>", theme: theme)
        }
        if let firstHash {
            html += cellRow("First Hash", "<font size=\"2\" color=\"\(theme.text)\">\(esc(firstHash))</font>", theme: theme)
        }
        if let lastHash {
            html += cellRow("Last Hash", "<font size=\"2\" color=\"\(theme.text)\">\(esc(lastHash))</font>", theme: theme, last: true)
        } else {
            html += groupEnd()
        }
        if lastHash != nil {
            html += groupEnd()
        }

        if !document.sourceInfo.isEmpty {
            html += sectionHeader("Source Info", theme: theme)
            html += groupStart(theme: theme)
            let keys = document.sourceInfo.keys.sorted()
            for (index, key) in keys.enumerated() {
                html += cellRow(key, "<font size=\"2\" color=\"\(theme.text)\">\(esc(document.sourceInfo[key] ?? ""))</font>", theme: theme, last: index == keys.count - 1)
            }
            html += groupEnd()
        }

        if !document.creatorInfo.isEmpty {
            html += sectionHeader("Creator", theme: theme)
            html += groupStart(theme: theme)
            let keys = document.creatorInfo.keys.sorted()
            for (index, key) in keys.enumerated() {
                html += cellRow(key, "<font size=\"2\" color=\"\(theme.text)\">\(esc(document.creatorInfo[key] ?? ""))</font>", theme: theme, last: index == keys.count - 1)
            }
            html += groupEnd()
        }

        html += sectionHeader("Entries", theme: theme)
        for (index, entry) in document.hashes.prefix(25).enumerated() {
            html += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"padding: 10px \(pad)px 4px \(pad)px;\">"
            html += "<font size=\"1\" color=\"\(theme.label)\"><b>ENTRY \(index + 1)</b></font><br>"
            html += "<font size=\"2\" face=\"Menlo\" color=\"\(theme.text)\">\(esc(entry.file))</font>"
            html += "</td></tr></table>"
            html += groupStart(theme: theme)
            html += cellRow("Size", "<font size=\"2\" color=\"\(theme.text)\">\(esc(MHLDocument.formatByteCount(entry.size)))</font>", theme: theme)
            if let modified = entry.lastModificationDate {
                html += cellRow("Modified", "<font size=\"2\" color=\"\(theme.text)\">\(esc(modified))</font>", theme: theme)
            }
            if let hashDate = entry.hashDate {
                html += cellRow("Hash Date", "<font size=\"2\" color=\"\(theme.text)\">\(esc(hashDate))</font>", theme: theme)
            }
            if let xxhash64 = entry.xxHash64 {
                html += cellRow("xxHash64", "<font size=\"1\" face=\"Menlo\" color=\"\(theme.accent)\">\(esc(xxhash64))</font>", theme: theme)
            }
            if let xxhash64be = entry.xxHash64BE {
                html += cellRow("xxHash64 BE", "<font size=\"1\" face=\"Menlo\" color=\"\(theme.accent)\">\(esc(xxhash64be))</font>", theme: theme, last: true)
            } else {
                html += groupEnd()
                continue
            }
            html += groupEnd()
        }

        if document.hashes.count > 25 {
            html += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"padding: 8px \(pad)px 0 \(pad)px;\">"
            html += "<font size=\"1\" color=\"\(theme.muted)\">Showing first 25 of \(document.hashes.count) entries.</font>"
            html += "</td></tr></table>"
        }

        html += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">"
        html += "<tr><td style=\"padding: 28px \(pad)px 0 \(pad)px;\">\(thinLine(theme: theme))</td></tr>"
        html += "<tr><td style=\"padding: 8px \(pad)px 6px \(pad)px;\">"
        html += "<font size=\"1\" color=\"\(theme.muted)\"><b>XML SOURCE</b></font>"
        html += "</td></tr></table>"
        html += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td bgcolor=\"\(theme.cell)\" style=\"padding: 12px \(pad)px;\">"
        html += "<pre style=\"font: 11px/1.6 Menlo, monospace; margin: 0; white-space: pre-wrap; word-wrap: break-word; color: \(theme.key);\">\(escapeHTML(document.sourceXML))</pre>"
        html += "</td></tr></table>"

        return wrapHTML(html, theme: theme)
    }

    private static func sectionHeader(_ title: String, theme: Theme) -> String {
        "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"padding: 16px \(pad)px 6px \(pad)px;\">" +
        "<font size=\"1\" color=\"\(theme.label)\"><b>\(esc(title).uppercased())</b></font>" +
        "</td></tr></table>"
    }

    private static func groupStart(theme: Theme) -> String {
        "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"\(theme.cell)\">"
    }

    private static func groupEnd() -> String { "</table>" }

    private static func thinLine(theme: Theme) -> String {
        "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td bgcolor=\"\(theme.sep)\" style=\"font-size:1px; line-height:1px; height:1px;\">&nbsp;</td></tr></table>"
    }

    private static func thinSeparator(theme: Theme) -> String {
        "<tr><td colspan=\"2\" style=\"padding: 0 0 0 \(pad)px;\">\(thinLine(theme: theme))</td></tr>"
    }

    private static func cellRow(_ key: String, _ value: String, theme: Theme, last: Bool = false) -> String {
        var row = "<tr bgcolor=\"\(theme.cell)\"><td valign=\"top\" style=\"padding: 9px \(pad)px; width: 38%;\">"
        row += "<font size=\"2\" color=\"\(theme.key)\">\(esc(key))</font></td>"
        row += "<td valign=\"top\" style=\"padding: 9px \(pad)px;\">\(value)</td></tr>"
        if !last {
            row += thinSeparator(theme: theme)
        }
        return row
    }

    private static func wrapHTML(_ body: String, theme: Theme) -> String {
        """
        <html>
        <head>
        <meta charset="utf-8">
        <style>
        :root { color-scheme: \(theme == .dark ? "dark" : "light"); }
        body {
            margin: 0;
            padding: 0 0 40px 0;
            background: \(theme.bg);
            color: \(theme.text);
            font: 14px -apple-system, BlinkMacSystemFont, sans-serif;
        }
        table { border-collapse: collapse; }
        pre { overflow-wrap: anywhere; }
        </style>
        </head>
        <body>
        \(body)
        </body>
        </html>
        """
    }

    private static func escapeHTML(_ text: String) -> String {
        text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    private static func esc(_ text: String) -> String {
        escapeHTML(text)
    }

    private static let pad = 16

    private struct Theme: Equatable {
        let bg: String
        let cell: String
        let sep: String
        let text: String
        let key: String
        let label: String
        let muted: String
        let accent: String

        static let light = Theme(
            bg: "#f8fafc",
            cell: "#ffffff",
            sep: "#e2e8f0",
            text: "#0f172a",
            key: "#334155",
            label: "#64748b",
            muted: "#94a3b8",
            accent: "#2563eb"
        )

        static let dark = Theme(
            bg: "#1c1c1e",
            cell: "#2c2c2e",
            sep: "#38383a",
            text: "#f5f5f7",
            key: "#d1d1d6",
            label: "#98989d",
            muted: "#636366",
            accent: "#5ac8fa"
        )
    }
}
