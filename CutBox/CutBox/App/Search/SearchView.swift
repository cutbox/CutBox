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

extension SearchView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        self.filterText.onNext(self.searchText.string)
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.moveUp(_:)):
            self.events.onNext(.itemSelectUp)
            return true
        case #selector(NSResponder.moveDown(_:)):
            self.events.onNext(.itemSelectDown)
            return true
        case #selector(NSResponder.insertNewline(_:)):
            self.events.onNext(.closeAndPaste)
            return true
        default:
            return false
        }
    }
}

enum SearchViewEvents {
    case closeAndPaste
    case itemSelectUp
    case itemSelectDown
}

class SearchView: NSView {
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var clipboardItemsTable: NSTableView!
    @IBOutlet weak var previewClip: NSTextView!

    var events = PublishSubject<SearchViewEvents>()
    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        let prefs = CutBoxPreferences.shared

        searchText.delegate = self
        searchText.textColor = prefs.searchViewTextFieldTextColor
        searchText.insertionPointColor = prefs.searchViewTextFieldCursorColor
        searchText.isFieldEditor = true

        searchText.font = prefs.searchViewTextFieldFont

        searchTextContainer.fillColor = prefs.searchViewTextFieldBackgroundColor
        searchTextPlaceholder.font = prefs.searchViewTextFieldFont
        searchTextPlaceholder.textColor = prefs.searchViewPlaceholderTextColor

        previewClip.backgroundColor = prefs.searchViewClipPreviewBackgroundColor
        previewClip.textColor = prefs.searchViewClipPreviewTextColor
        previewClip.font = prefs.searchViewClipPreviewFont

        filterText
            .map { $0.isEmpty ? "Search cut/copy history" : "" }
            .bind(to: self.searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
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

    func itemSelect(closure: (_ index: Int, _ total: Int) -> Int) {
        let row = self.clipboardItemsTable.selectedRow
        let total = self.clipboardItemsTable.numberOfRows
        let selectedRow = closure(row, total)
        let indexSet: IndexSet = NSIndexSet(index: selectedRow) as IndexSet

        self.clipboardItemsTable.selectRowIndexes(indexSet, byExtendingSelection: false)
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

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36: // Enter key
            self.events
                .onNext(.closeAndPaste)
        default:
            return
        }
    }
}

