//
//  PreferencesGeneralView+AutoLogin.swift
//  CutBox
//
//  Created by Jason on 11/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesGeneralView {
    func setupAutoLoginControl() {
        self.autoLoginCheckbox.title = "preferences_launch_on_login".l7n
        self.autoLoginCheckbox.toolTip = "preferences_launch_on_login_tooltip".l7n
        self.loginItemsService
            .autoLoginEnabled
            .asObservable()
            .bind(to: self.autoLoginCheckbox.rx.state)
            .disposed(by: disposeBag)

        self.autoLoginCheckbox.rx.state
            .bind(to: self.loginItemsService.autoLoginEnabled)
            .disposed(by: disposeBag)
    }
}
