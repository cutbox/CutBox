//
//  JSFuncSearchAndPreviewView+KeyDown.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift
import Carbon.HIToolbox

extension JSFuncSearchAndPreviewView {
    override func keyDown(with event: NSEvent) {
        switch (event.key, event.modifiers) {
        case (kVK_UpArrow, _),
             (kVK_DownArrow, _):

            self.hideItemsAndPreview(false)
            if JSFuncService.shared.count > 0 {
                self.itemsList.keyDown(with: event)
            }

        case (kVK_ANSI_T, [.command]):

            self.events
                .onNext(.toggleTheme)

        case (kVK_Return, _):

            self.events.onNext(.closeAndPaste)

        default:
            break;
        }
    }
}
