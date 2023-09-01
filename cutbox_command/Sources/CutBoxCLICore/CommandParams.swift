import Foundation

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

/// Manages command parameters
///
/// After parsing these properties are available to other objects:
/// - query - search text/pattern
/// - searchMode - fuzzy, regex, regexi, exact
/// - beforeDate - limit search to items before date
/// - sinceDate - limit search to items since date
/// - favorites - limit search to favorites
/// - limit - limit search by num results printed
/// - missingDate - a check for items saved ≤ v1.5.8
///
/// The parser removes valid arguments, remaining arguments are
/// collected as errors.
class CommandParams {
    var query: String?
    var limit: Int?
    var beforeDate: TimeInterval?
    var sinceDate: TimeInterval?
    var searchMode: SearchMode?
    var missingDate: Bool = false
    var favorites: Bool = false
    var showTime: Bool = false
    var errors: [(String, String)] = []
    var arguments: [String]
    var infoFlags: Bool = false

    private var out: Output

    /// Initialize with `Output` & arguments.
    /// Parsing begins automatically at init.
    init(out: Output, arguments: [String]) {
        self.out = out
        self.arguments = arguments
        parse()
    }

    /// Check for a flag in arguments
    func hasFlag(_ flag: String) -> Bool {
        if self.arguments.contains(flag) {
            removeFlagFromArguments(flag)
            return true
        }
        return false
    }

    /// Check for array of flags in arguments (variadic)
    func hasFlag(_ flags: String...) -> Bool {
        return hasFlag(flags)
    }

    /// Check for array of flags in arguments (array)
    func hasFlag(_ flags: [String]) -> Bool {
        return flags.contains(where: hasFlag)
    }

    /// Remove a flag from arguments
    ///
    /// Arguments remaining after parse are treated as errors.
    func removeFlagFromArguments(_ arg: String) {
        if let argIndex = self.arguments.firstIndex(of: arg) {
            self.arguments.remove(at: argIndex)
        }
    }

    /// Remove an argument and value by arg name
    ///
    /// Arguments remaining after parse are treated as errors.
    func removeOptionWithValueFromArguments<T>(_ arg: String, _ value: T?) {
        if let argIndex = self.arguments.firstIndex(of: arg) {
            self.arguments.remove(at: argIndex)
            if let value = value, let valueIndex = self.arguments
                .firstIndex(of: String(describing: value)) {
                self.arguments.remove(at: valueIndex)
            }
        }
    }

    /// Print all errors
    func printErrors() {
        errors.forEach(printError)
    }

    /// Print an error
    func printError(error: (String, String)) {
        out.error("Invalid argument: \(error.0) \(error.1)")
    }

    /// Check arguments for options (variadic)
    ///
    /// Parse option(s) (variadic) for their paired value and removed
    /// from arguments. The value of type T is returned when T is
    /// String, Int or Double.
    ///
    /// - Warning: **Fatal assertion** thrown if T is an unsupported type.
    func hasOption<T>(_ options: String...) -> T? {
        let args = self.arguments
        guard let index = args.firstIndex(where: { options.contains($0) }),
              let valueIndex = args.index(index, offsetBy: 1, limitedBy: args.endIndex),
              !args[valueIndex].starts(with: "-") else {
            return nil
        }

        let value = args[valueIndex]

        switch T.self {
        case is String.Type:
            removeOptionWithValueFromArguments(args[index], value)
            return value as? T
        case is Int.Type:
            removeOptionWithValueFromArguments(args[index], value)
            return Int(value) as? T
        case is Double.Type:
            removeOptionWithValueFromArguments(args[index], value)
            return Double(value) as? T
        default:
            fatalError("hasOpt only supports T.Type of String?, Double? or Int? ")
        }
    }

    /// Collect an error, add it to errors.
    func collectError(_ option: String, _ value: Any, description: String = "") {
        errors.append((option, String(describing: value)))
    }

    /// Collect all errors from arguments.
    ///
    /// Note when this is called, all arguments supplied are considered errors.
    func collectErrors(_ arguments: [String]) {
        var currentOption: String?
        var currentValue: String = ""

        for arg in arguments {
            if arg.hasPrefix("-") {
                if let opt = currentOption {
                    collectError(opt, currentValue)
                }
                currentOption = arg
                currentValue = ""
            } else {
                currentValue += currentValue.isEmpty ? arg : " \(arg)"
            }
        }

        if let option = currentOption {
            collectError(option, currentValue)
        }
    }

