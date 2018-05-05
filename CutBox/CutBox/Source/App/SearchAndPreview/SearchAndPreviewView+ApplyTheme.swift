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

        self.magnifierImageView.alphaValue = 0.75

        let blended = image.tint(color: prefs.currentTheme.searchText.placeholderTextColor)

        self.magnifierImageView.image = blended
        self.magnifierImageView.toolTip = toolTip
    }

    func applyTheme() {
        let theme = prefs.currentTheme

        setSearchModeButton(mode: HistoryService.shared.searchMode)

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

        self.colorizeMagnifier()
    }
}

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        guard self.isTemplate == false else { return self }

        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
