//
//  JSFuncSearchAndPreviewView+KeyDown.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import RxSwift
import Carbon.HIToolbox

extension JSFuncSearchAndPreviewView {

    override func keyDown(with event: NSEvent) {
        switch (event.key, event.modifiers) {
        case (kVK_UpArrow, _),
             (kVK_DownArrow, _):
            self.hideSearchResults(false)
            if !self.js.isEmpty {
                self.itemsList.keyDown(with: event)
            }

        case (kVK_ANSI_T, [.command]):
            self.events.onNext(.cycleTheme)

        case (kVK_Return, _):
            self.events.onNext(.closeAndPaste)

        case (kVK_Escape, _):
            self.events.onNext(.justClose)

        default:
            break
        }
    }
}
