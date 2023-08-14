//
//  SearchViewEvents.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

enum SearchJSFuncViewEvents {
    case closeAndPaste
    case justClose
    case cycleTheme
}

enum SearchViewEvents {
    case closeAndPasteSelected
    case selectJavascriptFunction
    case justClose
    case setSearchMode(HistorySearchMode)
    case setTimeFilter(seconds: Double?)
    case clearHistory
    case revealItemsAndPreview
    case hideSearchResults

    case cycleTheme
    case toggleSearchMode
    case toggleWrappingStrings
    case toggleJoinStrings
    case toggleSearchScope
    case togglePreview

    case scaleTextUp
    case scaleTextDown
    case scaleTextNormalize

    case removeSelected
    case toggleFavorite
    case openPreferences
}
