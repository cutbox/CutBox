//
//  SearchJSFuncTextViewDelegate.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension JSFuncSearchAndPreviewView: NSTextViewDelegate {

    func textDidChange(_ notification: Notification) {
        self.filterText.onNext(self.searchText.string)
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
