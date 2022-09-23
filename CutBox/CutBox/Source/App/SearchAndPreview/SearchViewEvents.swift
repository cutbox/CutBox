//
//  SearchViewEvents.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

enum SearchJSFuncViewEvents {
    case closeAndPaste
    case justClose
    case toggleTheme
}

enum SearchViewEvents {
    case closeAndPasteSelected
    case selectJavascriptFunction
    case justClose
    case setSearchMode(HistorySearchMode)
    case clearHistory
    case revealItemsAndPreview
    case hideSearchResults

    case toggleTheme
    case toggleSearchMode
    case toggleWrappingStrings
    case toggleJoinStrings
    case toggleSearchScope
    case togglePreview

    case removeSelected
    case toggleFavorite
}
