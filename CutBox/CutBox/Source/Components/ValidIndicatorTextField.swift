//
//  ValidTextField.swift
//  CutBox
//
//  Created by jason on 12/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

/// Setting isValid updates the
/// field border color (green/red)
///
/// Validation logic handled externally
class ValidIndicatorTextField: TextFieldKeyUpRxStream {
    var isValid: Bool = false {
        didSet {
            updateBorderColor()
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.cell?.focusRingType = .none
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if let fieldLayer = self.layer {
            if stringValue == "" {
                fieldLayer.borderColor = NSColor
                    .white
                    .withAlphaComponent(0.15).cgColor
            }
            fieldLayer.borderWidth = 1.5
            fieldLayer.cornerRadius = 6
            fieldLayer.backgroundColor = NSColor
                .black
                .withAlphaComponent(0.25).cgColor
        }
    }

    private func updateBorderColor() {
        let green = NSColor.green.withAlphaComponent(0.15).cgColor
        let red = NSColor.red.withAlphaComponent(0.15).cgColor

        if let fieldLayer = self.layer {

            fieldLayer.borderColor = isValid ? green : red
            fieldLayer.borderWidth = 2
            fieldLayer.cornerRadius = 3
        }
    }
}
