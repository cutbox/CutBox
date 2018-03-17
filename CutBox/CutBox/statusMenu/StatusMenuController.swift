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

    @IBAction func pasteClicked(_ sender: NSMenuItem) {
        // Show recent paste board items
    }

    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
}
