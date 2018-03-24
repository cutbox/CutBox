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

    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let searchView: SearchView
    let popup: PopupController

    override init() {
        let screen = NSScreen.main

        self.searchView = SearchView(frame:
            CGRect(x: 0, y: 0,
                   width: (screen?.frame.width)! / 2.5,
                   height: (screen?.frame.height)! / 2.5 )
        )

        self.popup = PopupController(contentView: searchView)
        self.popup.backgroundView.backgroundColor = NSColor.black
        self.popup.backgroundView.alphaValue = 0.8
        self.popup.resizePopup(width: searchView.frame.width,
                               height: searchView.frame.height)
        self.popup.didOpenPopup = {
            debugPrint("Opened popup")
        }

        self.popup.didClosePopup = {
            debugPrint("Closed popup")
        }
        super.init()
    }

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        popup.togglePopup()
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

