import Foundation

let version = "v0.2.0"

enum SearchMode {
    case fuzzy, regex, regexi, string
}

func regexpMatch(_ string: String, _ pattern: String, caseSensitive: Bool = true) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    if caseSensitive {
        if let regex = try? NSRegularExpression(pattern: pattern) {
            return regex.firstMatch(in: string, options: [], range: range) != nil
        }
    } else {
        let regexOptions: NSRegularExpression.Options = [.caseInsensitive]
        if let regex = try? NSRegularExpression(pattern: pattern, options: regexOptions) {
            return regex.firstMatch(in: string, options: [], range: range) != nil
        }
    }
    return false
}

func usageInfo() -> String {
    return """
    CutBox history CLI
    ==================

    Display items from CutBox history. Most recent items first.

        cutbox [options]

    Options:
    ========

    Search
    ------

        -f or --fuzzy <query>   Fuzzy match items (case insensitive)
        -r or --regex <query>   Regexp match items
        -i or --regexi <query>  Regexp match items (case insensitive)
        -e or --exact <string>  Exact substring match items (case sensitive)

    Filtering
    ---------

        -l or --limit <num>     Limit to num items
        -F or --favorites       Only list favorites
        -M or --missing-date    Only list items missing a date (copied pre CutBox v1.5.5)

    Filter by time units e.g. 7d, 1min, 5hr, 30s, 25sec, 3days, 2wks, 1.5hours, etc.
    Supports seconds, minutes, hours, days, weeks.

        --since <time>
        --before <time>

    Filter by ISO 8601 date e.g. 2023-06-05T09:21:59Z

        --since-date <date>
        --before-date <date>

    Info
    ----

        --version               Show the current version
        -h or --help            Show this help page
    """
}

public func iso8601() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
}

public func loadPlist(path: String) -> [String: Any] {
    guard let data = FileManager.default.contents(atPath: path),
          let plist = try? PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil) as? [String: Any] else {
        fatalError("Cannot read file at \(path)")
    }
    return plist
}

public func cutBoxCliMain(out: Output, plist: [String: Any]) {
    let args = CommandLine.arguments

    if args.contains("-h") || args.contains("--help") {
        out.print(usageInfo())
        return
    }

    let params = CommandParams(out: out, arguments: CommandLine.arguments)

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
