import Foundation

let version = "CutBox v1.5.8 - command line v0.0.95"

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

OPTIONS
-------

    -l or --limit <num>        Limit to num items

Search
------

Note: Search modes are mutually exclusive

    -f or --fuzzy <query>      Fuzzy match items (case insensitive)
    -r or --regex <query>      Regexp match items
    -i or --regexi <query>     Regexp match items (case insensitive)

Filtering
---------

Filter flags

    --favorites                Only list favorites
    --missing-date             Only list items missing a date (copied pre CutBox v1.5.5)

Filter by ISO 8601 datetime e.g. 2023-06-05T09:21:59Z

    --since-date <datetime>
    --before-date <datetime>

Filter by time units e.g. 7d, 1min, 5hr, 30s, 25sec, 3days, 1.5hours.
Supports seconds, minutes, hours, days, weeks.

    --since <time>
    --before <time>

Misc
----


    --version        Show the current version

    -h or --help     Show this help page
"""

enum SearchMode {
    case fuzzy, regex, regexi
}

class CommandParams {
    var query: String?
    var limit: Int?
    var beforeDate: TimeInterval?
    var sinceDate: TimeInterval?
    var searchMode: SearchMode?
    var missingDate: Bool = false
    var favorites: Bool = false

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

    private func hasOpt(_ opt: String) -> Int? {
        if let string: String = hasOpt(opt) {
            return Int(string)
        }
        return nil
    }

    private func hasOpt(_ opt: [String]) -> Int? {
        return opt.compactMap({ (string: String) -> Int? in hasOpt(string) }).first
    }

    private func hasOpt(_ opt: String) -> String? {
        let args = CommandLine.arguments
        if let index = args.firstIndex(of: opt) {
            if args.indices.contains(index+1) && !args[index+1].starts(with: "-") {
                return args[index+1]
            }
        }
        return nil
    }

    private func hasOpt(_ opt: [String]) -> String? {
        return opt.compactMap({ (string) -> String? in hasOpt(string) }).first
    }

    /// Filter out non-numeric chars from string
    private func filterNums(_ string: String) -> Double? {
        return Double(string.filter { $0 == "." || $0 >= "0" && $0 <= "9" })
    }

    private let timeUnitsTable = [
      (pattern: "m|minutes|min|minute",      factor: 60.0),
      (pattern: "h|hours|hr|hrs|hour",       factor: 60.0 * 60.0),
      (pattern: "d|days|day",                factor: 24.0 * 60.0 * 60.0),
      (pattern: "w|week|weeks|wk|wks",       factor: 7.0 * 24.0 * 60.0 * 60.0),
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
        let timeLevels = [
          "",
          "-date",
          "-days-ago",
          "-hours-ago",
          "-minutes-ago",
          "-seconds-ago"
        ]

        return timeLevels
          .map { "\(prefix)\($0)" }
          .compactMap { timeOpt($0) }
          .first
    }

    private func parse() {
        // Show usage for -h or --help or help arg
        if hasFlag(["-h", "--help"]) {
            print(usage)
            exit(0)
        }

        if hasFlag(["--version"]) {
            print(version)
            exit(0)
        }

        // check for fuzzy opt
        if let rawQuery: String = hasOpt(["-f", "--fuzzy"]) {
            searchMode = SearchMode.fuzzy
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        // check for regex opt
        if let rawQuery: String = hasOpt(["-r", "--regex"]) {
            searchMode = SearchMode.regex
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        // check for regexi opt
        if let rawQuery: String = hasOpt(["-i", "--regexi"]) {
            searchMode = SearchMode.regexi
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        // Date
        beforeDate = parseTimeOptions("--before")
        sinceDate = parseTimeOptions("--since")

        // Favorites
        favorites = hasFlag("--favorites")

        // Favorites
        missingDate = hasFlag("--missing-date")

        // Limit
        limit = hasOpt(["-l", "--limit"])
    }
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

var historyStrings: [String] = historyDict.compactMap { item in
    guard let text = item[stringKey] as? String else { return nil }

    if params.favorites && ((item[favoriteKey] as? String) != isFavorite) {
        return nil
    }

    if let dateString = item[timestampKey] as? String,
       let date = dateFormatter.date(from: dateString)?.timeIntervalSince1970 {

        if let beforeDate = params.beforeDate, date >= beforeDate {
            return nil
        }

        if let sinceDate = params.sinceDate, date <= sinceDate {
            return nil
        }
    }

    if params.missingDate {
        if item[timestampKey] == nil {
            return text
        } else {
            return nil
        }
    }

    return text
}

if let query = params.query {
    switch params.searchMode {
    case .fuzzy: historyStrings = historyStrings.filter { $0.contains(query) }
    case .regex: historyStrings = historyStrings.filter { regexpMatch($0, query) }
    case .regexi: historyStrings = historyStrings.filter { regexpMatch($0, query, caseSensitive: false) }
    default: break
    }
}

if let limit = params.limit {
    print(historyStrings.prefix(limit).joined(separator: "\n"))
} else {
    print(historyStrings.joined(separator: "\n"))
}
