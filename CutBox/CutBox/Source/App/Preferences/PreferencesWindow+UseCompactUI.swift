//
//  PreferencesWindow+UseCompactUI.swift
//  CutBox
//
//  Created by Jason on 29/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesWindow {
    func setupCompactUIControl() {
        self.compactUICheckbox.title = "preferences_use_compact_ui".l7n
        self.compactUICheckbox.toolTip = "preferences_use_compact_ui_tooltip".l7n

        self.compactUICheckbox.state = self.prefs.useCompactUI ? .on : .off

        self.compactUICheckbox
            .rx
            .state
            .map { $0 == .on }
            .subscribe(onNext: { self.prefs.useCompactUI = $0 })
            .disposed(by: disposeBag)

        self.prefs
            .events
            .subscribe(onNext: {
                if case .compactUISettingChanged(let isOn) = $0 {
                    self.compactUICheckbox.state = isOn ? .on : .off
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PreferencesWindow{
    func setupProtectFavoritesCheckbox() {
        self.protectFavoritesCheckbox.toolTip = "preferences_protect_favorites_tooltip".l7n
        self.protectFavoritesCheckbox.title = "preferences_protect_favorites".l7n

        self.protectFavoritesCheckbox.state = self.prefs.protectFavorites ? .on : .off

        self.protectFavoritesCheckbox
            .rx
            .state
            .map { $0 == .on }
            .subscribe(onNext: {
                self.prefs.protectFavorites = $0
            })
            .disposed(by: disposeBag)

        self.prefs
            .events
            .subscribe(onNext: {
                if case .protectFavoritesChanged(let isOn) = $0 {
                    self.protectFavoritesCheckbox.state = isOn ? .on : .off
                }
            })
            .disposed(by: disposeBag)
    }
}
