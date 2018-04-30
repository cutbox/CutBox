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
        guard let value = self.historyService[row] else { return nil }
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
