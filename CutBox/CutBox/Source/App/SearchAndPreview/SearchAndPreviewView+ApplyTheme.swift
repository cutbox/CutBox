//
//  SearchAndPreviewView+ApplyTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchAndPreviewView {
    func applyTheme() {
        let theme = prefs.currentTheme

        setSearchModeButton(mode: PasteboardService.shared.searchMode)

        previewClip.font = prefs.searchViewClipPreviewFont
        searchTextPlaceholder.font = prefs.searchViewTextFieldFont
        searchText.font = prefs.searchViewTextFieldFont

        clipboardItemsTable.backgroundColor = theme.clip.clipItemsBackgroundColor

        searchContainer.fillColor = theme.popupBackgroundColor

        searchText.textColor = theme.searchText.textColor
        searchText.insertionPointColor = theme.searchText.cursorColor
        searchTextContainer.fillColor = theme.searchText.backgroundColor
        searchTextPlaceholder.textColor = theme.searchText.placeholderTextColor

        previewClip.backgroundColor = theme.preview.backgroundColor
        previewClipContainer.fillColor = theme.preview.backgroundColor
        previewClip.textColor = theme.preview.textColor
        previewClip.selectedTextAttributes[NSAttributedStringKey.backgroundColor] =
            theme.preview.selectedTextBackgroundColor
        previewClip.selectedTextAttributes[NSAttributedStringKey.foregroundColor] =
            theme.preview.textColor
    }
}
