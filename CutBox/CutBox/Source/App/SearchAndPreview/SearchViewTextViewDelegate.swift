//
//  SearchViewTextViewDelegate.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchAndPreviewView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        self.filterText.onNext(self.searchText.string)
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.moveUp(_:)):
            self.events.onNext(.itemSelectUp)
            return true
        case #selector(NSResponder.moveDown(_:)):
            self.events.onNext(.itemSelectDown)
            return true
        case #selector(NSResponder.insertNewline(_:)):
            self.events.onNext(.closeAndPaste)
            return true
        default:
            return false
        }
    }
}
