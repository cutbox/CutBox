//
//  ISO8601Helpers.swift
//  CutBox
//
//  Created by Jason Milkins on 19/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

/// Quick conversion of Date to ISO8601 timestamp
func iso8601(date: Date) -> String {
    return ISO8601DateFormatter().string(from: date)
}

/// Quick generation of ISO8601 timestamp of seconds (as Double) before time
func secondsBeforeTimeNowAsISO8601(seconds: Double) -> String {
    let date = Date(timeIntervalSinceNow: -seconds)
    return iso8601(date: date)
}
