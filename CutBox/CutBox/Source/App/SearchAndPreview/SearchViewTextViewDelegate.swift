//
//  SearchViewTextViewDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

extension SearchAndPreviewView: NSTextViewDelegate, NSTextFieldDelegate {

    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField, textField == timeFilterText {
            print("Time filter string: \(timeFilterText.stringValue)")

            timeUntilFilterTextPublisher.onNext(timeFilterText.stringValue)
        }
    }

    func textDidChange(_ notification: Notification) {
        if let _ = notification.object as? SearchTextView {
            self.filterTextPublisher.onNext(self.searchText.string)
        }
    }

    private var useTextCommands: [Selector] {
        return [
            "deleteBackwards:",
            "deleteForwards:",
            "deleteWord:",
            "deleteWordBackwards:"
        ].map { Selector($0) }
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        return useTextCommands.contains(commandSelector)
    }
}
