//
//  SearchViewEvents.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

enum SearchViewEvents {
    case closeAndPasteSelected
    case selectJavascriptFunction
    case closeAndPasteSelectedThroughJavascript
    case justClose
    case setSearchMode(HistorySearchMode)
    case clearHistory
    case revealItemsAndPreview
    case hideItemsAndPreview

    case toggleTheme
    case toggleSearchMode
    case toggleWrappingStrings
    case toggleJoinStrings
    case toggleSearchScope

    case removeSelected
    case toggleFavorite
}
