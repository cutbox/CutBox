//
//  AboutView.swift
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

class AboutView: NSView {

    @IBOutlet weak var productTitle: NSTextField!
    @IBOutlet weak var productVersion: NSTextField!
    @IBOutlet weak var productInfo: LinkText!
    @IBOutlet weak var productLicense: NSTextField!

    override func awakeFromNib() {

        productTitle.stringValue = "CutBox"

        productInfo.stringValue = "https://github.com/ocodo/CutBox"

        productLicense.stringValue = "Copyright © 2018 Jason Milkins\nLicensed under GNU GPL3"

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] {
            productVersion.stringValue = "version: \(version) (\(buildNumber))"
        }
    }

}
