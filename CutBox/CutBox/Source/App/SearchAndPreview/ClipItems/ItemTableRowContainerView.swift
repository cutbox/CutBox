//
//  ItemTableRowContainerView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowContainerView: NSTableRowView {

    var textView: ItemTableRowTextView?
    var imageView: ItemTableRowImageView?

    override var selectionHighlightStyle: NSTableView.SelectionHighlightStyle {
        get {
            return .regular
        }
        set {
            _ = newValue // unused new value
        }
    }

    override func drawSelection(in dirtyRect: NSRect) {
        let theme = CutBoxPreferencesService.shared.currentTheme
        if self.selectionHighlightStyle != .none {
            let selectionRect = self.bounds

            theme
                .clip
                .highlightColor
                .setFill()

            if let textView = self.textView {
                textView.color = theme.clip.highlightTextColor
            }

            if let imageView = self.imageView {
                imageView.color = theme.clip.highlightTextColor
            }

            let selectionPath = NSBezierPath.init(rect: selectionRect)
            selectionPath.fill()
        }
    }
}
