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

class SearchAndPreviewView: NSView {
    @IBOutlet weak var searchContainer: NSBox!
    @IBOutlet weak var searchTextContainer: NSBox!
    @IBOutlet weak var searchTextPlaceholder: NSTextField!
    @IBOutlet weak var searchText: NSTextView!
    @IBOutlet weak var clipboardItemsTable: NSTableView!
    @IBOutlet weak var previewClip: NSTextView!
    @IBOutlet weak var previewClipContainer: NSBox!
    @IBOutlet weak var searchModeIndicator: NSTextField!

    internal let prefs = CutBoxPreferencesService.shared
    
    var events = PublishSubject<SearchViewEvents>()
    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        applyTheme()
        setupSearchText()
        setupPlaceholder()
        setupContextMenu()
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

    @objc func clearSelected() {
        self.events.onNext(.clearSelected)
    }

    private func setupContextMenu() {
        let contextMenu = NSMenu()
        let remove = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                       action: #selector(self.clearSelected),
                                       keyEquivalent: "")

        contextMenu.addItem(remove)
        clipboardItemsTable.menu = contextMenu
    }

    private func setupPlaceholder() {
        filterText
            .map { $0.isEmpty ? "search_placeholder".l7n : "" }
            .bind(to: searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupSearchText() {
        searchText.delegate = self
        searchText.isFieldEditor = true
    }
}
