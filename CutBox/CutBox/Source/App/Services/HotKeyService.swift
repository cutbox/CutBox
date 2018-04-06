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

    static let shared = HotKeyService()

    private let disposeBag = DisposeBag()

    var searchKeyCombo = PublishSubject<KeyCombo>()
    var controller: CutBoxController?

    func configure(controller: CutBoxController) {
        self.controller = controller

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

    fileprivate func changeGlobalToggle(keyCombo: KeyCombo) {
        guard let controller = self.controller else {
            fatalError("HotKeyService has no controller configured")
        }

        let hotKey = HotKey(
            identifier: Constants.kCutBoxToggleKeyCombo,
            keyCombo: keyCombo,
            target: controller,
            action: #selector(controller.searchClicked(_:))
        )

        hotKey.register()

        keyCombo.saveUserDefaults(identifier: Constants.kCutBoxToggleKeyCombo)
    }
}
