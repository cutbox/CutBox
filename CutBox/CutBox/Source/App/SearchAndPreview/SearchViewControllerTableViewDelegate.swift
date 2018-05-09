//
//  SearchViewControllerTableViewDelegate.swift
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
}

extension SearchViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updatePreview()
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = SearchViewTableRowView()
        rowView.searchView = self.searchView
        return rowView
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {

        let identifier = NSUserInterfaceItemIdentifier(
            rawValue: "ClipItemTableRowView")

        var dequeuedClipItemTableRowView: ClipItemTableRowView? = tableView.makeView(
            withIdentifier: identifier, owner: self
            ) as? ClipItemTableRowView

        if dequeuedClipItemTableRowView == nil {
            dequeuedClipItemTableRowView = ClipItemTableRowView.fromNib()
            dequeuedClipItemTableRowView?.identifier = identifier
        }

        guard let clipItemTableRowView = dequeuedClipItemTableRowView
            else { fatalError("Unable to get a ClipItemTableRowView") }

        let theme = CutBoxPreferencesService.shared.currentTheme
        let record = self.historyService.dict[row]
        clipItemTableRowView.data = record
        clipItemTableRowView.color = theme.clip.clipItemsTextColor

        return clipItemTableRowView
    }
}
