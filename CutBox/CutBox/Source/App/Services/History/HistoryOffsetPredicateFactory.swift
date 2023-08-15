//
//  SimpleHistoryPredicateFactory.swift
//  CutBox
//
//  Created by jason on 15/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

func historyOffsetPredicateFactory(offset: TimeInterval) -> (Date) -> Bool {
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
    let cutoffDate = ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: -abs(offset)))

    if offset > 0 {
        return { [cutoffDate] isoTimeStamp in isoTimeStamp > cutoffDate }
    } else {
        return { [cutoffDate] isoTimeStamp in isoTimeStamp < cutoffDate }
    }
}
