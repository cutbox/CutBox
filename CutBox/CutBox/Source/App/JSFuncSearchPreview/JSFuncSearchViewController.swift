//
//  JSFuncSearchViewController.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift

class JSFuncSearchViewController: NSObject {

    var jsFuncService: JSFuncService
    var selectedClips: [String] = []
    var jsFuncView: JSFuncSearchAndPreviewView
    var prefs: CutBoxPreferencesService
    var fakeKey: FakeKey
    var jsFuncPopup: PopupController
    var events: PublishSubject<SearchJSFuncViewEvents> {
        return self.jsFuncView.events
    }

    let disposeBag = DisposeBag()

    init(jsFuncService: JSFuncService = JSFuncService.shared,
         cutBoxPreferences: CutBoxPreferencesService = CutBoxPreferencesService.shared,
         fakeKey: FakeKey = FakeKey.shared) {

        self.jsFuncService = jsFuncService
        self.prefs = cutBoxPreferences
        self.fakeKey = fakeKey
        self.jsFuncView = JSFuncSearchAndPreviewView.fromNib()!
        self.jsFuncPopup = PopupController(content: self.jsFuncView)

        super.init()


        self.configureJSPopupAndView()
        self.setupSearchTextEventBindings()
        self.setupSearchViewAndFilterBinding()
    }

    private func setupSearchViewAndFilterBinding() {
        self.jsFuncView.itemsList.dataSource = self
        self.jsFuncView.itemsList.delegate = self

        self.jsFuncView.filterText
            .subscribe(onNext: {
                self.jsFuncService.filterText = $0
                self.jsFuncView.itemsList.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    private func setupSearchTextEventBindings() {
        self.events
            .subscribe(onNext: { event in
                switch event {

                case .closeAndPaste:
                    self.closeAndPaste()

                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func resetJSFuncSearchText() {
        self.jsFuncView.searchText.string = ""
        self.jsFuncView.filterText.onNext("")
        self.jsFuncView.itemsList.reloadData()
    }

    @objc func fakePaste() {
        fakeKey.send(fakeKey: "V", useCommandFlag: true)
    }

    @objc func hideApp() {
        NSApp.hide(self)
    }

    private func closeAndPaste() {
        self.pasteSelectedClipToPasteboard()
        self.jsFuncPopup.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    func pasteSelectedClipToPasteboard() {
        guard !self.selectedClips.isEmpty else { return }

        let row = self.jsFuncView.itemsList.selectedRow
        var clip: String

        if let name = JSFuncService.shared.list[safe: row] {
            clip = JSFuncService.shared.process(name, items: self.selectedClips)
        } else {
            clip = prefs.prepareClips(self.selectedClips)
        }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(clip, forType: .string)
    }

    private func configureJSPopupAndView() {
        self.jsFuncView.placeHolderTextString = "js_func_search_placeholder".l7n
        self.jsFuncPopup.proportionalTopPadding = 0.15
        self.jsFuncPopup.proportionalWidth = 0.6
        self.jsFuncPopup.proportionalHeight = 0.6
        self.jsFuncPopup.willOpenPopup = self.jsFuncPopup.proportionalResizePopup
        self.jsFuncPopup.didOpenPopup = {
            guard let window = self.jsFuncView.window
                else { fatalError("No window found for popup") }

            self.resetJSFuncSearchText()
            // Focus search text
            window.makeFirstResponder(self.jsFuncView.searchText)
        }

        self.jsFuncPopup.willClosePopup = self.resetJSFuncSearchText
    }
}
