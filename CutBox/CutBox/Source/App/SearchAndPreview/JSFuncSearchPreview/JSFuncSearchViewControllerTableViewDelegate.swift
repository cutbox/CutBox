//
//  JSFuncSearchViewControllerTableViewDelegate.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
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
        let row: Int = self.jsFuncView.itemsList.selectedRow
        let preview = self.jsFuncService.process(row, items: self.selectedClips)
        self.jsFuncView.preview.string = preview
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

        let funcItem = self.jsFuncService.list[row]
        guard let column = tableColumn else { return nil }

        let theme = CutBoxPreferencesService.shared.currentTheme

        switch column.identifier.rawValue {
        case "icon":
            let rowView = tableView.getRowView() as JSFuncItemTableRowImageView
            rowView.setup()
            rowView.color = theme.clip.clipItemsTextColor
            return rowView

        case "string":
            let rowView = tableView.getRowView() as JSFuncItemTableRowTextView
            rowView.data = ["string": funcItem["name"] as! String]
            rowView.color = theme.clip.clipItemsTextColor
            return rowView

        default:
            return nil
        }
    }
}
