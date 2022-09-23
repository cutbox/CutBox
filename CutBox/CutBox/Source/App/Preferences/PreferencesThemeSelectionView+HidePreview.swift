//
//  PreferencesThemeSelectionView+HidePreview.swift
//  CutBox
//
//  Created by Carlos Enumo on 22/09/22.
//  Copyright © 2022 Carlos Enumo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesThemeSelectionView {

    func setupHidePreviewControl() {
        self.hidePreviewCheckbox.title = "preferences_hide_preview".l7n
        self.hidePreviewCheckbox.toolTip = "preferences_hide_preview_tooltip".l7n

        self.hidePreviewCheckbox.state = self.prefs.hidePreview ? .on : .off

        self.hidePreviewCheckbox
            .rx
            .state
            .map { $0 == .on }
            .subscribe(onNext: { self.prefs.hidePreview = $0 })
            .disposed(by: disposeBag)

        self.prefs
            .events
            .subscribe(onNext: {
                if case .hidePreviewSettingChanged(let isOn) = $0 {
                    self.hidePreviewCheckbox.state = isOn ? .on : .off
                }
            })
            .disposed(by: disposeBag)
    }
}
