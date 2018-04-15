//
//  PreferencesWindow+MultipleItemWrapping.swift
//  CutBox
//
//  Created by Jason on 11/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxSwift
import RxCocoa

extension PreferencesWindow {
    func setupWrappingStringTextFields() {

        self.shouldWrapMultipleSelection.title = "preferences_multi_clip_wrapped_checkbox_label".l7n
        self.wrapStartTextField.placeholderString = "preferences_multi_clip_wrapped_start_placeholder".l7n
        self.wrapEndTextField.placeholderString = "preferences_multi_clip_wrapped_end_placeholder".l7n
        
        let (start, end) = prefs.wrappingStrings
        self.wrapStartTextField.stringValue = start ?? ""
        self.wrapEndTextField.stringValue = end ?? ""

        let shouldWrapSaved = prefs.useWrappingStrings
        self.shouldWrapMultipleSelection.state = shouldWrapSaved ? .on : .off
        updateWrappingMultipleSelection(shouldWrapSaved)

        Observable
            .combineLatest(self.wrapStartTextField.rx.text,
                           self.wrapEndTextField.rx.text)
            { ($0, $1) }
            .skip(1)
            .subscribe(onNext: { self.prefs.wrappingStrings = $0 })
            .disposed(by: disposeBag)

        self.shouldWrapMultipleSelection.rx.state
            .skip(1)
            .map { $0 == .on }
            .subscribe(onNext: { self.updateWrappingMultipleSelection($0) })
            .disposed(by: disposeBag)
    }

    func updateWrappingMultipleSelection(_ bool: Bool) {
        prefs.useWrappingStrings = bool
        [self.wrapStartTextField,
         self.wrapEndTextField]
            .forEach { $0?.isEnabled = bool }
    }
}
