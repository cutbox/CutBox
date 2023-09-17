//
//  PreferencesTabViewController.swift
//  CutBox
//
//  Created by Jason Milkins on 12/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet

class PreferencesTabView: CutBoxBaseTabView, NSTabViewDelegate {

    private let generalTab: PreferencesGeneralView = PreferencesGeneralView.fromNib()!
    private let advancedTab: PreferencesAdvancedView = PreferencesAdvancedView.fromNib()!
    private let themeTab: PreferencesThemeSelectionView = PreferencesThemeSelectionView.fromNib()!
    private let javascriptTab: PreferencesPastePipelineView = PreferencesPastePipelineView.fromNib()!

    override func awakeFromNib() {

        self.delegate = self

        typealias TabInfo = (String, CutBoxBaseView)

        let tabViews: [TabInfo] = [
          ("preferences_tab_view_general".l7n, generalTab),
          ("preferences_tab_view_display".l7n, themeTab),
          ("preferences_tab_view_advanced".l7n, advancedTab),
          ("preferences_tab_view_javascript".l7n, javascriptTab)
        ]

        tabViews.forEach {
            let (name, view) = $0
            let tabViewItem = CutBoxBaseTabViewItem()
            tabViewItem.label = name
            tabViewItem.identifier = name
            tabViewItem.view = view

            self.addTabViewItem(tabViewItem)
        }
    }

    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if javascriptTab == tabViewItem?.view {
            javascriptTab.focusReplCommandLine()
        }
    }
}
