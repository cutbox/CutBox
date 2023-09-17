//
//  JSFuncSearchViewController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import RxSwift

class JSFuncSearchViewController: NSObject {

    var js: JSFuncService
    var selectedClips: [String] = []
    var jsFuncView: JSFuncSearchAndPreviewView
    var prefs: CutBoxPreferencesService
    var fakeKey: FakeKey
    var jsFuncPopup: PopupController
    var pasteboard: PasteboardWrapperType

    var hasFuncs: Bool {
        return !self.js.isEmpty
    }

    var count: Int {
        return self.js.count
    }

    var funcList: [String] {
        return self.js.funcList
    }

    var events: PublishSubject<SearchJSFuncViewEvents> {
        return self.jsFuncView.events
    }

    let disposeBag = DisposeBag()

    init(js: JSFuncService = JSFuncService(),
         cutBoxPreferences: CutBoxPreferencesService = CutBoxPreferencesService.shared,
         fakeKey: FakeKey = FakeKey(),
         jsFuncView: JSFuncSearchAndPreviewView = JSFuncSearchAndPreviewView.fromNib()!,
         pasteboard: PasteboardWrapperType = PasteboardWrapper()) {

        self.js = js
        self.prefs = cutBoxPreferences
        self.fakeKey = fakeKey
        self.jsFuncView = jsFuncView
        self.jsFuncPopup = PopupController(content: self.jsFuncView)
        self.pasteboard = pasteboard
        super.init()
        self.setup()
    }

    func setup() {
        self.configureJSPopupAndView()
        self.setupSearchTextEventBindings()
        self.setupSearchViewAndFilterBinding()
    }

    private func setupSearchViewAndFilterBinding() {
        self.jsFuncView.itemsList?.dataSource = self
        self.jsFuncView.itemsList?.delegate = self

        self.jsFuncView.filterTextPublisher
            .subscribe(onNext: {
                self.js.filterText = $0
                self.jsFuncView.itemsList?.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    private func setupSearchTextEventBindings() {
        self.events
            .subscribe(onNext: { event in
                switch event {
                case .closeAndPaste:
                    self.closeAndPaste()

                case .justClose:
                    self.justClose()

                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func resetJSFuncSearchText() {
        self.jsFuncView.searchText?.string = ""
        self.jsFuncView.filterTextPublisher.onNext("")
        self.jsFuncView.itemsList?.reloadData()
    }

    @objc func fakePaste() {
        fakeKey.send(fakeKey: "V", useCommandFlag: true)
    }

    @objc func hideApp() {
        NSApp.hide(self)
    }

    private func justClose() {
        self.jsFuncPopup.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
    }

    private func closeAndPaste() {
        self.pasteSelectedClips()
        self.jsFuncPopup.closePopup()
        perform(#selector(hideApp), with: self, afterDelay: 0.1)
        perform(#selector(fakePaste), with: self, afterDelay: 0.25)
    }

    func pasteSelectedClips() {
        guard !self.selectedClips.isEmpty else {
            return
        }

        let row = self.jsFuncView.itemsList.selectedRow
        var clip: String

        if let name = js.funcList[safe: row] {
            clip = js.process(name, items: self.selectedClips)
        } else {
            clip = prefs.prepareClips(self.selectedClips)
        }

        pasteboard.clearContents()
        pasteboard.setString(string: clip)
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
        self.jsFuncView.setupClipItemsContextMenu()
    }
}
