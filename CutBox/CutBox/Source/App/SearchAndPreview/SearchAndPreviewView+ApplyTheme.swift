//
//  SearchAndPreviewView+ApplyTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchAndPreviewView {

    func colorizeMagnifier(image: NSImage = #imageLiteral(resourceName: "magnitude.png"),
                           tooltip: String = "search_scope_tooltip_all".l7n) {
        let image = image

        self.searchScopeImageButton.alphaValue = 0.75

        let blended = image.tint(color: prefs.currentTheme.searchText.placeholderTextColor)

        self.searchScopeImageButton.image = blended
        self.searchScopeImageButton.toolTip = toolTip
    }

    func applyTheme() {
        let theme = prefs.currentTheme

        setSearchModeButton(mode: HistoryService.shared.searchMode)

        preview.font = prefs.searchViewClipPreviewFont
        searchTextPlaceholder.font = prefs.searchViewTextFieldFont
        searchText.font = prefs.searchViewTextFieldFont

        itemsList.backgroundColor = theme.clip.clipItemsBackgroundColor

        searchContainer.fillColor = theme.popupBackgroundColor

        searchText.textColor = theme.searchText.textColor
        searchText.insertionPointColor = theme.searchText.cursorColor
        searchTextContainer.fillColor = theme.searchText.backgroundColor
        searchTextPlaceholder.textColor = theme.searchText.placeholderTextColor

        preview.backgroundColor = theme.preview.backgroundColor
        previewContainer.fillColor = theme.preview.backgroundColor
        preview.textColor = theme.preview.textColor

        preview.selectedTextAttributes[.backgroundColor] =
            theme.preview.selectedTextBackgroundColor
        preview.selectedTextAttributes[.foregroundColor] =
            theme.preview.textColor

        self.setSearchScopeButton(favoritesOnly: HistoryService.shared.favoritesOnly)
    }
}
