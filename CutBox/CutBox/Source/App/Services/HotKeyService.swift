//
//  HotKeyService.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet
import RxSwift

enum HotKeyEvents {
    case search
}

class HotKeyService: NSObject {

    static let shared = HotKeyService()

    private let disposeBag = DisposeBag()

    var searchKeyCombo = PublishSubject<KeyCombo>()

    var events = PublishSubject<HotKeyEvents>()

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
        if let savedKeyCombo = KeyCombo.loadUserDefaults(identifier: Constants.kCutBoxToggleKeyCombo) {
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
        let hotKey = HotKey(
            identifier: Constants.kCutBoxToggleKeyCombo,
            keyCombo: keyCombo,
            target: self,
            action: #selector(search(_:))
        )

        hotKey.register()

        keyCombo.saveUserDefaults(identifier: Constants.kCutBoxToggleKeyCombo)
    }
}
