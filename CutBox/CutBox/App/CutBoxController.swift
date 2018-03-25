//
//  CutBoxController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

// Central controller object, binds things together and runs the status item

import Cocoa
import RxSwift
import RxCocoa
import HotKey

class CutBoxController: NSObject {

    let popupController: PopupController
    let pasteboardService: PasteboardService
    let searchView: SearchView
    var screen: NSScreen
    var width: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat
    let disposeBag = DisposeBag()

    @IBOutlet weak var statusMenu: NSMenu!

    let hotKey = HotKey(key: .v, modifiers: [.control, .command, .option])

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    override init() {
        guard let mainScreen = NSScreen.main else {
            fatalError("Unable to get main screen")
        }

        // Read from keychain

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

        setupFilterBinding()
        setupPopup()
        setupHotkey()
    }

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        popupController.togglePopup()
    }

    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        pasteboardService.saveToDefaults()
        NSApplication.shared.terminate(self)
    }

    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }

    private func setupFilterBinding() {
        self.searchView.clipboardItemsTable.dataSource = self
        self.searchView.clipboardItemsTable.delegate = self
        self.searchView.filterText
            .bind {
                self.pasteboardService.filterText = $0
                self.searchView.clipboardItemsTable.reloadData()
            }
            .disposed(by: self.disposeBag)
    }

    private func setupHotkey() {
        self.hotKey.keyDownHandler = self.popupController.togglePopup
    }

    private func resetSearchText() {
        self.searchView.searchText.string = ""
        self.searchView.filterText.onNext("")
        self.searchView.clipboardItemsTable.reloadData()
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
                self.resetSearchText()
                self.searchView
                    .searchText
                    .window?
                    .makeFirstResponder(self.searchView.searchText)
        }

        self.popupController
            .willClosePopup = {
                self.resetSearchText()
        }
    }
}

extension CutBoxController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let count = self.pasteboardService.count
        return count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let value = self.pasteboardService[row] else { return nil }

        return value
    }
}

extension CutBoxController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let _ = self.pasteboardService[row] else { return nil }

        let identifier = NSUserInterfaceItemIdentifier(rawValue: "pasteBoardItemsTableTextField")
        var textField: NSTextField? = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTextField

        if textField == nil {
            textField = NSTextField(frame: CGRect(x: 0, y: 0,
                                                  width: tableView.frame.width,
                                                  height: 20))
            textField?.textColor = NSColor.white
            textField?.cell?.isBordered = false
            textField?.cell?.backgroundStyle = .dark
            textField?.backgroundColor = NSColor.clear
            textField?.isBordered = false
            textField?.isSelectable = false
            textField?.isEditable = false
            textField?.bezelStyle = .roundedBezel
            textField?.identifier = identifier
        }

        return textField
    }
}


