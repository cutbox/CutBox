//
//  SearchView.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import Carbon.HIToolbox

extension SearchAndPreviewView {
    override func keyDown(with event: NSEvent) {
        let (keycode, modifiers) =
            (event.keyCode,
             event.modifierFlags.intersection(.deviceIndependentFlagsMask))

        switch (keycode, modifiers) {

        case (UInt16(kVK_Escape),_):
            self.events
                .onNext(.justClose)

        case (UInt16(kVK_Return),_):
            self.events
                .onNext(.closeAndPaste)

        case (UInt16(kVK_ANSI_S), [.command]):
            self.events
                .onNext(.toggleSearchMode)

        case (UInt16(kVK_ANSI_S), [.command]):
            self.events
                .onNext(.toggleSearchMode)

        default:
            return
        }
    }
}

class SearchAndPreviewView: NSView {

    @IBOutlet weak var searchContainer: NSBox!
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var clipboardItemsTable: NSTableView!
    @IBOutlet weak var previewClip: NSTextView!
    @IBOutlet weak var previewClipContainer: NSBox!
    @IBOutlet weak var searchModeIndicator: NSTextField!

    var events = PublishSubject<SearchViewEvents>()
    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()

    private let disposeBag = DisposeBag()
    private let prefs = CutBoxPreferences.shared

    override func awakeFromNib() {
        applyTheme()
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
        let row = clipboardItemsTable.selectedRow
        let total = clipboardItemsTable.numberOfRows

        let selectedRow = lambda(row, total)

        clipboardItemsTable
            .selectRowIndexes([selectedRow],
                              byExtendingSelection: false)
        clipboardItemsTable
            .scrollRowToVisible(selectedRow)
    }

    func itemSelectUp() {
        itemSelect { index, _ in
            index > 0
                ? index - 1
                : index
        }
    }

    func itemSelectDown() {
        itemSelect { index, total in
            index < total
                ? index + 1
                : index
        }
    }



    private func setupPlaceholder() {
        filterText
            .map { $0.isEmpty ? Constants.searchViewPlaceholderText : "" }
            .bind(to: searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
    }

    func applyTheme() {
        searchContainer.fillColor = prefs.searchViewBackgroundColor

        clipboardItemsTable.backgroundColor = prefs.searchViewClipItemsBackgroundColor

        previewClip.font = prefs.searchViewClipPreviewFont
        searchTextPlaceholder.font = prefs.searchViewTextFieldFont
        searchText.font = prefs.searchViewTextFieldFont

        searchText.textColor = prefs.searchViewTextFieldTextColor
        searchText.insertionPointColor = prefs.searchViewTextFieldCursorColor
        searchTextContainer.fillColor = prefs.searchViewTextFieldBackgroundColor
        searchTextPlaceholder.textColor = prefs.searchViewPlaceholderTextColor
        previewClip.backgroundColor = prefs.searchViewClipPreviewBackgroundColor
        previewClip.textColor = prefs.searchViewClipPreviewTextColor
        previewClip.selectedTextAttributes[NSAttributedStringKey
            .backgroundColor] = prefs.searchViewClipPreviewSelectedTextBackgroundColor
        previewClip.selectedTextAttributes[NSAttributedStringKey
            .foregroundColor] = prefs.searchViewClipPreviewTextColor
        previewClipContainer.fillColor = prefs.searchViewClipPreviewBackgroundColor
    }

    private func setupSearchText() {
        searchText.delegate = self
        searchText.isFieldEditor = true
    }
}
