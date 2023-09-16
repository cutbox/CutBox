//
//  JSFuncSearchViewControllerTableViewDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

extension JSFuncSearchViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.jsFuncService.count
    }
}

extension JSFuncSearchViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }

    func updateSearchItemPreview() {
        let row = self.jsFuncView.itemsList.selectedRow
        let name = self.jsFuncService.funcList[row]
        let preview = self.jsFuncService.process(name, items: self.selectedClips)
        self.jsFuncView.preview?.string = preview
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateSearchItemPreview()
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = JSFuncItemTableRowContainerView()
        rowView.jsFuncView = self.jsFuncView
        return rowView
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else {
            return nil
        }

        let funcItem = self.jsFuncService.funcList[row]
        let theme = CutBoxPreferencesService.shared.currentTheme
        let rowView: JSFuncItemTableRowContainerView? = tableView.rowView(
            atRow: row,
            makeIfNecessary: false
            ) as? JSFuncItemTableRowContainerView

        switch column.identifier.rawValue {
        case "icon":
            let rowImageView = tableView.getRowView() as JSFuncItemTableRowImageView
            rowImageView.setup()
            rowImageView.color = theme.clip.textColor
            rowView?.imageView = rowImageView
            return rowImageView

        case "string":
            let rowTextView = tableView.getRowView() as JSFuncItemTableRowTextView
            rowTextView.data = ["string": funcItem]
            rowTextView.color = theme.clip.textColor
            rowView?.textView = rowTextView
            return rowTextView

        default:
            return nil
        }
    }

    func tableView(_ tableView: NSTableView,
                   selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet
        ) -> IndexSet {

        let proposed = proposedSelectionIndexes

        guard !proposed.isEmpty else {
            return proposedSelectionIndexes
        }

        let selected = tableView.selectedRowIndexes
        let removed: IndexSet = selected.subtracting(proposed)
        let theme = CutBoxPreferencesService.shared.currentTheme

        removed
            .map {
                tableView.rowView(
                    atRow: $0,
                    makeIfNecessary: true
                    ) as? ItemTableRowContainerView
            }
            .forEach {
                $0?.imageView?.color = theme.clip.textColor
                $0?.textView?.color = theme.clip.textColor
        }

        return proposedSelectionIndexes
    }
}
