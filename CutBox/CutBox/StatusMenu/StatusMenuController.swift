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
    let popupController: PopupController
    let pasteboardService: PasteboardService

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    let searchView: SearchView
    var screen: NSScreen
    var width: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat

    override init() {
        guard let mainScreen = NSScreen.main else {
            fatalError("Unable to get main screen")
        }

        self.pasteboardService = PasteboardService()
        self.pasteboardService.startTimer()
        self.screen = mainScreen
        self.width = self.screen.frame.width / 2.5
        self.minHeight = self.screen.frame.width / 8
        self.maxHeight = self.screen.frame.width / 2.5

        self.searchView = SearchView.fromNib() ?? SearchView()

        self.popupController = PopupController(
            content: self.searchView
        )

        super.init()

        setupPopup()
        setupHotkey()
    }

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        popupController.togglePopup()
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
        self.hotKey.keyDownHandler = self.popupController.togglePopup
    }

    private func setupPopup() {
        self.popupController
            .backgroundView
            .backgroundColor = NSColor.black

        self.popupController
            .backgroundView
            .alphaValue = 0.8

        self.popupController
            .resizePopup(width: self.width,
                         height: self.minHeight)

        self.popupController
            .didOpenPopup = {
            debugPrint("Opened popup")
        }

        self.popupController
            .didClosePopup = {
            debugPrint("Closed popup")
        }
    }
}

extension NSView {
    class func fromNib<T: NSView>() -> T? {
        var viewArray: NSArray? = nil
        guard Bundle.main.loadNibNamed(NSNib.Name(rawValue: String(describing: T.self)),
                                       owner: nil,
                                       topLevelObjects: &viewArray) else { return nil }
        return viewArray?.first(where: { $0 is T }) as? T
    }
}

