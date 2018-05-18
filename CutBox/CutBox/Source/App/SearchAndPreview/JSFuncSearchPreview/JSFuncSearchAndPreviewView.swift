//
//  JSFuncSearchAndPreviewView.swift
//  CutBox
//
//  Created by Jason on 16/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

class JSFuncSearchAndPreviewView: NSView {
    @IBOutlet weak var searchContainer: NSBox!
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var itemsList: NSTableView!
    @IBOutlet weak var preview: NSTextView!
    @IBOutlet weak var previewContainer: NSBox!
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var searchScopeImageButton: NSButton!

    @IBOutlet weak var container: NSStackView!
    @IBOutlet weak var bottomBar: NSView!

    internal let prefs = CutBoxPreferencesService.shared

    var events = PublishSubject<SearchJSFuncViewEvents>()
    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()

    var placeHolderTextString = "search_placeholder".l7n

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        setupSearchText()
        setupPlaceholder()
    }

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
            .selectRowIndexes([selectedRow],
                              byExtendingSelection: false)
        itemsList
            .scrollRowToVisible(selectedRow)
    }

    func hideItemsAndPreview(_ bool: Bool) {
        self.bottomBar.isHidden = bool
        self.container.isHidden = bool
    }

    private func setupPlaceholder() {
        filterText
            .map { $0.isEmpty ? self.placeHolderTextString  : "" }
            .bind(to: searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupSearchText() {
        self.searchText.delegate = self
        self.searchText.isFieldEditor = true
    }

}

