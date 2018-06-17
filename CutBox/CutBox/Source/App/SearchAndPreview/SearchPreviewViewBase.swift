//
//  SearchPreviewViewBase.swift
//  CutBox
//
//  Created by Jason on 20/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa

class SearchPreviewViewBase: NSView {

    @IBOutlet weak var searchContainer: NSBox!
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var itemsList: NSTableView!
    @IBOutlet weak var preview: NSTextView!
    @IBOutlet weak var previewContainer: NSBox!
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var searchScopeImageButton: NSButton!
    @IBOutlet weak var mainContainer: NSStackView!
    @IBOutlet weak var container: NSStackView!
    @IBOutlet weak var bottomBar: NSView!

    @IBOutlet weak var searchTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var mainTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBottomConstraint: NSLayoutConstraint!

    var searchTextHeight: CGFloat {
        set {
            searchTextContainerHeight.constant = newValue
        }
        get {
            return searchTextContainerHeight.constant
        }
    }

    var spacing: CGFloat {
        set {
            mainContainer.spacing = newValue
            container.spacing = newValue
            mainTopConstraint.constant = newValue
            mainLeadingConstraint.constant = newValue
            mainTrailingConstraint.constant = newValue
            mainBottomConstraint.constant = newValue
        }
        get {
            return mainContainer.spacing
        }
    }

    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()
    var placeHolderTextString = ""

    let disposeBag = DisposeBag()
    let prefs = CutBoxPreferencesService.shared

    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    func itemSelect(lambda: (_ index: Int, _ total: Int) -> Int) {
        let row = itemsList.selectedRow
        let total = itemsList.numberOfRows

        let selectedRow = lambda(row, total)

        itemsList
            .selectRowIndexes([selectedRow], byExtendingSelection: false)
        itemsList
            .scrollRowToVisible(selectedRow)
    }

    func hideItemsAndPreview(_ bool: Bool) {
        self.bottomBar.isHidden = bool
        self.container.isHidden = bool
    }

    func setupPlaceholder() {
        filterText
            .map { $0.isEmpty ? self.placeHolderTextString : "" }
            .bind(to: searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
    }

    override func awakeFromNib() {
        self.preview.textContainer!.widthTracksTextView = false

        self.preview.textContainer!.containerSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )

        setupPlaceholder()
    }

    func colorizeMagnifier(image: NSImage = #imageLiteral(resourceName: "magnitude.png"),
                           tooltip: String = "search_scope_tooltip_all".l7n) {
        let image = image
        let blended = image.tint(color: prefs.currentTheme.searchText.placeholderTextColor)

        self.searchScopeImageButton.alphaValue = 0.75
        self.searchScopeImageButton.image = blended
        self.searchScopeImageButton.toolTip = toolTip
    }

    func applyTheme() {
        let theme = prefs.currentTheme

        self.spacing = theme.spacing
        self.searchTextHeight = 60 - (spacing * 2.0)

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

        preview.selectedTextAttributes[.backgroundColor] = theme.preview.selectedTextBackgroundColor
        preview.selectedTextAttributes[.foregroundColor] = theme.preview.textColor
    }

}
