//
//  AppDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        CutBoxPreferencesService.shared.loadJavascript()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
}

public struct StandardErrorOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}

public var errStream = StandardErrorOutputStream()
