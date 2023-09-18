//
//  TransientScrollView.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

@IBDesignable

public class TransientScrollView: NSScrollView {
    @IBInspectable @objc(enabled) public var isEnabled: Bool = true

    public override func becomeFirstResponder() -> Bool {
        return true
    }

    public override func scrollWheel(with event: NSEvent) {
        if isEnabled {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
}
