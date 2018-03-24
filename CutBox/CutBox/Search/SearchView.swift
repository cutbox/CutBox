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
        let color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let font = NSFont.systemFont(ofSize: 18)
        let attrs = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font]
        let placeHolder = NSAttributedString(string: "Search Copied Items", attributes: attrs)
        self.searchField.placeholderAttributedString = placeHolder
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
