//
//  PreferencesTabViewController.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class PreferencesTabViewController: NSTabViewController {
    let window: PreferencesWindow = PreferencesWindow.fromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func open() {
        window.makeKeyAndOrderFront(self)
        window.center()
    }
}
