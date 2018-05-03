//
//  SearchViewControllerTableViewDelegate.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTextField: NSTextField {

    override func mouseEntered(with event: NSEvent) {
        let modifiers = event
            .modifierFlags
            .intersection(.deviceIndependentFlagsMask)

        if modifiers == [.option] {
            debugPrint("Show star")
        }

        super.mouseEntered(with: event)
    }

    override func updateTrackingAreas() {
        let rect = self.bounds

        if let area = self.trackingAreas
            .first(where: {$0.rect == rect})
        { self.removeTrackingArea(area) }

        addTrackingRect(rect, owner: self, userData: nil, assumeInside: true)
        super.updateTrackingAreas()
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
        guard let _ = self.historyService[row] else { return nil }

        let identifier = NSUserInterfaceItemIdentifier(
            rawValue: "ClipItemTextField")

        var textField: NSTextField? = tableView.makeView(
            withIdentifier: identifier, owner: self) as? NSTextField

        if textField == nil {
            let textWidth = Int(tableView.frame.width)
            let textHeight = 30

            let textFrame = CGRect(x: 0, y: 0,
                                   width: textWidth,
                                   height: textHeight)

            textField = NSTextField()
            textField?.frame = textFrame
            textField?.backgroundColor = NSColor.clear
            textField?.isBordered = false
            textField?.isSelectable = false
            textField?.isEditable = false
            textField?.lineBreakMode = .byTruncatingTail
            textField?.usesSingleLineMode = true
            textField?.cell = SearchViewTextFieldCell()
            textField?.font = CutBoxPreferencesService.shared.searchViewClipItemsFont
            textField?.identifier = identifier
        }

        let theme = CutBoxPreferencesService.shared.currentTheme
        textField?.textColor = theme.clip.clipItemsTextColor

        return textField
    }
}
