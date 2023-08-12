//
//  ValidTextField.swift
//  CutBox
//
//  Created by jason on 12/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

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
            // Update the appearance based on the validity status
            updateBorderColor()
        }
    }

    private func updateBorderColor() {
        let greenColor = NSColor.green.withAlphaComponent(0.15).cgColor
        let redColor = NSColor.red.withAlphaComponent(0.15).cgColor

        if let fieldLayer = self.layer {
            fieldLayer.borderColor = isValid ? redColor : greenColor
            fieldLayer.borderWidth = 1
            fieldLayer.cornerRadius = 3
        }
    }
}
