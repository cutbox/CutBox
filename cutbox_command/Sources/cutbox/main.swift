import Foundation

let plistPath = "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist"
let historyKey = "historyStore"
let stringKey = "string"
let maxArgs = 2

var limit = Int.max

if CommandLine.argc > 1 {
    guard let arg = Int(CommandLine.arguments[1]) else {
        print("Usage: cutbox [limit]")
        exit(1)
    }
    limit = arg
}

// Read cutbox history
guard let plistData = FileManager.default.contents(atPath: plistPath) else {
    print("CutBox history not found, is CutBox installed?")
    exit(1)
}
let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as! [String:Any]

// Print
if let history = plist[historyKey] as? [[String:Any]] {
    for (_, item) in history.prefix(limit).enumerated() {
        if let str = item[stringKey] as? String {
            print(str)
        }
    }
}
