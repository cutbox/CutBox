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
            joinStringTextField.isHidden = !bool
            joinStringTextField.isEnabled = bool
            prefs.useJoinString = bool
        }
    }

    func setupJoinStringTextField()  {

        self.joinAndWrapSectionTitle.stringValue = "preferences_multi_clip_join_and_wrap_section_title".l7n

        self.joinAndWrapNote.stringValue = "preferences_multi_clip_join_and_wrap_section_note".l7n

        self.joinClipsTitle.stringValue = "preferences_multi_clip_join_title".l7n

        let useJoinString = prefs.useJoinString

        self.joinStyleSelector.setLabel("preferences_multi_clip_joined_by_newline".l7n, forSegment: 0)
        self.joinStyleSelector.setLabel("preferences_multi_clip_joined_by_string".l7n, forSegment: 1)
        self.joinStyleSelector.selectSegment(withTag: useJoinString ? 1 : 0 )

        self.joinStringTextField.isEnabled = useJoinString
        self.joinStringTextField.isHidden = !useJoinString
        self.joinStringTextField.placeholderString = "preferences_multi_clip_joined_by_string_placeholder".l7n

        if let joinString = prefs.multiJoinString {
            self.joinStringTextField.stringValue = joinString
            self.joinStringTextField.isHidden = !useJoinString
            self.joinStringTextField.isEnabled = useJoinString
        }

        self.joinStringTextField.rx.text
            .distinctUntilChanged { lhs, rhs in rhs == lhs }
            .subscribe(onNext: { text in
                if self.joinStringTextField.isEnabled {
                    self.prefs.multiJoinString = text
                }
            })
            .disposed(by: self.disposeBag)
    }
}
