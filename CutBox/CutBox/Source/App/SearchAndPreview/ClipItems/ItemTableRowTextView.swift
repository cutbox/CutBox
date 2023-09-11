//
//  ItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowTextView: NSView {

    @IBOutlet weak var title: CutBoxBaseTextField!

    let prefs = CutBoxPreferencesService.shared

    var internalColor: NSColor = .textColor {
        didSet {
            self.title.textColor = internalColor
        }
    }

    var color: NSColor {
        get {
            return internalColor
        }

        set {
            internalColor = newValue
        }
    }

    var internalData: [String: Any]? {
        didSet {
            setup()
        }
    }
    var data: [String: Any]? {
        get {
            return internalData
        }
        set {
            internalData = newValue
        }
    }

    func setup() {
        title.font = self.prefs.searchViewClipTextFieldFont
    }
}
