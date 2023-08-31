import Foundation

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

    private var out: Output

    init(out: Output, arguments: [String]) {
        self.out = out
        self.arguments = arguments
        parse()
    }

    func hasFlag(_ flag: String) -> Bool {
        if self.arguments.contains(flag) {
            removeArgAndValueFromArguments(flag)
            return true
        }
        return false
    }

    func hasFlag(_ flags: String...) -> Bool {
        return hasFlag(flags)
    }

    func hasFlag(_ flags: [String]) -> Bool {
        return flags.contains(where: hasFlag)
    }

    func removeArgAndValueFromArguments(_ arg: String) {
        if let argIndex = self.arguments.firstIndex(of: arg) {
            self.arguments.remove(at: argIndex)
        }
    }

    func removeArgAndValueFromCommandLine<T>(_ arg: String, _ value: T?) {
        if let argIndex = self.arguments.firstIndex(of: arg) {
            self.arguments.remove(at: argIndex)
            if let value = value, let valueIndex = self.arguments
                .firstIndex(of: String(describing: value)) {
                self.arguments.remove(at: valueIndex)
            }
        }
    }

    func printErrors() {
        errors.forEach(printError)
    }

    func printError(error: (String, String)) {
        out.error("Invalid argument: \(error.0) \(error.1)")
    }

    func hasOpt<T>(_ opts: String...) -> T? {
        let args = self.arguments
        guard let index = args.firstIndex(where: { opts.contains($0) }),
              let valueIndex = args.index(index, offsetBy: 1, limitedBy: args.endIndex),
              !args[valueIndex].starts(with: "-") else {
            return nil
        }

        let value = args[valueIndex]

        switch T.self {
        case is String.Type:
            removeArgAndValueFromCommandLine(args[index], value)
            return value as? T
        case is Int.Type:
            removeArgAndValueFromCommandLine(args[index], value)
            return Int(value) as? T
        case is Double.Type:
            removeArgAndValueFromCommandLine(args[index], value)
            return Double(value) as? T
        default:
            fatalError("hasOpt will only return String?, Double? or Int? ")
        }
    }

    func collectError(_ opt: String, _ value: Any, description: String = "") {
        errors.append((opt, String(describing: value)))
    }

    func collectErrors(_ arguments: [String]) {
        var currentOpt: String?
        var currentValue: String = ""

        for arg in arguments {
            if arg.hasPrefix("-") {
                if let opt = currentOpt {
                    collectError(opt, currentValue)
                }
                currentOpt = arg
                currentValue = ""
            } else {
                currentValue += currentValue.isEmpty ? arg : " \(arg)"
            }
        }

        if let opt = currentOpt {
            collectError(opt, currentValue)
        }
    }

    func parseTimeOptions(_ prefix: String) -> TimeInterval? {
        let timeOptionSuffixes = ["", "-date"]
        return timeOptionSuffixes
            .map { "\(prefix)\($0)" }
            .compactMap { timeOpt($0) }
            .first
    }

    func timeOpt(_ option: String) -> TimeInterval? {
        if let value: String = hasOpt(option) {
            let opt = option as NSString
            switch opt {
            case _ where opt.contains("date"):
                if let date = iso8601().date(from: value) {
                    return date.timeIntervalSince1970
                } else {
                    collectError(String(opt), value)
                }
            case _ where parseToSeconds(value) != nil:
                if let seconds = parseToSeconds(value) {
                    return Date().timeIntervalSince1970 - seconds
                }
            default:
                collectError(String(opt), value)
            }
        }
        return nil
    }

    func filterNums(_ string: String) -> Double? {
        return Double(string.filter { $0 == "." || $0 >= "0" && $0 <= "9" })
    }

    let timeUnitsTable = [
        (pattern: "m|minutes|min|mins|minute", factor: 60.0),
        (pattern: "h|hours|hr|hrs|hour", factor: 60.0 * 60.0),
        (pattern: "d|days|day", factor: 24.0 * 60.0 * 60.0),
        (pattern: "w|week|weeks|wk|wks", factor: 7.0 * 24.0 * 60.0 * 60.0),
        (pattern: "s|sec|secs|second|seconds", factor: 1.0)
    ]

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

    func parse() {
        let flagAndInfoPairs: [([String], String)] = [
            (args: ["-h", "--help"], string: usageInfo()),
            (args: ["--version"], string: version)
        ]

        for (args, string) in flagAndInfoPairs where hasFlag(args) {
            out.print(string)
        }

        favorites = hasFlag("-F", "--favorites", "--favorite")
        missingDate = hasFlag("-M", "--missing-date", "--missing-time")

        beforeDate = parseTimeOptions("--before")
        sinceDate = parseTimeOptions("--since")

        limit = hasOpt("-l", "--limit")

        showTime = hasFlag("-T", "--show-time", "--show-date")

        if let rawQuery: String = hasOpt("-r", "--regex") {
            searchMode = .regex
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        if let rawQuery: String = hasOpt("-i", "--regexi") {
            searchMode = .regexi
            query = rawQuery.replacingOccurrences(of: "\"", with: "")
        }

        if let rawQuery: String = hasOpt("-e", "--exact") {
            searchMode = .string
            query = rawQuery
        }

        if let rawQuery: String = hasOpt("-f", "--fuzzy") {
            searchMode = .fuzzy
            query = rawQuery
        }

        collectErrors(self.arguments)
    }
}
