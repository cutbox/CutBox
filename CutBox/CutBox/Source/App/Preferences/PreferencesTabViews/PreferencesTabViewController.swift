//
//  PreferencesTabViewController.swift
//  CutBox
//
//  Created by Jason on 12/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet

class PreferencesTabView: NSTabView {
    let generalTab: PreferencesGeneralView = PreferencesGeneralView.fromNib()!
    let advancedTab: PreferencesAdvancedView = PreferencesAdvancedView.fromNib()!
    let themeTab: PreferencesThemeSelectionView = PreferencesThemeSelectionView.fromNib()!
    let javascriptTab: PreferencesJavascriptProcessingView = PreferencesJavascriptProcessingView.fromNib()!

    typealias Tab = (String, NSView)

    override func awakeFromNib() {
        let tabViews: [Tab] = [
            ("General", generalTab),
            ("Display", themeTab),
            ("Advanced", advancedTab),
//            ("Javascript", javascriptTab)
        ]

        tabViews.forEach {
            let (name, view) = $0
            let tabViewItem = NSTabViewItem()
            tabViewItem.label = name
            tabViewItem.identifier = name
            tabViewItem.view = view

            self.addTabViewItem(tabViewItem)
        }
    }
}

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
