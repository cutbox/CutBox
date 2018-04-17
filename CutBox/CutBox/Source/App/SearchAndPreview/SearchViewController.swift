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
    var pasteboardService: PasteboardService
    var prefs: CutBoxPreferencesService

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

    private let disposeBag = DisposeBag()

    init(pasteboardService: PasteboardService = PasteboardService.shared,
         cutBoxPreferences: CutBoxPreferencesService = CutBoxPreferencesService.shared) {
        self.prefs = cutBoxPreferences
        self.pasteboardService = pasteboardService
        self.pasteboardService.startTimer()
        self.searchView = SearchAndPreviewView.fromNib()!
        self.popup = PopupController(content: self.searchView)

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
        send(fakeKey: UInt16(9), useCommandFlag: true)
    }

    private func closeAndPaste() {
        self.pasteSelectedClipToPasteboard()
        self.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    private func clearSelected() {
        let indexes = self.searchView.clipboardItemsTable.selectedRowIndexes
        self.pasteboardService.remove(items: indexes)
        self.searchView.clipboardItemsTable.reloadData()
    }

    func pasteSelectedClipToPasteboard() {
        let indexes = self.searchView.clipboardItemsTable.selectedRowIndexes
        let selectedClips = self.pasteboardService[indexes]
        guard !selectedClips.isEmpty else { return }

        pasteToPasteboard(selectedClips)
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
        self.searchView.clipboardItemsTable.reloadData()
    }

    private func setupSearchViewAndFilterBinding() {
        self.searchView.clipboardItemsTable.dataSource = self
        self.searchView.clipboardItemsTable.delegate = self

        self.searchView.filterText
            .bind {
                self.pasteboardService.filterText = $0
                self.searchView.clipboardItemsTable.reloadData()
            }
            .disposed(by: self.disposeBag)
    }

    private func setupSearchTextEventBindings() {
        self.events
            .subscribe(onNext: { event in
                switch event {
                case .setSearchMode(let mode):
                    self.pasteboardService.searchMode = mode
                    self.searchView.clipboardItemsTable.reloadData()
                    self.searchView.searchModeToggle.title = mode.name()
                case .toggleSearchMode:
                    let mode = self.pasteboardService.toggleSearchMode()
                    self.searchView.clipboardItemsTable.reloadData()
                    self.searchView.searchModeToggle.title = mode.name()
                case .justClose:
                    self.closePopup()
                case .closeAndPaste:
                    self.closeAndPaste()
                case .clearSelected:
                    self.clearSelected()
                case .itemSelectUp:
                    self.searchView.itemSelectUp()
                case .itemSelectDown:
                    self.searchView.itemSelectDown()
                }
            })
            .disposed(by: disposeBag)
    }

    private func configurePopup() {
        guard let screen = NSScreen.main else {
            fatalError("Unable to get main screen")
        }

        let width = screen.frame.width / 1.6
        let height = screen.frame.height / 1.8

        popup.resizePopup(width: Double(width),
                          height: Double(height))

        popup.didOpenPopup = {
            guard let window = self.searchView.window else {
                fatalError("No window found for popup")
            }

            self.resetSearchText()

            // Focus in search text
            window.makeFirstResponder(self.searchView.searchText)
        }

        popup.willClosePopup = self.resetSearchText
    }
}
