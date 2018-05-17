//
//  SearchJSFuncAndPreviewView+ApplyTheme.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchJSFuncAndPreviewView {
    func colorizeMagnifier(image: NSImage = #imageLiteral(resourceName: "magnitude.png"),
                           tooltip: String = "search_scope_tooltip_all".l7n) {
        let image = image
        let blended = image.tint(color: prefs.currentTheme.searchText.placeholderTextColor)

        self.searchScopeImageButton.image = blended
        self.searchScopeImageButton.alphaValue = 0.75
        self.searchScopeImageButton.toolTip = toolTip
    }

    func applyTheme() {
        let theme = prefs.currentTheme

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

        colorizeMagnifier()
    }
}
