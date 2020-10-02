//
//  AboutPanel.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

class LinkText: NSTextField {

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
        NSWorkspace
            .shared
            .open(URL(string: "about_cutbox_home_url".l7n)!)
    }
}

class AboutPanel: NSPanel {
    @IBOutlet weak var productTitle: NSTextField!
    @IBOutlet weak var productVersion: NSTextField!
    @IBOutlet weak var productHomeUrl: LinkText!
    @IBOutlet weak var productLicense: NSTextField!

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        productVersion.stringValue = VersionService.version

        productTitle.stringValue = "about_cutbox_title".l7n
        productLicense.stringValue = "about_cutbox_copyright_licence".l7n
    }
}
