//
//  SearchPreviewViewBase.swift
//  CutBox
//
//  Created by Jason Milkins on 20/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import CoreImage

class SearchPreviewViewBase: NSView {

    @IBOutlet weak var searchContainer: NSBox!
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: SearchTextView!
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
        get {
            return searchTextContainerHeight.constant
        }
        set {
            searchTextContainerHeight.constant = newValue
        }
    }

    var spacing: CGFloat {
        get {
            return mainContainer.spacing
        }
        set {
            mainContainer.spacing = newValue
            container.spacing = newValue
            mainTopConstraint.constant = newValue
            mainLeadingConstraint.constant = newValue
            mainTrailingConstraint.constant = newValue
            mainBottomConstraint.constant = newValue
        }
    }

    var filterTextPublisher = PublishSubject<String>()

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

    func setTextScale() {
        preview.font = prefs.searchViewClipPreviewFont
    }

    func hideSearchResults(_ bool: Bool) {
        self.bottomBar.isHidden = bool
        self.container.isHidden = bool
    }

    func hidePreview(_ bool: Bool) {
        self.previewContainer.isHidden = bool
    }

    func setupPlaceholder() {
        filterTextPublisher
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
                           tooltip: String = "search_scope_tooltip_all".l7n,
                           alpha: Double = 0.75) {

        let image = image
        let blended = image.tint(color: prefs.currentTheme.searchText.placeholderTextColor)

        self.searchScopeImageButton.alphaValue = alpha
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

        itemsList.backgroundColor = theme.clip.backgroundColor

        searchContainer.fillColor = theme.popupBackgroundColor

        searchText.textColor = theme.searchText.textColor
        searchText.insertionPointColor = theme.searchText.cursorColor
        searchTextContainer.fillColor = theme.searchText.backgroundColor
        searchTextPlaceholder.textColor = theme.searchText.placeholderTextColor

        preview.backgroundColor = theme.preview.backgroundColor
        previewContainer.fillColor = theme.preview.backgroundColor
        preview.textColor = theme.preview.textColor

        preview.selectedTextAttributes[.backgroundColor] = theme.preview.selectedTextBackgroundColor
        preview.selectedTextAttributes[.foregroundColor] = theme.preview.selectedTextColor
    }
}
