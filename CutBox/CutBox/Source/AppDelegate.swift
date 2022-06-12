//
//  AppDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        CutBoxPreferencesService.shared.loadJavascript()

        #if DEBUG
            NSLog("DEBUG MODE")
            if ProcessInfo().arguments.contains("search-ui-test") {
                configureSearchUITest()
            }

        #endif
    }

    func configureSearchUITest() {
        NSLog("configure testing")
        HistoryService.shared.clear()
        HistoryService.shared.searchMode = .fuzzyMatch
        HistoryService.shared.favoritesOnly = false
        HistoryService.shared.historyRepo.insert("App test", at: 0, isFavorite: true)

        // Open search popup
        HotKeyService.shared.search(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
}

public struct StandardErrorOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}

public var errStream = StandardErrorOutputStream()
