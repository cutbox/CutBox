//
//  CutBox.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet

/// CutBox main
@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

    var prefs = CutBoxPreferencesService.shared
    var hotkeyCenter = HotKeyCenter.shared

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        prefs.loadJavascript()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        hotkeyCenter.unregisterAll()
    }
}
