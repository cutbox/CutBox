//
//  CutBoxControllerTableViewDataSource.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension CutBoxController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let count = self.pasteboardService.count
        return count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let value = self.pasteboardService[row] else { return nil }

        // FIXME: Cheap hack to add left pad to the row.
        return " " + value
    }
}