    /// Calls timeOption using a given prefix, e.g. before, since.
    /// It will check for `$option...`: `--$prefix-date` and `--$prefix`
    ///
    /// Returns `TimeInterval?` from `timeOption($option)`
    ///
    /// See: `timeOption(_ options: String) -> TimeInterval?`
    func parseTimeOptions(_ prefix: String) -> TimeInterval? {
        let timeOptionSuffixes = ["", "-date"]
        return timeOptionSuffixes
            .map { "\(prefix)\($0)" }
            .compactMap { timeOption($0) }
            .first
    }

    /// Check for the presence of a time `option` in arguments
    /// When found retrieves the value as `TimeInterval`
    ///
    /// See: `parseToSeconds(_ time: String)`
    ///
    /// Return:`TimeInterval?` (typealias of `Double?`)
    func timeOption(_ option: String) -> TimeInterval? {
        if let value: String = hasOption(option) {
            switch option {
            case _ where NSString(string: option).contains("date"):
                if let date = iso8601().date(from: value) {
                    return date.timeIntervalSince1970
                } else {
                    collectError(option, value)
                }
            case _ where parseToSeconds(value) != nil:
                if let seconds = parseToSeconds(value) {
                    return Date().timeIntervalSince1970 - seconds
                }
            default:
                collectError(option, value)
            }
        }
        return nil
    }

    /// Collect numbers from a string
    func filterNums(_ string: String) -> Double? {
        return Double(string.filter { $0 == "." || $0 >= "0" && $0 <= "9" })
    }

    /// Provide a lookup table for time unit,
    /// pattern/name & factor (seconds per unit)
    let timeUnitsTable = [
        (pattern: "m|minutes|min|mins|minute", factor: 60.0),
        (pattern: "h|hours|hr|hrs|hour", factor: 60.0 * 60.0),
        (pattern: "d|days|day", factor: 24.0 * 60.0 * 60.0),
        (pattern: "w|week|weeks|wk|wks", factor: 7.0 * 24.0 * 60.0 * 60.0),
        (pattern: "s|sec|secs|second|seconds", factor: 1.0)
    ]

    /// Parse time string to seconds, the form of time strings are
    /// simple grammar of `"amount value"`
    ///
    /// - Example:
    /// ```
    /// parseToSeconds("1sec") == 1.0
    /// parseToSeconds("1s") == 1.0
    /// parseToSeconds("1min") == 60.0
    /// parseToSeconds("1hr") == 3600.0
    /// ```
    /// etc.
    ///
    /// - See: `timeUnitsTable` for possible unit names
    func parseToSeconds(_ time: String) -> Double? {
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

    /// Parse a query option, setting searchMode and removing quotes if needed.
    private func parseQueryOption(_ options: String..., mode: SearchMode, removeQuotes: Bool) {
        for option in options {
            if let rawQuery: String = hasOption(option) {
                searchMode = mode
                query = removeQuotes ? rawQuery.replacingOccurrences(of: "\"", with: "") : rawQuery
                return
            }
        }
    }

    /// Parse all known arguments, collect any unparsed arguments as errors.
    /// It will call exit when parsing help and or version flags.
    func parse() {
        let flagAndInfoPairs: [([String], String)] = [
            (args: ["-h", "--help"], string: usageInfo()),
            (args: ["--version"], string: version)
        ]

        for (args, string) in flagAndInfoPairs where hasFlag(args) {
            out.print(string)
            self.infoFlags = true
            return
        }

        beforeDate = parseTimeOptions("--before")
        sinceDate = parseTimeOptions("--since")
        limit = hasOption("-l", "--limit")
        favorites = hasFlag("-F", "--favorites", "--favorite")
        missingDate = hasFlag("-M", "--missing-date", "--missing-time")
        showTime = hasFlag("-T", "--show-time", "--show-date")

        parseQueryOption("-i", "--regexi", mode: .regexi, removeQuotes: true)
        parseQueryOption("-r", "--regex", mode: .regex, removeQuotes: true)
        parseQueryOption("-e", "--exact", mode: .exact, removeQuotes: false)
        parseQueryOption("-f", "--fuzzy", mode: .fuzzy, removeQuotes: false)

        collectErrors(self.arguments)
    }
}
