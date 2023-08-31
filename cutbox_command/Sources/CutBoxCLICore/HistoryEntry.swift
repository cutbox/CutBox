import Foundation

struct HistoryEntry: Equatable {
    let string: String
    let timestamp: String?
    let favorite: String?

    var timeIntervalSince1970: Double? {
        guard let isotime = timestamp else {
            return nil
        }

        let dateFormatter: DateFormatter = iso8601()

        return dateFormatter
            .date(from: isotime)?.timeIntervalSince1970
    }
}
