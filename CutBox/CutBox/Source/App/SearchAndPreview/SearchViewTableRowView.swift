//
//  SearchViewTableRowView.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//



import Cocoa

class SearchViewTableRowView: NSTableRowView {

    var searchView: SearchAndPreviewView?

    override func mouseDown(with event: NSEvent) {
        let modifiers = event
            .modifierFlags
            .intersection(.deviceIndependentFlagsMask)

        if event.clickCount == 2
            && modifiers == [] {
            self.searchView?
                .events
                .onNext(.closeAndPasteSelected)
        }

        if event.clickCount == 1
            && modifiers == [.option] {
            self.searchView?
                .events
                .onNext(.toggleFavorite)
        }

        super.mouseDown(with: event)
    }

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
