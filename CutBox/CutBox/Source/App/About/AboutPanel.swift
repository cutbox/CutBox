//
//  AboutPanel.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class LinkText: NSTextField {

    override func mouseDown(with event: NSEvent) {
        NSWorkspace
            .shared
            .open(
                URL(string: CutBoxPreferences
                    .shared.url)!)
    }

}

class AboutPanel: NSPanel {

    @IBOutlet weak var productTitle: NSTextField!
    @IBOutlet weak var productVersion: NSTextField!
    @IBOutlet weak var productHomeUrl: LinkText!
    @IBOutlet weak var productLicense: NSTextField!

    override func awakeFromNib() {
        if #available(OSX 10.10, *) {
            self.titlebarAppearsTransparent = true
        }

        let prefs = CutBoxPreferences.shared

        productTitle.stringValue = prefs.cutBoxProductTitle
        productHomeUrl.stringValue = prefs.cutBoxProductHomeUrl
        productLicense.stringValue = prefs.cutBoxCopyrightLicense
        productVersion.stringValue = prefs.cutBoxVersionString
    }
}
