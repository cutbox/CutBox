import Foundation

let version = "v0.2.0"

struct HistoryEntry {
    let string: String
    let timestamp: String?
    let favorite: String?

    var timeIntervalSince1970: Double? {
        guard let isotime = timestamp else {
            return nil
        }

        let dateFormatter: DateFormatter = iso8601()

        return dateFormatter
            .date(from: isotime)?.timeIntervalSince1970
    }
}

enum SearchMode {
    case fuzzy, regex, regexi
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

class CommandParams {
    var query: String?
    var limit: Int?
    var beforeDate: TimeInterval?
    var sinceDate: TimeInterval?
    var searchMode: SearchMode?
    var missingDate: Bool = false
    var favorites: Bool = false
    var showTime: Bool = false

    private var out: POutput

    init(out: POutput) {
        self.out = out
        parse()
    }

    private func hasFlag(_ flag: String) -> Bool {
        return CommandLine.arguments.contains(flag)
    }

    private func hasFlag(_ flag: [String]) -> Bool {
        return flag.contains { hasFlag($0) }
    }

    private func hasOpt<T>(_ opts: String...) -> T? {
        let args = CommandLine.arguments
        guard let index = args.firstIndex(where: { opts.contains($0) }),
              let valueIndex = args.index(index, offsetBy: 1, limitedBy: args.endIndex),
              !args[valueIndex].starts(with: "-") else {
            return nil
        }

        let value = args[valueIndex]

        switch T.self {
        case is String.Type:
            return value as? T
        case is Int.Type:
            return Int(value) as? T
        case is Double.Type:
            return Double(value) as? T
        default:
            return nil
        }
    }

    private func filterNums(_ string: String) -> Double? {
        return Double(string.filter { $0 == "." || $0 >= "0" && $0 <= "9" })
    }

    private let timeUnitsTable = [
        (pattern: "m|minutes|min|mins|minute", factor: 60.0),
        (pattern: "h|hours|hr|hrs|hour", factor: 60.0 * 60.0),
        (pattern: "d|days|day", factor: 24.0 * 60.0 * 60.0),
        (pattern: "w|week|weeks|wk|wks", factor: 7.0 * 24.0 * 60.0 * 60.0),
        (pattern: "s|sec|secs|second|seconds", factor: 1.0)
    ]

    private func parseToSeconds(_ time: String) -> Double? {
        if let seconds = filterNums(time) {
            return timeUnitsTable.compactMap { (unit: (pattern: String, factor: Double)) -> Double? in
                if regexpMatch(time, unit.pattern, caseSensitive: false) {
                    return seconds * unit.factor
                }
                return nil
            }.first
        }
        return nil
    }

    private func timeOpt(_ option: String) -> TimeInterval? {

        if let value: String = hasOpt(option) {
            let opt = option as NSString
            switch opt {
            case _ where opt.contains("date"):
                if let date = iso8601().date(from: value) {
                    return date.timeIntervalSince1970
                }
            case _ where parseToSeconds(value) != nil:
                if let seconds = parseToSeconds(value) {
                    return Date().timeIntervalSince1970 - seconds
                }
            default:
                break
            }
        }
        return nil
    }

    private func parseTimeOptions(_ prefix: String) -> TimeInterval? {
        let timeOptionSuffixes = ["", "-date"]
        return timeOptionSuffixes
            .map { "\(prefix)\($0)" }
            .compactMap { timeOpt($0) }
            .first
    }

