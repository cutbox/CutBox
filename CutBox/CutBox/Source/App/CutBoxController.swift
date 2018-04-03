//
//  CutBoxController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

// Central controller object, binds things togethe
// and runs the status item

import Cocoa
import RxSwift
import RxCocoa
import Magnet

class CutBoxController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!

    let searchViewController: SearchViewController
    let preferencesWindow: PreferencesWindow = PreferencesWindow.fromNib()!
    let aboutPanel: AboutPanel = AboutPanel.fromNib()!
    let hotKeyService = HotKeyService.shared

    let disposeBag = DisposeBag()

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        self.searchViewController.togglePopup()
    }

    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        self.searchViewController.pasteboardService.saveToDefaults()
        NSApplication.shared.terminate(self)
    }

    @IBAction func clearHistoryClicked(_ sender: NSMenuItem) {
        self.searchViewController.pasteboardService.clear()
    }

    @IBAction func openPreferences(_ sender: NSMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        preferencesWindow.makeKeyAndOrderFront(self)
        preferencesWindow.center()
    }

    @IBAction func openAboutPanel(_ sender: NSMenuItem) {
        aboutPanel.makeKeyAndOrderFront(self)
        aboutPanel.center()
    }

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    override init() {
        self.searchViewController = SearchViewController()
        super.init()
        self.hotKeyService.configure(controller: self)
        self.hotKeyService.resetDefaultGlobalToggle()
    }

    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        self.statusItem.image = icon
        self.statusItem.menu = statusMenu
    }
}
