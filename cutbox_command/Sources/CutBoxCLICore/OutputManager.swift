import Foundation

struct OutputManager {
    func printItemWithTime(_ item: HistoryEntry) -> String {
        return "\(item.timestamp ?? "UNKNOWN DATETIME"): \(item.string)"
    }

    func printItem(_ item: HistoryEntry) -> String {
        return item.string
    }

    func printEntries(_ entries: [HistoryEntry], params: CommandParams, out: Output) {
        let printFunc: (HistoryEntry) -> String
        if params.showTime {
            printFunc = printItemWithTime
        } else {
            printFunc = printItem
        }

        let formattedEntries = entries.map(printFunc).joined(separator: "\n")
        out.print(formattedEntries)
    }
}
