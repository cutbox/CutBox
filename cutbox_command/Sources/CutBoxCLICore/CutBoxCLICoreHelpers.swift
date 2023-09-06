//
//  CutBoxCLICoreHelpers.swift
//
//  Created by jason on 1/9/23.
//

import Foundation

public func regexpMatch(_ string: String, _ pattern: String, caseSensitive: Bool = true) -> Bool {
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

public func savePlist(path: String, plist: [String: Any]) {
    guard let data = try? PropertyListSerialization.data(
        fromPropertyList: plist,
        format: .xml,
        options: 0
    ) else {
        fatalError("Cannot convert plist to data")
    }

    do {
        try data.write(to: URL(fileURLWithPath: path))
    } catch {
        fatalError("Failed to write data to file: \(error)")
    }
}
