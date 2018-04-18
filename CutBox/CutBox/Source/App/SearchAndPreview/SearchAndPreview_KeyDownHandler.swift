//
//  SearchAndPreview_KeyDownHandler.swift
//  CutBox
//
//  Created by Jason on 10/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift
import Carbon.HIToolbox

extension SearchAndPreviewView {
    override func keyDown(with event: NSEvent) {
        let (keycode, modifiers) =
            (event.keyCode,
             event.modifierFlags.intersection(.deviceIndependentFlagsMask))

        switch (keycode, modifiers) {

        case (UInt16(kVK_Escape), _):
            self.events
                .onNext(.justClose)

        case (UInt16(kVK_Return), _):
            self.events
                .onNext(.closeAndPaste)

        case (UInt16(kVK_ANSI_S), [.command]):
            self.events
                .onNext(.toggleSearchMode)

        case (UInt16(kVK_Delete), [.command]):
            self.events
                .onNext(.clearHistory)

        default:
            return
        }
    }
}
