import SwiftUI

struct CompareView: View {
    @Environment(\.dismiss) private var dismiss
    let comparison: MHLComparison

    @State private var filter: FileDiffFilter = .differencesOnly
    @State private var selectedFileDiffID: FileDiffRow.ID?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compare MHL Files")
                        .font(.system(size: 28, weight: .semibold))
                    Text(comparison.title)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }

            summaryHighlights

            HStack(alignment: .top, spacing: 16) {
                comparisonColumn(title: comparison.leftURL.lastPathComponent, document: comparison.leftDocument)
                comparisonColumn(title: comparison.rightURL.lastPathComponent, document: comparison.rightDocument)
            }

            GroupBox("Summary Differences") {
                differenceList(comparison.summaryDifferences, emptyText: "No summary-level differences.")
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("File-Level Differences")
                            .font(.headline)
                        Spacer()
                        Picker("Filter", selection: $filter) {
                            ForEach(FileDiffFilter.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 360)
                    }

                    fileDiffSummary

                    if filteredFileDiffRows.isEmpty {
                        Text(emptyStateText)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                    } else {
                        Table(filteredFileDiffRows, selection: $selectedFileDiffID) {
                            TableColumn("Status") { row in
                                statusBadge(row.status)
                            }
                            .width(min: 96, ideal: 110, max: 120)

                            TableColumn("Path") { row in
                                Text(row.path)
                                    .lineLimit(2)
                                    .textSelection(.enabled)
                            }

                            TableColumn("Left Size") { row in
                                Text(row.leftSizeDisplay)
                                    .foregroundStyle(.secondary)
                            }
                            .width(min: 96, ideal: 110, max: 130)

                            TableColumn("Right Size") { row in
                                Text(row.rightSizeDisplay)
                                    .foregroundStyle(.secondary)
                            }
                            .width(min: 96, ideal: 110, max: 130)

                            TableColumn("Left Hash") { row in
                                Text(row.leftHash ?? "-")
                                    .font(.system(.caption, design: .monospaced))
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            .width(min: 160, ideal: 220, max: 260)

                            TableColumn("Right Hash") { row in
                                Text(row.rightHash ?? "-")
                                    .font(.system(.caption, design: .monospaced))
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            .width(min: 160, ideal: 220, max: 260)
                        }
                        .frame(minHeight: 260)
                    }

                    fileDiffDetail
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .frame(minWidth: 1100, minHeight: 820, alignment: .topLeading)
        .onAppear {
            selectedFileDiffID = filteredFileDiffRows.first?.id
        }
        .onChange(of: filter) { _ in
            selectedFileDiffID = filteredFileDiffRows.first?.id
        }
    }

    private var filteredFileDiffRows: [FileDiffRow] {
        switch filter {
        case .differencesOnly:
            return comparison.fileDiffRows.filter { $0.status != .unchanged }
        case .changedOnly:
            return comparison.fileDiffRows.filter { $0.status == .changed }
        case .addedRemoved:
            return comparison.fileDiffRows.filter { $0.status == .added || $0.status == .removed }
        case .allFiles:
            return comparison.fileDiffRows
        }
    }

    private var selectedFileDiff: FileDiffRow? {
        guard let selectedFileDiffID else { return filteredFileDiffRows.first }
        return filteredFileDiffRows.first(where: { $0.id == selectedFileDiffID }) ?? filteredFileDiffRows.first
    }

    private var emptyStateText: String {
        switch filter {
        case .differencesOnly:
            return "No differing file entries were found."
        case .changedOnly:
            return "No changed file entries were found."
        case .addedRemoved:
            return "No added or removed file entries were found."
        case .allFiles:
            return "No file entries were found."
        }
    }

    private var fileDiffSummary: some View {
        let summary = comparison.fileDiffSummary
        return HStack(spacing: 12) {
            summaryChip(title: "Changed", count: summary.changed, color: .orange)
            summaryChip(title: "Added", count: summary.added, color: .green)
            summaryChip(title: "Removed", count: summary.removed, color: .red)
            summaryChip(title: "Unchanged", count: summary.unchanged, color: .secondary)
        }
    }

    private var fileDiffDetail: some View {
        GroupBox("Selected File Details") {
            if let row = selectedFileDiff {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(row.path)
                            .font(.headline)
                            .textSelection(.enabled)
                        Spacer()
                        statusBadge(row.status)
                    }

                    detailRow(label: "Left Size", leftValue: row.leftSizeDisplay, rightLabel: "Right Size", rightValue: row.rightSizeDisplay)
                    detailRow(label: "Left Hash", leftValue: row.leftHash ?? "-", rightLabel: "Right Hash", rightValue: row.rightHash ?? "-")
                    detailRow(label: "Left Date", leftValue: row.leftDate ?? "-", rightLabel: "Right Date", rightValue: row.rightDate ?? "-")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Select a file row to inspect its left and right metadata.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
    }

    private var summaryHighlights: some View {
        HStack(spacing: 12) {
            highlightCard(for: "Files")
            highlightCard(for: "Total Size")
            highlightCard(for: "Version", left: comparison.leftDocument.version, right: comparison.rightDocument.version)
        }
    }

    private func comparisonColumn(title: String, document: MHLDocument) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                ForEach(document.summary, id: \.0) { row in
                    HStack(alignment: .top) {
                        Text(row.0)
                            .foregroundStyle(.secondary)
                            .frame(width: 120, alignment: .leading)
                        Text(row.1)
                            .textSelection(.enabled)
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func highlightCard(for label: String, left: String? = nil, right: String? = nil) -> some View {
        let row = ComparisonRow(
            label: label,
            leftValue: left ?? comparison.summaryRows.first(where: { $0.label == label })?.leftValue ?? "-",
            rightValue: right ?? comparison.summaryRows.first(where: { $0.label == label })?.rightValue ?? "-"
        )

        let accent = row.isMatch ? Color.green : Color.red

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(row.isMatch ? "Match" : "Diff")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accent.opacity(0.16), in: Capsule())
                    .foregroundStyle(accent)
            }
            Text(row.leftValue)
                .font(.title3.weight(.semibold))
                .foregroundStyle(accent)
            Text("Right: \(row.rightValue)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(nsColor: NSColor.windowBackgroundColor).opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accent.opacity(0.35), lineWidth: 1)
        )
    }

    private func differenceList(_ rows: [ComparisonRow], emptyText: String) -> some View {
        Group {
            if rows.isEmpty {
                Text(emptyText)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            } else {
                List(rows) { row in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(row.label)
                                .font(.headline)
                            Spacer()
                            Text(row.isMatch ? "Match" : "Different")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background((row.isMatch ? Color.green : Color.red).opacity(0.16), in: Capsule())
                                .foregroundStyle(row.isMatch ? Color.green : Color.red)
                        }
                        valueRow(label: "Left", value: row.leftValue, isMatch: row.isMatch)
                        valueRow(label: "Right", value: row.rightValue, isMatch: row.isMatch)
                    }
                    .padding(.vertical, 6)
                }
                .frame(minHeight: 180)
            }
        }
    }

    private func valueRow(label: String, value: String, isMatch: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 48, alignment: .leading)
            Text(value)
                .foregroundStyle(isMatch ? Color.green : .primary)
                .textSelection(.enabled)
            Spacer(minLength: 0)
        }
    }

    private func detailRow(label: String, leftValue: String, rightLabel: String, rightValue: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(leftValue)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(rightLabel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(rightValue)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func summaryChip(title: String, count: Int, color: Color) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .foregroundStyle(.secondary)
            Text(String(count))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: NSColor.windowBackgroundColor).opacity(0.45), in: Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }

    private func statusBadge(_ status: FileDiffStatus) -> some View {
        let color: Color
        switch status {
        case .added:
            color = .green
        case .removed:
            color = .red
        case .changed:
            color = .orange
        case .unchanged:
            color = .secondary
        }

        return Text(status.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.14), in: Capsule())
            .foregroundStyle(color)
    }
}
