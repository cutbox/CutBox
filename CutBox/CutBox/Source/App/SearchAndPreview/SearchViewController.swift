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

    private var searchPopup: PopupController

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
        guard self.historyService.items.count > 0 else { return [] }

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
        self.searchPopup = PopupController(content: self.searchView)

        self.historyService.beginPolling()

        super.init()

        configureSearchPopupAndView()
    }

    func setupClipItemsContextMenu() {
        self.searchView.setupClipItemsContextMenu()
    }

    func togglePopup() {
        self.searchView.applyTheme()
        self.searchPopup.togglePopup()
    }

    func closeSearchPopup() {
        self.searchPopup.closePopup()
    }

    func openSearchPopup() {
        self.searchPopup.openPopup()
    }

    @objc func hideApp() {
        NSApp.hide(self)
    }

    @objc func fakePaste() {
        fakeKey.send(fakeKey: "V", useCommandFlag: true)
    }

    private func justClose() {
        self.closeSearchPopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
    }

    private func closeAndPaste(useJS: Bool = false) {
        self.pasteSelectedClipToPasteboard(useJS)
        self.closeSearchPopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    func removeSelectedItems() {
        self.historyService.remove(items: self.selectedItems)
        self.searchView.itemsList.reloadData()
    }

    func toggleFavoriteItems() {
        let selection = self.selectedItems
        self.historyService.toggleFavorite(items: self.selectedItems)
        self.searchView.itemsList.reloadData()
        self.searchView.itemsList.selectRowIndexes(selection, byExtendingSelection: false)
    }

    func pasteSelectedClipToPasteboard(_ useJS: Bool) {
        guard !self.selectedClips.isEmpty else { return }

        pasteToPasteboard(self.selectedClips)
    }

    private func pasteToPasteboard(_ clips: [String]) {
        let clip = prefs.prepareClips(clips)

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

    func updateSearchItemPreview() {
        let preview = prefs.prepareClips(selectedClips)
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
                    self.reloadDataWithExistingSelection()

                case .toggleWrappingStrings:
                    self.prefs.useWrappingStrings = !self.prefs.useWrappingStrings
                    self.updateSearchItemPreview()

                case .toggleJoinStrings:
                    self.prefs.useJoinString = !self.prefs.useJoinString
                    self.updateSearchItemPreview()

                case .toggleSearchScope:
                    self.historyService.favoritesOnly = !self.historyService.favoritesOnly
                    self.searchView.itemsList.reloadData()
                    self.searchView.setSearchScopeButton(favoritesOnly: self.historyService.favoritesOnly)

                case .toggleFavorite:
                    self.toggleFavoriteItems()

                case .justClose:
                    self.justClose()

                case .closeAndPasteSelected:
                    self.closeAndPaste()

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

    private func configureSearchPopupAndView() {
        setupSearchTextEventBindings()
        setupSearchViewAndFilterBinding()
        setupClipItemsContextMenu()

        self.searchView.placeHolderTextString = "search_placeholder".l7n

        self.searchPopup.proportionalTopPadding = 0.15
        self.searchPopup.proportionalWidth = 0.6
        self.searchPopup.proportionalHeight = 0.6

        self.searchPopup.willOpenPopup = self.searchPopup.proportionalResizePopup

        self.searchPopup.didOpenPopup = {
            guard let window = self.searchView.window
                else { fatalError("No window found for popup") }

            self.resetSearchText()

            // Focus search text
            window.makeFirstResponder(self.searchView.searchText)
        }

        self.searchPopup.willClosePopup = self.resetSearchText
    }
}
