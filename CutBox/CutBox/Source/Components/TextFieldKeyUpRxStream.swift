//
//  TextFieldKeyUpRxStream.swift
//  CutBox
//
//  Created by jason on 21/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import RxSwift

/// Provide keyUp event stream on a NSTextField
class TextFieldKeyUpRxStream: NSTextField {
    let keyUp = PublishSubject<NSEvent>()

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        keyUp.onNext(event)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
