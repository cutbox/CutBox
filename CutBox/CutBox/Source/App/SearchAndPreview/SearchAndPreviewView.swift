//
//  SearchView.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
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
    @IBOutlet weak var cutBoxLogoImageView: NSImageView!
    @IBOutlet weak var searchScopeImageButton: NSButton!

    @IBOutlet weak var historyContainer: NSStackView!
    @IBOutlet weak var bottomBar: NSView!
    internal let prefs = CutBoxPreferencesService.shared

    var events = PublishSubject<SearchViewEvents>()
    var filterText = PublishSubject<String>()
    var placeholderText = PublishSubject<String>()

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        setupSearchText()
        setupPlaceholder()
        setupContextMenu()
        setupSearchModeToggle()
        setupSearchScopeToggle()
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

    @objc func toggleFavorite() {
        self.events.onNext(.toggleFavorite)
    }

    func setSearchModeButton(mode: HistorySearchMode) {
        let color = [NSAttributedStringKey.foregroundColor: prefs.currentTheme.clip.clipItemsTextColor]
        let titleString = NSAttributedString(string: mode.name(), attributes: color)

        self.searchModeToggle.attributedTitle = titleString
        self.searchModeToggle.toolTip = mode.toolTip()
    }

    private func setupSearchModeToggle() {
        let mode = HistoryService.shared.searchMode
        setSearchModeButton(mode: mode)

        self.searchModeToggle
            .rx
            .tap
            .map { .toggleSearchMode }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    func setSearchScopeButton(favoritesOnly: Bool) {
        if favoritesOnly {
            colorizeMagnifier(
                image:  #imageLiteral(resourceName: "star.png"),
                tooltip: "search_scope_tooltip_favorites".l7n
            )
        } else {
            colorizeMagnifier()
        }
    }

    private func setupSearchScopeToggle() {
        let favoritesOnly = HistoryService.shared.favoritesOnly
        setSearchScopeButton(favoritesOnly: favoritesOnly)

        self.searchScopeImageButton
            .rx
            .tap
            .map { .toggleSearchScope }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    private func setupContextMenu() {
        let contextMenu = NSMenu()

        let remove = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                action: #selector(self.removeSelected),
                                keyEquivalent: "")
        
        contextMenu.addItem(remove)

        let favorite = NSMenuItem(title: "context_menu_favorite".l7n,
                                  action: #selector(self.toggleFavorite),
                                  keyEquivalent: "")

        contextMenu.addItem(favorite)

        clipboardItemsTable.menu = contextMenu
    }

    func hideItemsAndPreview(_ bool: Bool) {
        self.bottomBar.isHidden = bool
        self.historyContainer.isHidden = bool
    }

    private func setupPlaceholder() {
        filterText
            .map { $0.isEmpty ? "search_placeholder".l7n : "" }
            .bind(to: searchTextPlaceholder.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupSearchText() {
        self.searchText.delegate = self
        self.searchText.isFieldEditor = true
    }
}
