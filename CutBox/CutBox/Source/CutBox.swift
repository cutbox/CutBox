//
//  AppDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet

/// CutBox main
@NSApplicationMain class CutBox: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        CutBoxPreferencesService.shared.loadJavascript()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
}
