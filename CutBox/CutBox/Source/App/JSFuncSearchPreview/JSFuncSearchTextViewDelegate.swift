//
//  SearchJSFuncTextViewDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

extension JSFuncSearchAndPreviewView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        self.filterTextPublisher.onNext(self.searchText.string)
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        return useTextCommands.contains(commandSelector)
    }
}
