//
//  HotKeyService.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Magnet
import RxSwift

enum HotKeyEvents {
    case search
}

class CutBoxHotkeyProvider: NSObject {
    static var testMode: Bool = false
    var createWasCalled: Bool = false

    func create(identifier: String,
                keyCombo: KeyCombo,
                target: AnyObject,
                action: Selector
    ) -> HotKey? {
        self.createWasCalled = true
        guard !Self.testMode  else { return nil }
        return HotKey(
            identifier: identifier,
            keyCombo: keyCombo,
            target: target,
            action: action
        )
    }
}

class HotKeyService: NSObject {
    static let shared = HotKeyService(hotkeyProvider: CutBoxHotkeyProvider())
    var hotkeyProvider: CutBoxHotkeyProvider
    var searchKeyCombo = PublishSubject<KeyCombo>()
    var events = PublishSubject<HotKeyEvents>()

    private let disposeBag = DisposeBag()

    init(hotkeyProvider: CutBoxHotkeyProvider) {
        self.hotkeyProvider = hotkeyProvider
    }

    func configure() {
        self.searchKeyCombo
            .distinctUntilChanged { $0 == $1 }
            .subscribe(onNext: {
                self.changeGlobalToggle(keyCombo: $0)
            })
            .disposed(by: disposeBag)

        self.resetDefaultGlobalToggle()
    }

    func resetDefaultGlobalToggle() {
        if let savedKeyCombo = KeyCombo.loadUserDefaults(identifier: Constants.cutBoxToggleKeyCombo) {
            self.searchKeyCombo
                .onNext(savedKeyCombo)
        } else {
            self.searchKeyCombo
                .onNext(Constants.defaultCutBoxToggleKeyCombo)
        }
    }

    @objc func search(_ sender: Any) {
        self.events.onNext(.search)
    }

    fileprivate func changeGlobalToggle(keyCombo: KeyCombo) {
        if let hotKey = hotkeyProvider.create(
            identifier: Constants.cutBoxToggleKeyCombo,
            keyCombo: keyCombo,
            target: self,
            action: #selector(search(_:))
        ) {
            hotKey.register()
            keyCombo.saveUserDefaults(identifier: Constants.cutBoxToggleKeyCombo)
        }
    }
}
