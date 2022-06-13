//
//  PreferencesWindow.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa
import AppKit
import KeyHolder
import Magnet
import RxSwift
import RxCocoa

class PreferencesWindow: NSWindow {

    @IBOutlet weak var tabView: PreferencesTabView!

    override func awakeFromNib() {
        self.title = "preferences_title".l7n
        self.titlebarAppearsTransparent = true
    }
}
