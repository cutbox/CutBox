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
    @IBOutlet weak var searchModeToggle: NSButton!

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
        setupSearchModeToggle()
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

    @objc func removeSelected() {
        self.events.onNext(.removeSelected)
    }

    func setSearchModeButton(mode: PasteboardSearchMode) {
        let color = [NSAttributedStringKey.foregroundColor: prefs.currentTheme.clip.clipItemsTextColor]
        let titleString = NSAttributedString(string: mode.name(), attributes: color)

        self.searchModeToggle.attributedTitle = titleString
        self.searchModeToggle.toolTip = mode.toolTip()
    }

    private func setupSearchModeToggle() {
        let mode = PasteboardService.shared.searchMode
        setSearchModeButton(mode: mode)

        self.searchModeToggle
            .rx
            .tap
            .map { .toggleSearchMode }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    private func setupContextMenu() {
        let contextMenu = NSMenu()
        let remove = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                action: #selector(self.removeSelected),
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
