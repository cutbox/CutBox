import Foundation

let version = "v0.2.0"

enum SearchMode {
    case fuzzy, regex, regexi, exact
}

public func cutBoxCliMain(out: Output, plist: [String: Any]) {
    let params = CommandParams(out: out,
                               arguments: CommandLine.arguments)

    if !params.infoFlags {
        if params.errors.isEmpty {
            let historyManager = HistoryManager(plist: plist)
            var historyEntries = historyManager.loadHistoryEntries()

            historyEntries = historyManager.filterEntries(historyEntries, params: params)
            historyEntries = historyManager.searchEntries(historyEntries, params: params)

            let outputManager = OutputManager()
            outputManager.printEntries(historyEntries, params: params, out: out)
        } else {
            params.printErrors()
        }
    }
}
