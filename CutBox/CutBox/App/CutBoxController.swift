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

class CutBoxController: NSObject {

    let popupController: PopupController
    let pasteboardService: PasteboardService
    let searchView: SearchView
    var screen: NSScreen
    var width: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat

    @IBOutlet weak var statusMenu: NSMenu!

    let hotKey = HotKey(key: .v, modifiers: [.control, .command, .option])

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

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

        self.searchView.clipboardItemsTable.dataSource = self
        self.searchView.clipboardItemsTable.delegate = self

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
                self.searchView.clipboardItemsTable.reloadData()
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

extension CutBoxController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.pasteboardService.count()
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier(rawValue: "TextItem")
        var textField: NSTextField? = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTextField

        if textField == nil {
            textField = NSTextField(frame: CGRect(x: 0, y: 0,
                                                  width: tableView.frame.width,
                                                  height: 20))
            textField?.textColor = NSColor.white
            textField?.cell?.isBordered = false
            textField?.cell?.backgroundStyle = .dark
            textField?.backgroundColor = NSColor.clear
            textField?.identifier = identifier
        }

        let value = self.pasteboardService.getItem(row) ?? "empty"

        textField?.stringValue = value

        return textField
    }
}

