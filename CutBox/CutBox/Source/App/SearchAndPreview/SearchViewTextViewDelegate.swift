//
//  SearchViewTextViewDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

extension SearchAndPreviewView: NSTextViewDelegate, NSTextFieldDelegate {

    func textDidChange(_ notification: Notification) {
        if notification.object as? SearchTextView == self.searchText {
            self.filterTextPublisher.onNext(self.searchText.string)
        }
    }

    private var useTextCommands: [Selector] {
        return [
            "deleteBackwards:",
            "deleteForwards:",
            "deleteWord:",
            "deleteWordBackwards:",
            "deleteToBeginningOfLine",
            "deleteToEndOfLine",
            "cut",
            "copy",
            "paste",
            "undo",
            "redo",
            "selectAll"
        ].map { Selector($0) }
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        return useTextCommands.contains(commandSelector)
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        return useTextCommands.contains(commandSelector)
    }

}
