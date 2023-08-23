//
//  SearchViewController.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

/// Controller for `SearchAndPreviewView`
///
/// Subscribes any `SearchViewEvents` (from `SearchAndPreviewView`),
/// performing the required actions,  using init injected: `searchView:SearchAndPreviewView`,
/// `historyService:HistoryService` and `prefs:CutBoxPreferencesService`.
class SearchViewController: NSObject {

    var searchView: SearchAndPreviewView
    var historyService: HistoryService
    var prefs: CutBoxPreferencesService
    var fakeKey: FakeKey

    var orderedSelection: OrderedSet<Int> = OrderedSet<Int>()

    private var searchPopup: PopupController

    /// Event stream from SearchAndPreviewView
    var events: PublishSubject<SearchViewEvents> {
        return self.searchView.events
    }

    /// Row indexes of selected items
    var selectedItems: IndexSet {
        return self
            .searchView
            .itemsList
            .selectedRowIndexes
    }

    /// Strings of selected items
    var selectedClips: [String] {
        guard !self.historyService.items.isEmpty else { return [] }

        return self
            .orderedSelection
            .all()
            .map { self.historyService.items[$0] }
    }

    /// Rx Swift sink hole
    let disposeBag = DisposeBag()

    /// Setup controller, initialize the search view and popup.
    /// Connect the history service and tell it to start polling the pasteboard.
    /// Connect the preferences service to itself and members.
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

    /// Setup the context menu for items shown in the search view
    func setupClipItemsContextMenu() {
        self.searchView.setupClipItemsContextMenu()
        self.searchView.itemsList.menu?.delegate = self
    }

    /// Toggle display of the search popup
    func togglePopup() {
        self.historyService.favoritesOnly = false
        self.searchView.applyTheme()
        self.searchPopup.togglePopup()
    }

    /// Close the search popup
    func closeSearchPopup() {
        HistoryService.shared.favoritesOnly = false
        self.searchPopup.closePopup()
    }

    /// Open the search popup
    func openSearchPopup() {
        self.historyService.favoritesOnly = false
        self.searchPopup.openPopup()
    }

    /// Hide the app (objc selector)
    @objc func hideApp() {
        NSApp.hide(self)
    }

    /// send a fake paste (Cmd V) to macOS
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

    /// Remove selected items and refresh the search view
    func removeSelectedItems() {
        self.historyService.remove(selected: self.selectedItems)
        self.searchView.itemsList.reloadData()
    }

    /// Toggle favorite status on selected items
    func toggleFavoriteItems() {
        let selection = self.selectedItems
        self.historyService.toggleFavorite(items: self.selectedItems)
        self.searchView.itemsList.reloadData()
        self.searchView.itemsList.selectRowIndexes(selection, byExtendingSelection: false)
    }

    /// Send the selected clip text to the pasteboard
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
        self.searchView.filterTextPublisher.onNext("")
        self.searchView.itemsList.reloadData()
    }

    private func setupSearchViewAndFilterBinding() {
        self.searchView.itemsList.dataSource = self
        self.searchView.itemsList.delegate = self

        self.searchView.filterTextPublisher
            .map { $0.isEmpty }
            .subscribe(onNext: {
                if self.prefs.useCompactUI {
                    self.searchView.hideSearchResults($0)
                } else {
                    self.searchView.hideSearchResults(false)
                }
            })
            .disposed(by: disposeBag)

        self.searchView.filterTextPublisher
            .subscribe(onNext: {
                self.historyService.filterText = $0
                self.searchView.itemsList.reloadData()
                self.searchView.itemsList.scrollRowToVisible(0)
            })
            .disposed(by: self.disposeBag)

        self.prefs.events
            .compactMap {
                switch $0 {
                case .hidePreviewSettingChanged(let isOn):
                    return isOn
                default:
                    return nil
                }
            }
            .subscribe(onNext: {
                self.searchView.hidePreview($0)
            })
            .disposed(by: self.disposeBag)
    }

    /// Update the preview with selected clip(s)
    func updateSearchItemPreview() {
        let preview = prefs.prepareClips(selectedClips)
        self.searchView.preview.string = preview.truncate(limit: 50_000)
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
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

                case .setTimeFilter(let seconds):
                    self.historyService.setTimeFilter(seconds: seconds)
                    self.searchView.itemsList.reloadData()

                case .toggleTimeFilter:
                    self.searchView.toggleTimeFilter()
                    self.historyService.setTimeFilter(seconds: nil)
                    self.searchView.itemsList.reloadData()

                case .cycleTheme:
                    self.prefs.cycleTheme()
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

                case .togglePreview:
                    self.prefs.hidePreview = !self.prefs.hidePreview

                case .scaleTextDown:
                    self.prefs.scaleTextDown()
                    self.reloadDataWithExistingSelection()

                case .scaleTextUp:
                    self.prefs.scaleTextUp()
                    self.reloadDataWithExistingSelection()

                case .scaleTextNormalize:
                    self.prefs.scaleTextNormalize()
                    self.reloadDataWithExistingSelection()

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
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length


    private func reloadDataWithExistingSelection() {
        let selected = self.searchView.itemsList.selectedRowIndexes
        self.searchView.updateLayer()
        self.searchView.itemsList.reloadData()
        self.searchView.setTextScale()
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
