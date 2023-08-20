//
//  TimeFilterValidator.swift
//  CutBox
//
//  Created by jason on 13/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

class TimeFilterValidator {
    private static let MINUTE: Int = 60
    private static let HOUR: Int = 3600
    private static let DAY: Int = 86400
    private static let WEEK: Int = 604800
    private static let YEAR: Int = 31536000

    public typealias TimeUnitLabels = [(name: String, plural: String)]

    private static let secondsToTimeFull: TimeUnitLabels = [
        (name: "year", plural: "years"),
        (name: "week", plural: "weeks"),
        (name: "day", plural: "days"),
        (name: "hour", plural: "hours"),
        (name: "minute", plural: "minutes"),
        (name: "second", plural: "seconds")
    ]

    private static let secondsToTimeAbbreviated: TimeUnitLabels = [
        (name: "yr", plural: "yrs"),
        (name: "wk", plural: "wks"),
        (name: "d", plural: "d"),
        (name: "hr", plural: "hrs"),
        (name: "min", plural: "mins"),
        (name: "s", plural: "s")
    ]

    public static func secondsToTime(seconds: Int, labels: TimeUnitLabels = secondsToTimeFull) -> String {
        let secondsToComponents = [
            seconds / YEAR,
            (seconds % YEAR) / WEEK,
            (seconds % WEEK) / DAY,
            (seconds % DAY) / HOUR,
            (seconds % HOUR) / MINUTE,
            seconds % MINUTE
        ]

        let components: [String] = zip(secondsToComponents, labels).map { value, label in
            switch value {
            case 1:
                return "\(Int(value)) \(label.name)"
            case 0:
                return ""
            default:
                return "\(Int(value)) \(label.plural)"
            }
        }

        if components.isEmpty {
            return "0 seconds"
        }

        var captured = ""
        for component in components where component != "" {
            if let index = components.firstIndex(of: component) {
                if components.count > index + 1 {
                    let adjacent = components[index + 1]
                    if adjacent != "" {
                        captured = "\(component) \(adjacent)"
                    } else {
                        captured = component
                    }
                } else {
                    captured = component
                }
                break
            }
        }

        return captured
    }

    private static let timeUnitsTable = [
        (pattern: #"^(\d+(?:\.\d+)?) ?(m|minutes|min|mins|minute)$"#, factor: 60.0),
        (pattern: #"^(\d+(?:\.\d+)?) ?(h|hours|hr|hrs|hour)$"#, factor: 3600.0),
        (pattern: #"^(\d+(?:\.\d+)?) ?(d|days|day)$"#, factor: 86400.0),
        (pattern: #"^(\d+(?:\.\d+)?) ?(w|week|weeks|wk|wks)$"#, factor: 604800.0),
        (pattern: #"^(\d+(?:\.\d+)?) ?(y|year|years|yr|yrs)$"#, factor: 31536000.0),
        (pattern: #"^(\d+(?:\.\d+)?) ?(s|sec|secs|second|seconds)$"#, factor: 1.0)
    ]

    private static func filterNums(_ string: String) -> Double? {
        return Double(string.filter { $0 == "." || $0 >= "0" && $0 <= "9" })
    }

    /// Parse string to optional time interval. Any non-numeric chars will be
    /// filtered out after matching on seconds (or s,sec,secs), minutes (or
    /// m,min,mins), hours (or h,hr,hrs), days (or d,day). (case insensitive)
    private static func parseToSeconds(_ time: String) -> Double? {
        if let num = filterNums(time) {
            return timeUnitsTable.compactMap { (unit: (pattern: String, factor: Double)) -> Double? in
                if regexpMatch(time, unit.pattern, caseSensitive: false) {
                    return num * unit.factor
                }
                return nil
            }.first
        }
        return nil
    }

    /// Perform a regular expression (pattern) match on string, defaults to case sensitive.
    /// On match return true
    private static func regexpMatch(_ string: String, _ pattern: String, caseSensitive: Bool = true) -> Bool {
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

    private let value: String
    public let seconds: Double?

    public var isValid: Bool {
        return self.seconds != nil
    }

    init(value: String) {
        self.value = value
        switch value {
        case _ where "today" == value.localizedLowercase:
            self.seconds = Double(Self.DAY)
        case _ where "this week" == value.localizedLowercase:
            self.seconds = Double(Self.WEEK)
        case _ where "yesterday" == value.localizedLowercase:
            self.seconds = 2 * Double(Self.DAY)
        default:
            self.seconds = Self.parseToSeconds(value)
        }
    }
}
