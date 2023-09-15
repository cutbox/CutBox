//
//  SearchViewEvents.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

enum SearchJSFuncViewEvents: Equatable {
    case closeAndPaste
    case justClose
    case cycleTheme
}

enum SearchViewEvents: Equatable {
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
    case toggleTimeFilter

    case scaleTextUp
    case scaleTextDown
    case scaleTextNormalize

    case removeSelected
    case toggleFavorite
    case openPreferences
}
