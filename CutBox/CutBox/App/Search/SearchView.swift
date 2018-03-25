//
//  SearchView.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

extension SearchView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        self.filterText.onNext(self.searchText.string)
    }
}

class SearchView: NSView {
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var clipboardItemsTable: NSTableView!

    var filterText = PublishSubject<String>()

    override func awakeFromNib() {
        searchText.delegate = self
        searchText.textColor = NSColor.white
        searchText.isFieldEditor = true
        searchText.font = NSFont(
            name: "Helvetica Neue",
            size: 28
        )
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

