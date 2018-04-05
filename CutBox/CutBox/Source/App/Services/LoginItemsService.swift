//
//  LoginItemsService.swift
//  CutBox
//
//  Created by Jason on 4/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
import ServiceManagement
import RxCocoa
import RxSwift

class LoginItemsService {

    static let shared = LoginItemsService()

    private let kHelperAppIdentifier = "info.ocodo.CutBoxHelper" as CFString
    private let kAutoLoginEnabled = "CutBoxAutoLoginEnabled"
    private let disposeBag = DisposeBag()

    let autoLoginEnabled: BehaviorRelay<NSControl.StateValue>

    init() {
        let saved: NSControl.StateValue = NSControl.StateValue(rawValue:
            UserDefaults.standard.integer(forKey: kAutoLoginEnabled)
        )
        autoLoginEnabled = BehaviorRelay(value: saved)

        autoLoginEnabled
            .asObservable()
            .subscribe(onNext: { self.setAutoLogin($0) })
            .disposed(by: disposeBag)
    }

    fileprivate func setAutoLogin(_ state: NSControl.StateValue) {
        if SMLoginItemSetEnabled(self.kHelperAppIdentifier, state.rawValue == 1) {
            UserDefaults.standard.set(state, forKey: kAutoLoginEnabled)
            NSLog("\(state.rawValue == 1 ? "Added" : "Removed") login item \(kHelperAppIdentifier)")
        } else {
            NSLog("Failed to configure login item \(kHelperAppIdentifier).")
        }
    }
}
