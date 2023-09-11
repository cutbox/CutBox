//
//  LinkText.swift
//  CutBox
//
//  Created by jason on 8/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

class LinkText: CutBoxBaseTextField {
    // Injectable NSWorkspace
    var workspace: NSWorkspace = NSWorkspace.shared

    @IBInspectable
    var linkColor: NSColor!

    override func awakeFromNib() {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: linkColor as Any,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: linkColor as Any
        ]
        attributedStringValue = NSAttributedString(string: "about_cutbox_home_url".l7n, attributes: attributes)
    }

    override func mouseDown(with event: NSEvent) {
        if let url = URL(string: "about_cutbox_home_url".l7n) {
            workspace.open(url)
        }
    }
}
