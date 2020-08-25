//
//  ClipItemTableRowContainerView.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowContainerView: ItemTableRowContainerView {

    var searchView: SearchAndPreviewView?

    override func mouseDown(with event: NSEvent) {
        let modifiers = event
            .modifierFlags
            .intersection(.deviceIndependentFlagsMask)

        if event.clickCount == 2
            && modifiers == [] {
            self.searchView?
                .events
                .onNext(.closeAndPasteSelected)
        }

        if event.clickCount == 2
            && modifiers == [.control] {
            self.searchView?
                .events
                .onNext(.selectJavascriptFunction)
        }

        if event.clickCount == 1
            && modifiers == [.option] {
            self.searchView?
                .events
                .onNext(.toggleFavorite)
        }

        super.mouseDown(with: event)
    }

}
