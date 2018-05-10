//
//  AppDelegate.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //*
        UserDefaults.standard
            .set(false,
                 forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        // */
    }



    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
}
