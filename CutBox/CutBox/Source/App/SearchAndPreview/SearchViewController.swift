//
//  SearchViewController.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class SearchViewController: NSObject {

    var searchView: SearchAndPreviewView
    var jsFuncView: SearchAndPreviewView
    var historyService: HistoryService
    var prefs: CutBoxPreferencesService
    var fakeKey: FakeKey

    var orderedSelection: OrderedSet<Int> = OrderedSet<Int>()

    private let searchPopup: PopupController
    private let jsPopup: PopupController

    var events: PublishSubject<SearchViewEvents> {
        return self.searchView.events
    }

    var selectedItems: IndexSet {
        return self
            .searchView
            .itemsList
            .selectedRowIndexes
    }

    var selectedClips: [String] {
        return self
            .orderedSelection
            .all()
            .map { self.historyService.items[$0] }
    }

    let disposeBag = DisposeBag()

    init(pasteboardService: HistoryService = HistoryService.shared,
         cutBoxPreferences: CutBoxPreferencesService = CutBoxPreferencesService.shared,
         fakeKey: FakeKey = FakeKey.shared) {
        self.historyService = pasteboardService
        self.prefs = cutBoxPreferences
        self.fakeKey = fakeKey

        self.searchView = SearchAndPreviewView.fromNib()!
        self.jsFuncView = SearchAndPreviewView.fromNib()!

        self.searchPopup = PopupController(content: self.searchView)
        self.jsPopup = PopupController(content: self.jsFuncView)

        self.historyService.beginPolling()

        super.init()

        setupSearchTextEventBindings()
        setupSearchViewAndFilterBinding()
        setupClipItemsContextMenu()
        configureSearchPopup()
        configureJSPopup()
    }

    func setupClipItemsContextMenu() {
        let contextMenu = NSMenu()

        let remove = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                action: #selector(self.removeSelectedItems),
                                keyEquivalent: "")

        contextMenu.addItem(remove)

        let favorite = NSMenuItem(title: "context_menu_favorite".l7n,
                                  action: #selector(self.toggleFavoriteItems),
                                  keyEquivalent: "")

        contextMenu.addItem(favorite)

        self.searchView.itemsList.menu = contextMenu
    }

    func togglePopup() {
        self.searchView.applyTheme()
        self.searchPopup.togglePopup()
    }

    func closeSearchPopup() {
        self.searchPopup.closePopup()
    }

    func openPopup() {
        self.searchPopup.openPopup()
    }

    @objc func hideApp() {
        NSApp.hide(self)
    }

    @objc func fakePaste() {
        fakeKey.send(fakeKey: "V", useCommandFlag: true)
    }

    private func closeAndPaste(useJS: Bool = false) {
        self.pasteSelectedClipToPasteboard(useJS)
        self.closeSearchPopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    @objc func removeSelectedItems() {
        self.historyService.remove(items: self.selectedItems)
        self.searchView.itemsList.reloadData()
    }
 
    @objc func toggleFavoriteItems() {
        let selection = self.selectedItems
        self.historyService.toggleFavorite(items: self.selectedItems)
        self.searchView.itemsList.reloadData()
        self.searchView.itemsList.selectRowIndexes(selection, byExtendingSelection: false)
    }

    func pasteSelectedClipToPasteboard(_ useJS: Bool) {
        guard !self.selectedClips.isEmpty else { return }

        pasteToPasteboard(self.selectedClips, useJS)
    }

    private func pasteToPasteboard(_ clips: [String], _ useJs: Bool) {
        let clip = prefs.prepareClips(clips, useJs)

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(clip, forType: .string)
    }

    private func pasteToPasteboard(_ clip: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(clip, forType: .string)
    }

    private func resetSearchText() {
        self.searchView.searchText.string = ""
        self.searchView.filterText.onNext("")
        self.searchView.itemsList.reloadData()
    }

    private func setupSearchViewAndFilterBinding() {
        self.searchView.itemsList.dataSource = self
        self.searchView.itemsList.delegate = self

        self.searchView.filterText
            .map { $0.isEmpty }
            .subscribe(onNext: {
                if self.prefs.useCompactUI {
                    self.searchView.hideItemsAndPreview($0)
                } else {
                    self.searchView.hideItemsAndPreview(false)
                }
            })
            .disposed(by: disposeBag)

        self.searchView.filterText
            .subscribe(onNext: {
                self.historyService.filterText = $0
                self.searchView.itemsList.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    func updatePreview() {
        let preview = prefs.prepareClips(selectedClips, false)
        self.searchView.preview.string = preview
    }

    private func setupSearchTextEventBindings() {
        self.events
            .subscribe(onNext: { event in
                switch event {
                case .setSearchMode(let mode):
                    self.historyService.searchMode = mode
                    self.searchView.itemsList.reloadData()
                    self.searchView.setSearchModeButton(mode: mode)

                case .toggleSearchMode:
                    let mode = self.historyService.toggleSearchMode()
                    self.searchView.itemsList.reloadData()
                    self.searchView.setSearchModeButton(mode: mode)

                case .toggleTheme:
                    self.prefs.toggleTheme()
                    self.searchView.applyTheme()
                    self.jsFuncView.applyTheme()
                    self.reloadDataWithExistingSelection()

                case .toggleWrappingStrings:
                    self.prefs.useWrappingStrings = !self.prefs.useWrappingStrings
                    self.updatePreview()

                case .toggleJoinStrings:
                    self.prefs.useJoinString = !self.prefs.useJoinString
                    self.updatePreview()

                case .toggleSearchScope:
                    self.historyService.favoritesOnly = !self.historyService.favoritesOnly
                    self.searchView.itemsList.reloadData()
                    self.searchView.setSearchScopeButton(favoritesOnly: self.historyService.favoritesOnly)

                case .toggleFavorite:
                    self.toggleFavoriteItems()

                case .justClose:
                    self.closeSearchPopup()

                case .closeAndPasteSelected:
                    self.closeAndPaste()

                case .selectJavascriptFunction:
                    self.jsFuncView.applyTheme()
                    self.jsPopup.togglePopup()

                case .closeAndPasteSelectedThroughJavascript:
                    self.closeAndPaste(useJS: true)

                case .removeSelected:
                    self.removeSelectedItems()

                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func reloadDataWithExistingSelection() {
        let selected = self.searchView.itemsList.selectedRowIndexes
        self.searchView.itemsList.reloadData()
        self.searchView.itemsList.selectRowIndexes(selected, byExtendingSelection: false)
    }

    private func configureJSPopup() {
        jsPopup.proportionalTopPadding = 0.15
        jsPopup.proportionalWidth = 0.6
        jsPopup.proportionalHeight = 0.6

        jsPopup.willOpenPopup = self.jsPopup.proportionalResizePopup
    }

    private func configureSearchPopup() {
        searchPopup.proportionalTopPadding = 0.15
        searchPopup.proportionalWidth = 0.6
        searchPopup.proportionalHeight = 0.6

        searchPopup.willOpenPopup = self.searchPopup.proportionalResizePopup

        searchPopup.didOpenPopup = {
            guard let window = self.searchView.window
                else { fatalError("No window found for popup") }

            self.resetSearchText()

            // Focus search text
            window.makeFirstResponder(self.searchView.searchText)
        }

        searchPopup.willClosePopup = self.resetSearchText
    }
}
