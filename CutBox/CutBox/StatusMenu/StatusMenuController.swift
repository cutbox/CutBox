//
//  StatusMenuController.swift
//  CutBox
//
//  Created by jason on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

// Setup the status item (linked in CutBox.xib)
// ini the popup controller and search view

import Cocoa
import HotKey

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!

    let hotKey = HotKey(key: .v, modifiers: [.control, .command, .option])
    let popup: PopupController
    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let searchView: SearchView
    var screen: NSScreen
    var width: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat

    override init() {
        guard let mainScreen = NSScreen.main else {
            fatalError("Unable to get main screen")
        }

        self.screen = mainScreen
        self.width = self.screen.frame.width / 2.5
        self.minHeight = self.screen.frame.width / 8
        self.maxHeight = self.screen.frame.width / 2.5

        self.searchView = SearchView(frame:
            CGRect(x: 0, y: 0,
                   width: self.width,
                   height: self.minHeight)
        )

        self.popup = PopupController(contentView: self.searchView)

        super.init()
        setupPopup()
        setupHotkey()
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

    private func setupHotkey() {
        self.hotKey.keyDownHandler = self.popup.togglePopup
    }

    private func setupPopup() {
        self.popup.backgroundView.backgroundColor = NSColor.black
        self.popup.backgroundView.alphaValue = 0.8
        self.popup.resizePopup(width: self.width,
                               height: self.minHeight)
        self.popup.didOpenPopup = {
            debugPrint("Opened popup")
        }

        self.popup.didClosePopup = {
            debugPrint("Closed popup")
        }
    }
}

