//
//  SimpleHistoryPredicateFactory.swift
//  CutBox
//
//  Created by Jason Milkins on 15/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

func historyOffsetPredicateFactory(offset: TimeInterval) -> (Date) -> Bool {
    guard offset != 0 else { fatalError("Error:Time offset 0 is invalid") }
    let cutoffDate = Date(timeIntervalSinceNow: -abs(offset))

    if offset > 0 {
        return { [cutoffDate] date in
            return date > cutoffDate
        }
    } else {
        return { [cutoffDate] date in
            return date < cutoffDate
        }
    }
}

func historyOffsetPredicateFactory(offset: TimeInterval) -> (String) -> Bool {
    guard offset != 0 else { fatalError("Error:Time offset 0 is invalid") }
    let cutoffDate = ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: -abs(offset)))

    if offset > 0 {
        return { [cutoffDate] itemTimestamp in itemTimestamp > cutoffDate }
    } else {
        return { [cutoffDate] itemTimestamp in itemTimestamp < cutoffDate }
    }
}
