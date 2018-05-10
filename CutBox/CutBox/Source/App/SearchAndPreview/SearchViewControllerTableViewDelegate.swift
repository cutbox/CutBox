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

        let theme = CutBoxPreferencesService.shared.currentTheme
        let record = self.historyService.dict[row]

        guard let column = tableColumn else { return nil }

        switch column.identifier.rawValue {
        case "icon":
            let rowView = getIconRowView(tableView)
            rowView.data = record
            rowView.color = theme.clip.clipItemsTextColor

            return rowView
        case "string":
            let rowView = getTextRowView(tableView)
            rowView.data = record
            rowView.color = theme.clip.clipItemsTextColor

            return rowView
        default:
            return nil
        }
    }

    func getIconRowView(_ tableView: NSTableView) -> ClipItemTableRowImageButtonView {
        let iconIdentifier = NSUserInterfaceItemIdentifier(
            rawValue: "ClipItemTableRowImageButtonView")

        var dequeuedClipItemTableRowImageButtonView: ClipItemTableRowImageButtonView? = tableView.makeView(
            withIdentifier: iconIdentifier, owner: self
            ) as? ClipItemTableRowImageButtonView

        if dequeuedClipItemTableRowImageButtonView == nil {
            dequeuedClipItemTableRowImageButtonView = ClipItemTableRowImageButtonView.fromNib()
            dequeuedClipItemTableRowImageButtonView?.identifier = iconIdentifier
        }

        guard let ClipItemTableRowImageButtonView = dequeuedClipItemTableRowImageButtonView
            else { fatalError("Unable to get a ClipItemTableRowImageButtonView") }

        return ClipItemTableRowImageButtonView
    }

    func getTextRowView(_ tableView: NSTableView) -> ClipItemTableRowTextView {
        let textIdentifier = NSUserInterfaceItemIdentifier(
            rawValue: "ClipItemTableRowTextView")

        var dequeuedClipItemTableRowTextView: ClipItemTableRowTextView? = tableView.makeView(
            withIdentifier: textIdentifier, owner: self
            ) as? ClipItemTableRowTextView

        if dequeuedClipItemTableRowTextView == nil {
            dequeuedClipItemTableRowTextView = ClipItemTableRowTextView.fromNib()
            dequeuedClipItemTableRowTextView?.identifier = textIdentifier
        }

        guard let clipItemTableRowTextView = dequeuedClipItemTableRowTextView
            else { fatalError("Unable to get a ClipItemTableRowTextView") }

        return clipItemTableRowTextView
    }
}

