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
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            self.events.onNext(.closeAndPaste)
            return true
        }
        return false
    }
}

enum SearchViewEvents {
    case closeAndPaste
}

class SearchView: NSView {
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var clipboardItemsTable: NSTableView!

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

        searchText.font = NSFont(
            name: "Helvetica Neue",
            size: 28
        )

        searchTextContainer.fillColor = prefs.searchViewTextFieldBackgroundColor

        searchTextPlaceholder.font = NSFont(
            name: "Helvetica Neue",
            size: 28
        )

        searchTextPlaceholder.textColor = prefs.searchViewPlaceholderTextColor

        filterText
            .map { $0.isEmpty ? "Search cut/copy history" : $0 }
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

    override func keyDown(with event: NSEvent) {
        let (key, modifiers) = (event.keyCode, event.modifierFlags)
        debugPrint(key, modifiers)
        super.keyDown(with: event)
    }
}

