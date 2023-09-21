//
//  ClipItemTableRowContainerView.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowContainerView: ItemTableRowContainerView {

    var searchView: SearchAndPreviewView?

    override func mouseDown(with event: NSEvent) {
        let modifiers = event
            .modifierFlags
            .intersection(.deviceIndependentFlagsMask)

        if event.clickCount == 2
            && event.type == .leftMouseDown
            && modifiers.isEmpty {
            self.searchView?
                .events
                .onNext(.closeAndPasteSelected)
        }

        if (event.clickCount == 2 && modifiers == [.control]) ||
            (event.clickCount == 2 && modifiers == [.command]) {
            self.searchView?
                .events
                .onNext(.selectJavascriptFunction)
        }

        if event.clickCount == 1
            && event.type == .leftMouseDown
            && modifiers == [.option] {
            self.searchView?
                .events
                .onNext(.toggleFavorite)
        }

        super.mouseDown(with: event)
    }
}
