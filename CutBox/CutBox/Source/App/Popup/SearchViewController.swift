//
//  PopupWrapper.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class SearchViewController: NSObject {

    let pasteboardService: PasteboardService
    let popup: PopupController
    let searchView: SearchAndPreviewView
    var events: PublishSubject<SearchViewEvents> {
        return self.searchView.events
    }
    
    private let disposeBag = DisposeBag()

    override init() {
        self.pasteboardService = PasteboardService()
        self.pasteboardService.startTimer()

        self.searchView = SearchAndPreviewView.fromNib()!
        self.popup = PopupController(content: self.searchView)

        super.init()

        setupSearchTextEventBindings()
        setupSearchViewAndFilterBinding()
        configurePopup()
    }

    func togglePopup() {
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
        FakeKey.send(UInt16(9), useCommandFlag: true)
    }

    private func closeAndPaste() {
        self.pasteSelectedClipToPasteboard()
        self.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    private func clearSelected() {
        let index = self.searchView.clipboardItemsTable.selectedRow
        if self.pasteboardService[index] != nil {
            self.pasteboardService.remove(at: index)
            self.searchView.clipboardItemsTable.reloadData()
        }
    }

    func pasteSelectedClipToPasteboard() {
        let index = self.searchView.clipboardItemsTable.selectedRow
        if let selectedClip = self.pasteboardService[index] {
            pasteToPasteboard(selectedClip)
        }
    }

    func pasteTopClipToPasteboard() {
        guard let topClip = self.pasteboardService[0] else { return }
        pasteToPasteboard(topClip)
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
            .bind { event in
                switch event {
                case .closeAndPaste:
                    self.closeAndPaste()
                case .clearSelected:
                    self.clearSelected()
                case .itemSelectUp:
                    self.searchView.itemSelectUp()
                case .itemSelectDown:
                    self.searchView.itemSelectDown()
                }
            }
            .disposed(by: disposeBag)
    }

    private func configurePopup() {
        guard let screen = NSScreen.main else {
            fatalError("Unable to get main screen")
        }

        let prefs = CutBoxPreferences.shared
        let width = screen.frame.width / 1.6
        let height = screen.frame.height / 1.8

        let popupBackground = popup.backgroundView

        popupBackground.backgroundColor = prefs.searchViewBackgroundColor
        popupBackground.alphaValue = prefs.searchViewBackgroundAlpha

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
