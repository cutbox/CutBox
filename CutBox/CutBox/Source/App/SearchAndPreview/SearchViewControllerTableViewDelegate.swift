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
        return self.historyService.count
    }
}

extension SearchViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateSearchItemPreview()
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = ClipItemTableRowContainerView()
        rowView.searchView = self.searchView
        return rowView
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let record = self.historyService.dict[safe: row] else { return nil }
        guard let column = tableColumn else { return nil }

        let theme = CutBoxPreferencesService.shared.currentTheme
        let rowView: ClipItemTableRowContainerView? = tableView.rowView(atRow: row, makeIfNecessary: false) as? ClipItemTableRowContainerView

        switch column.identifier.rawValue {
        case "icon":
            let rowImageView = tableView.getRowView() as ClipItemTableRowImageView
            rowImageView.data = record
            rowImageView.color = theme.clip.clipItemsTextColor
            rowView?.imageView = rowImageView

            return rowImageView

        case "string":
            let rowTextView = tableView.getRowView() as ClipItemTableRowTextView
            rowTextView.data = record
            rowTextView.color = theme.clip.clipItemsTextColor
            rowView?.textView = rowTextView

            return rowTextView

        default:
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        let proposed = proposedSelectionIndexes

        guard proposed.count > 0 else { return proposedSelectionIndexes }

        let selected =  self.searchView.itemsList.selectedRowIndexes
        let removed: IndexSet = selected.subtracting(proposed)
        let theme = CutBoxPreferencesService.shared.currentTheme
        let added: IndexSet = proposed.subtracting(selected)

        removed
            .map {
                tableView.rowView(atRow: $0,
                                  makeIfNecessary: true) as! ItemTableRowContainerView }
            .forEach {
                $0.imageView?.color = theme.clip.clipItemsTextColor
                $0.textView?.color = theme.clip.clipItemsTextColor
        }

        added.forEach { self.orderedSelection.add($0) }
        removed.forEach { self.orderedSelection.remove($0) }

        var cruft: [Int] = []

        self.orderedSelection.all().forEach {
            if !proposed.contains($0) {
                cruft.append($0)
            }
        }

        cruft.forEach { self.orderedSelection.remove($0) }

        return proposedSelectionIndexes
    }
}
