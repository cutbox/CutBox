import Foundation

struct HistoryManager {
    let plist: [String: Any]
    let stringKey = "string"
    let timestampKey = "timestamp"
    let favoriteKey = "favorite"

    init(plist: [String: Any]) {
        self.plist = plist
    }

    func loadHistoryEntries() -> [HistoryEntry] {
        guard let historyDict = plist["historyStore"] as? [[String: Any?]] else {
            return []
        }

        return historyDict.compactMap { itemAsHistoryEntry($0 as [String: Any]) }
    }

    func itemAsHistoryEntry(_ item: [String: Any]) -> HistoryEntry? {
        guard let string: String = item[stringKey] as? String else {
            return nil
        }

        return HistoryEntry(string: string,
                            timestamp: item[timestampKey] as? String,
                            favorite: item[favoriteKey] as? String)
    }

    func filterEntries(_ entries: [HistoryEntry], params: CommandParams) -> [HistoryEntry] {
        var filteredEntries = entries

        if params.favorites {
            filteredEntries = filteredEntries.filter { entry in
                return entry.favorite == "favorite"
            }
        }

        if params.missingDate {
            filteredEntries = filteredEntries.filter { entry in
                return entry.timestamp == nil
            }
        }

        if let sinceDate = params.sinceDate {
            filteredEntries = filteredEntries.filter { entry in
                if entry.timestamp != nil {
                    return Double(entry.timeIntervalSince1970!) >= sinceDate
                }
                return false
            }
        }

        if let beforeDate = params.beforeDate {
            filteredEntries = filteredEntries.filter { entry in
                if entry.timestamp != nil {
                    return Double(entry.timeIntervalSince1970!) <= beforeDate
                }
                return false
            }
        }

        if let limit = params.limit {
            filteredEntries = Array(filteredEntries.prefix(limit))
        }

        return filteredEntries
    }

    func searchEntries(_ entries: [HistoryEntry], params: CommandParams) -> [HistoryEntry] {
        guard let query = params.query, let searchMode = params.searchMode else {
            return entries
        }

        return entries.filter { entry in
            switch searchMode {
            case .fuzzy:
                return entry.string.localizedCaseInsensitiveContains(query)
            case .regex:
                return regexpMatch(entry.string, query)
            case .regexi:
                return regexpMatch(entry.string, query, caseSensitive: false)
            case .string:
                return entry.string.contains(query)
            }
        }
    }
}
