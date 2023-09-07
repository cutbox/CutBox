//
//  HistoryStoreMigration_1_6_x.swift
//  CutBox
//
//  Created by Jason Milkins on 21/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

/// Migrate Cutbox historyStore to 1.6.0 (internal use)
///
/// The migration applies timestamps from 30 days ago
/// when an item is missing one.  Timestamps are sequential to
/// avoid any possible collision issue. NO ROLLBACK.
///
/// Note: The offset of 30 days ago is default, and can be overridden.
///
/// The instance method `applyTimestampsToLegacyItems(offset: TimeInterval)`
/// perfoms the migration. Use `migrationRequired: Bool` to avoid running
/// an unnecessary migration.
class HistoryStoreMigration_1_6_x {
    private var defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    /// Is there a historyStore and does it have legacy items?
    var isMigrationRequired: Bool {
        return hasLegacyItems
    }

    /// Does historyStore contain items without timestamps?
    private var hasLegacyItems: Bool {
        if let historyStore = defaults
            .array(forKey: Constants.kHistoryStoreKey) as? [[String: String]] {
            let test = historyStore
                .contains { $0["timestamp"] == nil }
            return test
        } else {
            return false
        }
    }

    /// Apply sequential ISO8601 timestamps to the legacy items
    /// - offset: seconds ago (default 30 days) to start setting timestamps
    /// Note: TimeStamps are applied approximately one-second apart
    func applyTimestampsToLegacyItems(offset: TimeInterval = -2592000.0) {
        var idx = 0.0
        let historyStore = defaults
            .array(forKey: Constants.kHistoryStoreKey) as? [[String: String]]
        var migratedHistoryStore: [[String: String]] = []

        historyStore?.forEach { var item = $0
            if !item.keys.contains(Constants.kTimestampKey) {
                let timestamp = iso8601Timestamp(fromDate: Date(timeIntervalSinceNow: offset + idx))
                idx += 1
                item[Constants.kTimestampKey] = timestamp
            }
            migratedHistoryStore.append(item)
        }

        self.defaults.set(migratedHistoryStore, forKey: Constants.kHistoryStoreKey)
    }
}
