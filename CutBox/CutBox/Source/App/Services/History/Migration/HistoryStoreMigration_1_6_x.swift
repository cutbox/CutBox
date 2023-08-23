//
//  HistoryStoreMigration_1_6_x.swift
//  CutBox
//
//  Created by jason on 21/8/23.
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
    private let historyStoreKey = "historyStore"
    private let timestampKey = "timestamp"
    private let favoriteKey = "favorite"
    private let stringKey = "string"

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    /// Is there a historyStore and does it have legacy items?
    var isMigrationRequired: Bool {
        return hasExistingHistoryStore && hasLegacyItems
    }

    /// Does historyStore contain items without timestamps?
    private var hasLegacyItems: Bool {
        if let historyStore = defaults
            .array(forKey: "historyStore") as? [[String: String]] {
            return historyStore.contains(
                where: { $0["timestamp"] == nil }
            )
        }
        return false
    }

    /// Does historyStore exist in CutBox defaults?
    private var hasExistingHistoryStore: Bool {
        if defaults.array(forKey: "historyStore") is [[String: String]] {
            return true
        }
        return false
    }

    /// Apply sequential ISO8601 timestamps to the legacy items
    ///
    /// - offset: seconds ago (default 30 days) to start setting timestamps
    /// Note: TimeStamps are applied one-second apart
    func applyTimestampsToLegacyItems(offset: TimeInterval = -2592000.0) {
        var idx = 0.0
        let historyStore = defaults
            .array(forKey: "historyStore") as? [[String: String]]
        var migratedHistoryStore: [[String: String]] = []

        historyStore?.forEach { var item = $0
            if !item.keys.contains(timestampKey) {
                let timestamp = ISO8601DateFormatter()
                    .string(from: (Date(timeIntervalSinceNow: offset + idx)))
                idx += 1
                item[timestampKey] = timestamp
            }

            migratedHistoryStore.append(item)
        }

        self.defaults.set(migratedHistoryStore, forKey: historyStoreKey)
    }
}
