//
//  HotKeyService.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet
import RxSwift

class HotKeyService {

    private let disposeBag = DisposeBag()

    static let shared = HotKeyService()

    var searchCustomKeyCombo = PublishSubject<KeyCombo>()
    var controller: CutBoxController?

    func configure(controller: CutBoxController) {
        self.controller = controller

        self.searchCustomKeyCombo
            .distinctUntilChanged {
                $0.keyCode == $1.keyCode && $0.modifiers == $1.modifiers
            }
            .subscribe(onNext: { self.changeGlobalToggle(keyCombo: $0) })
            .disposed(by: disposeBag)
    }

    func resetDefaultGlobalToggle() {
        if let savedKeyCombo = KeyCombo.loadFromUserDefaults(identifier: Constants.searchKeyComboUserDefaults) {
            self.searchCustomKeyCombo
                .onNext(savedKeyCombo)
        } else {
            self.searchCustomKeyCombo
                .onNext(Constants.defaultSearchCustomKeyCombo)
        }
    }

    fileprivate func changeGlobalToggle(keyCombo: KeyCombo) {
        guard let controller = self.controller else {
            fatalError("HotKeyService")
        }

        let hotKey = HotKey(
            identifier: Constants.searchKeyComboUserDefaults,
            keyCombo: keyCombo,
            target: controller,
            action: #selector(controller.searchClicked(_:))
        )

        hotKey.register()

        keyCombo.saveToUserDefaults(identifier: Constants.searchKeyComboUserDefaults)
    }
}