    private func parse() {
        for infoFlag in  [
            (["-h", "--help"], usageInfo()),
            (["--version"], version)
        ]
        where hasFlag(infoFlag.0) {
            out.log(infoFlag.1)
            exit(0)
        }

        favorites = hasFlag(["-F", "--favorites", "--favorite"])
        missingDate = hasFlag(["-M", "--missing-date", "--missing-time"])

        beforeDate = parseTimeOptions("--before")
        sinceDate = parseTimeOptions("--since")

        limit = hasOpt("-l", "--limit")

        showTime = hasFlag(["-T", "--show-time", "--show-date"])

        if let rawQuery: String = hasOpt("-f", "--fuzzy") {
            searchMode = SearchMode.fuzzy
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        if let rawQuery: String = hasOpt("-r", "--regex") {
            searchMode = SearchMode.regex
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        if let rawQuery: String = hasOpt("-i", "--regexi") {
            searchMode = SearchMode.regexi
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }
    }
}

struct HistoryManager {
    let plist: [String: Any]
    let stringKey = "string"
    let timestampKey = "timestamp"
    let favoriteKey = "favorite"

    init(plist: [String: Any]) {
        self.plist = plist
    }

    func loadHistoryEntries() -> [HistoryEntry] {
        guard let historyDict = plist["historyStore"] as? [[String: Any?]] else {
            return []
        }

        return historyDict.compactMap { itemAsHistoryEntry($0 as [String : Any]) }
    }

    func itemAsHistoryEntry(_ item: [String: Any]) -> HistoryEntry? {
        guard let string: String = item[stringKey] as? String else {
            return nil
        }

        return HistoryEntry(string: string,
                            timestamp: item[timestampKey] as? String,
                            favorite: item[favoriteKey] as? String)
    }

    func filterEntries(_ entries: [HistoryEntry], params: CommandParams) -> [HistoryEntry] {
        var filteredEntries = entries

        if params.favorites {
            filteredEntries = filteredEntries.filter { entry in
                return entry.favorite == "favorite"
            }
        }

        if params.missingDate {
            filteredEntries = filteredEntries.filter { entry in
                return entry.timestamp == nil
            }
        }

        if let sinceDate = params.sinceDate {
            filteredEntries = filteredEntries.filter { entry in
                if entry.timestamp != nil {
                    return Double(entry.timeIntervalSince1970!) >= sinceDate
                }
                return false
            }
        }

        if let beforeDate = params.beforeDate {
            filteredEntries = filteredEntries.filter { entry in
                if entry.timestamp != nil {
                    return Double(entry.timeIntervalSince1970!) <= beforeDate
                }
                return false
            }
        }

        if let limit = params.limit {
            filteredEntries = Array(filteredEntries.prefix(limit))
        }

        return filteredEntries
    }

    func searchEntries(_ entries: [HistoryEntry], params: CommandParams) -> [HistoryEntry] {
        guard let query = params.query, let searchMode = params.searchMode else {
            return entries
        }

        return entries.filter { entry in
            switch searchMode {
            case .fuzzy:
                return entry.string.localizedCaseInsensitiveContains(query)
            case .regex:
                return regexpMatch(entry.string, query)
            case .regexi:
                return regexpMatch(entry.string, query, caseSensitive: false)
            }
        }
    }
}

struct OutputManager {
    private func printItemWithTime(_ item: HistoryEntry) -> String {
        return "\(item.timestamp ?? "UNKNOWN DATETIME"): \(item.string)"
    }

    private func printItem(_ item: HistoryEntry) -> String {
        return item.string
    }

    func printEntries(_ entries: [HistoryEntry], params: CommandParams, out: POutput) {
        let log = out.log
        let printFunc: (HistoryEntry) -> String
        if params.showTime {
            printFunc = printItemWithTime
        } else {
            printFunc = printItem
        }
        let formattedEntries = entries.map(printFunc).joined(separator: "\n")
        log(formattedEntries)
    }
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

public protocol POutput {
    func log(_ string: String)
}

public class Output: POutput {
    public init() {
    }

    public func log(_ string: String) {
        print(string)
    }
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

public func cutBoxCliMain(out: POutput, plist: [String: Any]) {
    let log = out.log
    let args = CommandLine.arguments

    if args.contains("-h") || args.contains("--help") {
        log(usageInfo())
        return
    }

    let params = CommandParams(out: out)

    let historyManager = HistoryManager(plist: plist)
    var historyEntries = historyManager.loadHistoryEntries()

    historyEntries = historyManager.filterEntries(historyEntries, params: params)
    historyEntries = historyManager.searchEntries(historyEntries, params: params)

    let outputManager = OutputManager()
    outputManager.printEntries(historyEntries, params: params, out: out)
}
