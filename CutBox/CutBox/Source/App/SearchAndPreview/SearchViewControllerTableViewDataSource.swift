//
//  SearchViewControllerTableViewDataSource.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let count = self.historyService.count
        return count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let record = self.historyService.dict[row]
        let value = record["string"]!
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let favorite = record["favorite"],
            !favorite.isEmpty
            else { return trimmed }

        return NSAttributedString(string: trimmed, attributes: [.backgroundColor: prefs.currentTheme.clip.clipItemsHighlightColor])
//        return "\(trimmed)"
    }
}
