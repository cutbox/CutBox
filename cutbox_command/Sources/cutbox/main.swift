import Foundation

let version = "CutBox v1.5.8 - command line v0.0.110"

let plistPath = "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist"
let historyKey = "historyStore"
let stringKey = "string"
let timestampKey = "timestamp"
let favoriteKey = "favorite"
let isFavorite = "favorite"
let usage = """
    CutBox history CLI
    ==================

    Display items from CutBox history. Most recent items first.

        cutbox [options]

    Options:
    ========

    Search
    ------

    Note: Search modes are mutually exclusive

        -f or --fuzzy <query>   Fuzzy match items (case insensitive)
        -r or --regex <query>   Regexp match items
        -i or --regexi <query>  Regexp match items (case insensitive)

    Filtering
    ---------

    Filter flags

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

    private let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        parse()
    }

    private func hasFlag(_ flag: String) -> Bool {
        let args = CommandLine.arguments
        if args.contains(flag) {
            return true
        }
        return false
    }

    private func hasFlag(_ flag: [String]) -> Bool {
        return flag.map { hasFlag($0) }.contains(true)
    }

    private func hasOpt<T>(_ opts: String...) -> T? {
        let args = CommandLine.arguments
        for opt in opts {
            if let index = args.firstIndex(of: opt) {
                if args.indices.contains(index+1) && !args[index+1].starts(with: "-") {
                    if let value = args[index+1] as? T {
                        return value
                    }
                }
            }
        }
        return nil
    }

    /// Filter out non-numeric chars from string
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

    /// Parse string to optional time interval. Any non-numeric chars will be
    /// filtered out after matching on seconds (or s,sec,secs), minutes (or
    /// m,min,mins), hours (or h,hr,hrs), days (or d,day). (case insensitive)
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
                if let date = dateFormatter.date(from: value) {
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
        let timeOptions = [
          "",
          "-date"
        ]

        return timeOptions
          .map { "\(prefix)\($0)" }
          .compactMap { timeOpt($0) }
          .first
    }

    private func parse() {
        for infoFlag in  [
              (["-h", "--help"], usage),
              (["--version"], version)
            ]
            where hasFlag(infoFlag.0) {
            print(infoFlag.1)
            exit(0)
        }

        favorites = hasFlag(["-F", "--favorites", "--favorite"])
        missingDate = hasFlag(["-M", "--missing-date", "--missing-time"])

        // Date
        beforeDate = parseTimeOptions("--before")
        sinceDate = parseTimeOptions("--since")

        // Limit
        limit = hasOpt("-l", "--limit")

        showTime = hasFlag(["-T", "--show-time", "--show-date"])

        // Search
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

let params = CommandParams()

// Read cutbox history"
guard let plistData = FileManager.default.contents(atPath: plistPath) else {
    print("CutBox history not found, is CutBox installed?")
    exit(1)
}

guard let plist = try PropertyListSerialization.propertyList(from: plistData,
                                                             options: [],
                                                             format: nil) as? [String: Any] else {
    print("Error: CutBox history file was not readable.")
    exit(1)
}

guard let historyDict = plist[historyKey] as? [[String: Any]] else {
    print("""
            Error: CutBox history store was not in the expected format.
            Recommended Action: Check with earlier version of cutbox command-line utility.
            """)
    exit(1)
}

// create list of strings from history
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

typealias HistoryEntry = (String, String?)

func itemAsHistoryEntry(_ item: [String: Any]) -> HistoryEntry? {
    guard let string: String = item[stringKey] as? String else {
        return nil
    }

    return (string, item[timestampKey] as? String)
}

var historyEntries: [HistoryEntry] = historyDict.compactMap { (item: [String: Any] ) -> HistoryEntry? in
    if params.favorites && (item[favoriteKey] as? String) != isFavorite {
        return nil
    }

    guard let historyEntry: HistoryEntry = itemAsHistoryEntry(item) else {
        return nil
    }

    if let dateString = historyEntry.1,
       let date = dateFormatter.date(from: dateString)?.timeIntervalSince1970 {
        if let beforeDate = params.beforeDate,
           date >= beforeDate {
            return nil
        }

        if let sinceDate = params.sinceDate, date <= sinceDate {
            return nil
        }
    }

    if params.missingDate {
        if historyEntry.1 == nil {
            return historyEntry
        } else {
            return nil
        }
    }

    return historyEntry
}

if let query = params.query {
    switch params.searchMode {
    case .fuzzy: historyEntries = historyEntries.filter {  $0.0.contains(query) }
    case .regex: historyEntries = historyEntries.filter { regexpMatch($0.0, query) }
    case .regexi: historyEntries = historyEntries.filter { regexpMatch($0.0, query, caseSensitive: false) }
    default: break
    }
}

func printItemWithTime(_ item: HistoryEntry) -> String {
    return "\(item.1 ?? "UNKNOWN DATETIME"): \(item.0)"
}

func printItem(_ item: HistoryEntry) -> String {
    return item.0
}

if params.showTime {
    if let limit = params.limit {
        print(historyEntries.map(printItemWithTime).prefix(limit).joined(separator: "\n"))
    } else {
        print(historyEntries.map(printItemWithTime).joined(separator: "\n"))
    }

} else {
    if let limit = params.limit {
        print(historyEntries.map(printItem).prefix(limit).joined(separator: "\n"))
    } else {
        print(historyEntries.map(printItem).joined(separator: "\n"))
    }
}
