//
//  AboutPanel.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

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
