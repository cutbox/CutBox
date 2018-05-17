//
//  SearchAndPreview_KeyDownHandler.swift
//  CutBox
//
//  Created by Jason on 10/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift
import Carbon.HIToolbox

extension SearchJSFuncAndPreviewView {
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

extension SearchAndPreviewView {

    override func keyDown(with event: NSEvent) {
        switch (event.key, event.modifiers) {
        case (kVK_LeftArrow, _),
             (kVK_RightArrow, _):

            self.hideItemsAndPreview(false)

        case (kVK_UpArrow, _),
             (kVK_DownArrow, _):

            self.hideItemsAndPreview(false)
            if HistoryService.shared.count > 0 {
                self.itemsList.keyDown(with: event)
            }

        case (kVK_Escape, _):

            self.events
                .onNext(.justClose)

        case (kVK_Return, [.command]):

            self.events
                .onNext(.selectJavascriptFunction)

        case (kVK_Return, _):

            self.events
                .onNext(.closeAndPasteSelected)

        case (kVK_ANSI_T, [.command]):

            self.events
                .onNext(.toggleTheme)

        case (kVK_ANSI_LeftBracket, [.command]):

            self.events
                .onNext(.toggleWrappingStrings)

        case (kVK_ANSI_Minus, [.command]):

            self.events
                .onNext(.toggleJoinStrings)

        case (kVK_ANSI_F, [.command]):

            self.events
                .onNext(.toggleSearchScope)

        case (kVK_ANSI_S, [.command]):

            self.events
                .onNext(.toggleSearchMode)

        case (kVK_Delete, [.command]):

            self.events
                .onNext(.removeSelected)

        case (kVK_Delete, [.command, .shift]):
            
            self.events
                .onNext(.clearHistory)

        default:
            return
        }
    }
}
