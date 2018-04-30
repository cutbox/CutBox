//
//  SearchViewControllerTableViewDelegate.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

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
        guard let _ = self.historyService[row] else { return nil }

        let identifier = NSUserInterfaceItemIdentifier(
            rawValue: "pasteBoardItemsTableTextField")

        var textField: NSTextField? = tableView.makeView(
            withIdentifier: identifier, owner: self) as? NSTextField

        if textField == nil {
            let textWidth = Int(tableView.frame.width)
            let textHeight = 30

            let textFrame = CGRect(x: 0, y: 0,
                                   width: textWidth,
                                   height: textHeight)

            textField = NSTextField(frame: textFrame)
            textField?.cell = SearchViewTextFieldCell()

            textField?.backgroundColor = NSColor.clear
            textField?.isBordered = false
            textField?.isSelectable = false
            textField?.isEditable = false
            textField?.font = CutBoxPreferencesService.shared.searchViewClipItemsFont
            textField?.identifier = identifier
        }

        let theme = CutBoxPreferencesService.shared.currentTheme
        textField?.textColor = theme.clip.clipItemsTextColor

        return textField
    }
}
