import Foundation

let version = "CutBox v1.5.8 - command line v0.0.75"

let plistPath = "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist"
let historyKey = "historyStore"
let stringKey = "string"
let timestampKey = "timestamp"
let favoriteKey = "favorite"
let isFavorite = "favorite"
let usage = """
OVERVIEW:
        CutBox history CLI

USAGE:  cutbox [options]

        Display items from CutBox history. Recent items first.

OPTIONS:
        -l or --limit <num>                Return first num items

        Search

        -f or --fuzzy <query>              Fuzzy match items
        -r or --regex <query>              Regexp match items
        -i or --regexi <query>             Regexp match items (case insensitive)

        --favorites                        Only favorites

        Filter by Date / time

        --before-date <ISO 8601 datetime>  e.g. 2023-06-05T09:21:59Z
        --since-date <ISO 8601 datetime>

        --before-seconds-ago <seconds>
        --since-seconds-ago <seconds>

        --before-minutes-ago <minutes>
        --since-minutes-ago <minutes>

        --before-hours-ago <hours>
        --since-hours-ago <hours>

        --before-days-ago <days>
        --since-days-ago <days>

        Misc

        --missing-date                     Display history items with no date (before CutBox v1.5.5)

        --version                          \(version)

        -h or --help show this message.
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
        if let string:String = hasOpt(opt) {
            return Int(string)
        }
        return nil
    }

    private func hasOpt(_ opt: [String]) -> Int? {
        let found = opt.compactMap({ (s: String) -> Int? in hasOpt(s) })
        if found.count > 0 {
            return found[0]
        }
        return nil
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
        let found = opt.compactMap({ (s) -> String? in hasOpt(s) })
        if found.count > 0 {
            return found[0]
        }
        return nil
    }

    func timeOpt(_ opt: String) -> TimeInterval? {
        if let value: String = hasOpt(opt) {
            let nsOpt = opt as NSString
            switch nsOpt {
            case _ where nsOpt.contains("date"):
                if let date = dateFormatter.date(from: value) {
                    return date.timeIntervalSince1970
                }
            case _ where nsOpt.contains("seconds"):
                if let seconds = Double(value) {
                    return Date().timeIntervalSince1970 - seconds
                }
            case _ where nsOpt.contains("minutes"):
                if let minutes = Double(value) {
                    return Date().timeIntervalSince1970 - minutes * 60
                }
            case _ where nsOpt.contains("hours"):
                if let hours = Double(value) {
                    return Date().timeIntervalSince1970 - hours * 3600
                }
            case _ where nsOpt.contains("days"):
                if let days = Double(value) {
                    return Date().timeIntervalSince1970 - days * 86400
                }
            default:
                break
            }
        }
        return nil
    }

    private func parseTimeOptions(_ prefix: String) -> TimeInterval? {
        let timeLevels = [
          "date",
          "days-ago",
          "hours-ago",
          "minutes-ago",
          "seconds-ago"
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
        beforeDate = parseTimeOptions("--before-")
        sinceDate = parseTimeOptions("--since-")

        // Favorites
        favorites = hasFlag("--favorites")

        // Favorites
        missingDate = hasFlag("--missing-date")

        // Limit
        limit = hasOpt(["-l", "--limit"])
    }
}

let params = CommandParams()

func regexpMatch(_ string: String, _ pattern: String, caseSensitive: Bool = true) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    if caseSensitive {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    } else {
        let regexOptions: NSRegularExpression.Options = [.caseInsensitive]
        let regex = try! NSRegularExpression(pattern: pattern, options: regexOptions)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    }
}

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

var historyStrings: [String] = historyDict.compactMap { n in
    guard let item = n[stringKey] as? String else { return nil }

    if params.favorites && ((n[favoriteKey] as? String) != isFavorite) {
        return nil
    }

    if let dateString = n[timestampKey] as? String,
       let date = dateFormatter.date(from: dateString)?.timeIntervalSince1970 {

        if let beforeDate = params.beforeDate, date >= beforeDate {
            return nil
        }

        if let sinceDate = params.sinceDate, date <= sinceDate {
            return nil
        }
    }

    if params.missingDate {
        if n[timestampKey] == nil {
            return item
        } else {
            return nil
        }
    }

    return item
}

if let query = params.query {
    switch (params.searchMode) {
    case .fuzzy: historyStrings = historyStrings.filter { $0.contains(query) }
    case .regex: historyStrings = historyStrings.filter { regexpMatch($0, query) }
    case .regexi: historyStrings = historyStrings.filter { regexpMatch($0, query, caseSensitive: false)}
    default: break
    }
}

if let limit = params.limit {
    print(historyStrings.prefix(limit).joined(separator: "\n"))
} else {
    print(historyStrings.joined(separator: "\n"))
}
