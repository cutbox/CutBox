//
//  StatusMenuController.swift
//  CutBox
//
//  Created by jason on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
