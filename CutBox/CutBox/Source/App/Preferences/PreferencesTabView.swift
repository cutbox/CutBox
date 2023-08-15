//
//  PreferencesTabViewController.swift
//  CutBox
//
//  Created by Jason Milkins on 12/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet

class PreferencesTabView: NSTabView {

    let generalTab: PreferencesGeneralView = PreferencesGeneralView.fromNib()!
    let advancedTab: PreferencesAdvancedView = PreferencesAdvancedView.fromNib()!
    let themeTab: PreferencesThemeSelectionView = PreferencesThemeSelectionView.fromNib()!
    let javascriptTab: PreferencesJavascriptTransformView = PreferencesJavascriptTransformView.fromNib()!

    typealias Tab = (String, NSView)

    override func awakeFromNib() {
        let tabViews: [Tab] = [
          ("preferences_tab_view_general".l7n, generalTab),
          ("preferences_tab_view_display".l7n, themeTab),
          ("preferences_tab_view_advanced".l7n, advancedTab),
          ("preferences_tab_view_javascript".l7n, javascriptTab)
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
