//
//  PreferencesWindow+JoinItems.swift
//  CutBox
//
//  Created by Jason on 11/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesWindow {
    @IBAction func joinStyleSelectorAction(_ sender: Any) {
        if let selector: NSSegmentedControl = sender as? NSSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isEnabled = bool
            CutBoxPreferences.shared.useJoinString = bool
        }
    }

    func setupJoinStringTextField()  {
        let useJoinString = CutBoxPreferences.shared.useJoinString

        joinStyleSelector.selectSegment(withTag: useJoinString ? 1 : 0 )

        if let joinString = CutBoxPreferences.shared.multiJoinString {
            joinStringTextField.stringValue = joinString
            joinStringTextField.isEnabled = useJoinString
        }

        self.joinStringTextField.rx.text
            .distinctUntilChanged { lhs, rhs in rhs == lhs }
            .subscribe(onNext: { text in
                if self.joinStringTextField.isEnabled {
                    CutBoxPreferences.shared.multiJoinString = text
                }
            })
            .disposed(by: disposeBag)
    }
}
