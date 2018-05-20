//
//  ItemTableRowContainerView.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowContainerView: NSTableRowView {

    override var selectionHighlightStyle: NSTableView.SelectionHighlightStyle {
        set {}
        get {
            return .regular
        }
    }

    override func drawSelection(in dirtyRect: NSRect) {
        let theme = CutBoxPreferencesService.shared.currentTheme
        if self.selectionHighlightStyle != .none {
            let selectionRect = self.bounds

            theme
                .clip
                .clipItemsHighlightColor
                .setFill()

            let selectionPath = NSBezierPath.init(rect: selectionRect)
            selectionPath.fill()
        }
    }
}