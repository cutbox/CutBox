import Foundation

let plistPath = "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist"
let historyKey = "historyStore"
let stringKey = "string"
let usage = """
OVERVIEW:
        Inspect the cutbox history from the command line

USAGE:  cutbox [options] [limit]

        Return items from cutbox history, from the latest item up to [limit].

OPTIONS:
        -f <query> fuzzy match items, limit will be applied to results if given.

        help, -h or --help show this message.
"""

struct CommandParams {
    let query: String?
    let limit: Int?
}

func parseCommandLineArgs() -> CommandParams {
    let args = CommandLine.arguments

    // Show usage for -h or --help or help arg
    if args.contains("-h") ||
         args.contains("--help") ||
         args.contains("help") {
        print(usage)
        exit(0)
    }

    // check for -f flag and query
    var query: String?
    if let fIndex = args.firstIndex(of: "-f") {
        if args.indices.contains(fIndex+1) && !args[fIndex+1].starts(with: "-") {
            query = args[fIndex+1].replacingOccurrences(of: "\"", with: "")
        }
    }

    // check for limit
    var limit: Int?
    if let lastArg = args.last, !lastArg.starts(with: "-") {
        limit = Int(lastArg)
    }

    // return CommandParams
    return CommandParams(query: query, limit: limit)
}

let commandParams = parseCommandLineArgs()

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
var historyStrings = historyDict.compactMap {
    if let item = $0[stringKey] as? String {
        return item
    } else {
        return nil
    }
}

if let query = commandParams.query {
    historyStrings = historyStrings.filter { $0.contains(query) }
}

if let limit = commandParams.limit {
    print(historyStrings.prefix(limit).joined(separator: "\n"))
} else {
    print(historyStrings.joined(separator: "\n"))
}
