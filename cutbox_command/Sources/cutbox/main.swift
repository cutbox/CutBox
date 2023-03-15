import Foundation

let plistPath = "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist"
let historyKey = "historyStore"
let stringKey = "string"

// var limit = Int.max

let usage = """
Usage: cutbox [options] [limit]

Return items from cutbox history, from the latest item up to [limit].

options:

-f <query> fuzzy match items, limit will be applied to results if given.

"""

struct CommandParams {
    let query: String?
    let limit: Int?
}

func parseCommandLineArgs() -> CommandParams {
    let args = CommandLine.arguments

    // check for -f flag and query
    var query: String? = nil
    if let fIndex = args.firstIndex(of: "-f") {
        if args.indices.contains(fIndex+1) && !args[fIndex+1].starts(with: "-") {
            query = args[fIndex+1].replacingOccurrences(of: "\"", with: "")
        }
    }

    // check for limit
    var limit: Int? = nil
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

guard let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String:Any] else {
    print("Error: CutBox history file was not readable.")
    exit(1)
}

guard let historyDict = plist[historyKey] as? [[String:Any]] else {
    print("Error: CutBox history store was not readable.")
    exit(1)
}

var history = historyDict.flatMap({ $0.values.compactMap({ $0 as? String }) })

if let query = commandParams.query {
    history = history.filter { $0.contains(query) }
}

// Print
if let limit = commandParams.limit {
    print(history.prefix(limit).joined(separator: "\n"))
} else {
    print(history.joined(separator: "\n"))
}

