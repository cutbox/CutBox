//
//  ValidTextField.swift
//  CutBox
//
//  Created by jason on 12/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

/// Setting the isValid property updates the
/// field border color (green/red)
///
/// Validation logic is handled externally
class ValidTextField: NSTextField {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.cell?.focusRingType = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.cell?.focusRingType = .none
        self.isBordered = true
    }

    var isValid: Bool = false {
        didSet {
            updateBorderColor()
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
