//
//  PreferencesWindow+AutoLogin.swift
//  CutBox
//
//  Created by Jason on 11/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesWindow {
    func setupAutoLoginControl() {
        self.loginItemsService
            .autoLoginEnabled
            .asObservable()
            .bind(to: self.autoLoginCheckbox.rx.state )
            .disposed(by: disposeBag)

        self.autoLoginCheckbox.rx.state
            .bind(to: self.loginItemsService.autoLoginEnabled)
            .disposed(by: disposeBag)
    }
}
