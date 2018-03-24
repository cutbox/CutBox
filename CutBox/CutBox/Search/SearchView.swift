//
//  SearchView.swift
//  CutBox
//
//  Created by Jason on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class SearchViewTableCell: NSTableCellView {

}

class SearchView: NSView, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var clipboardItemsTable: NSTableView!

    override func awakeFromNib() {
//        self.searchField.
    }

    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        let (key, modifiers) = (event.keyCode, event.modifierFlags)
        debugPrint(key, modifiers)
        super.keyDown(with: event)
    }

}
