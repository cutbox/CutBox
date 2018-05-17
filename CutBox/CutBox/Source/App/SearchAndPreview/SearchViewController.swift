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
    var historyService: HistoryService
    var prefs: CutBoxPreferencesService
    var fakeKey: FakeKey

    var orderedSelection: OrderedSet<Int> = OrderedSet<Int>()

    private let popup: PopupController

    var events: PublishSubject<SearchViewEvents> {
        return self.searchView.events
    }

    var selectedItems: IndexSet {
        return self
            .searchView
            .clipboardItemsTable
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
        self.popup = PopupController(content: self.searchView)

        self.historyService.beginPolling()

        super.init()

        setupSearchTextEventBindings()
        setupSearchViewAndFilterBinding()
        configurePopup()
    }

    func togglePopup() {
        searchView.applyTheme()
        self.popup.togglePopup()
    }

    func closePopup() {
        self.popup.closePopup()
    }

    func openPopup() {
        self.popup.openPopup()
    }

    @objc func hideApp() {
        NSApp.hide(self)
    }

    @objc func fakePaste() {
        fakeKey.send(fakeKey: "V", useCommandFlag: true)
    }

    private func closeAndPaste(useJS: Bool = false) {
        self.pasteSelectedClipToPasteboard(useJS)
        self.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    private func removeSelected() {
        self.historyService.remove(items: self.selectedItems)
        self.searchView.clipboardItemsTable.reloadData()
    }
 
    private func toggleFavorite() {
        let selection = self.selectedItems
        self.historyService.toggleFavorite(items: self.selectedItems)
        self.searchView.clipboardItemsTable.reloadData()
        self.searchView.clipboardItemsTable.selectRowIndexes(selection, byExtendingSelection: false)
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
        self.searchView.clipboardItemsTable.reloadData()
    }

    private func setupSearchViewAndFilterBinding() {
        self.searchView.clipboardItemsTable.dataSource = self
        self.searchView.clipboardItemsTable.delegate = self

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
                self.searchView.clipboardItemsTable.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    func updatePreview() {
        let preview = prefs.prepareClips(selectedClips, false)
        self.searchView.previewClip.string = preview
    }

    private func setupSearchTextEventBindings() {
        self.events
            .subscribe(onNext: { event in
                switch event {
                case .setSearchMode(let mode):
                    self.historyService.searchMode = mode
                    self.searchView.clipboardItemsTable.reloadData()
                    self.searchView.setSearchModeButton(mode: mode)

                case .toggleSearchMode:
                    let mode = self.historyService.toggleSearchMode()
                    self.searchView.clipboardItemsTable.reloadData()
                    self.searchView.setSearchModeButton(mode: mode)

                case .toggleTheme:
                    self.prefs.toggleTheme()
                    self.searchView.applyTheme()
                    self.reloadDataWithExistingSelection()

                case .toggleWrappingStrings:
                    self.prefs.useWrappingStrings = !self.prefs.useWrappingStrings
                    self.updatePreview()

                case .toggleJoinStrings:
                    self.prefs.useJoinString = !self.prefs.useJoinString
                    self.updatePreview()

                case .toggleSearchScope:
                    self.historyService.favoritesOnly = !self.historyService.favoritesOnly
                    self.searchView.clipboardItemsTable.reloadData()
                    self.searchView.setSearchScopeButton(favoritesOnly: self.historyService.favoritesOnly)

                case .toggleFavorite:
                    self.toggleFavorite()

                case .justClose:
                    self.closePopup()

                case .closeAndPasteSelected:
                    self.closeAndPaste()

                case .closeAndPasteSelectedThroughJavascript:
                    self.closeAndPaste(useJS: true)

                case .removeSelected:
                    self.removeSelected()

                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func reloadDataWithExistingSelection() {
        let selected = self.searchView.clipboardItemsTable.selectedRowIndexes
        self.searchView.clipboardItemsTable.reloadData()
        self.searchView.clipboardItemsTable.selectRowIndexes(selected, byExtendingSelection: false)
    }

    private func configurePopup() {
        popup.proportionalTopPadding = 0.15
        popup.proportionalWidth = 0.6
        popup.proportionalHeight = 0.6

        popup.willOpenPopup = self.popup.proportionalResizePopup

        popup.didOpenPopup = {
            guard let window = self.searchView.window
                else { fatalError("No window found for popup") }

            self.resetSearchText()

            // Focus search text
            window.makeFirstResponder(self.searchView.searchText)
        }

        popup.willClosePopup = self.resetSearchText
    }
}
