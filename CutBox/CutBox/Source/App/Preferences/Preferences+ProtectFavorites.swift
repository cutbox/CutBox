//
//  Preferences+ProtectFavorites.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension PreferencesGeneralView {

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
