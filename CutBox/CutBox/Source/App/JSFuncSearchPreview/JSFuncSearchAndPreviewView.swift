//
//  JSFuncSearchAndPreviewView.swift
//  CutBox
//
//  Created by Jason on 16/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

class JSFuncSearchAndPreviewView: SearchPreviewViewBase {

    var events = PublishSubject<SearchJSFuncViewEvents>()

    override func awakeFromNib() {
        self.placeHolderTextString = "search_placeholder".l7n
        setupSearchText()

        super.awakeFromNib()
    }

    private func setupSearchText() {
        self.searchText.isFieldEditor = true
        self.searchText.delegate = self
    }

    func setupClipItemsContextMenu() {
        let reload = NSMenuItem(title: "preferences_javascript_transform_reload".l7n,
                                action: #selector(reloadJS),
                                keyEquivalent: "")

        let contextMenu = NSMenu()
        contextMenu.addItem(reload)

        self.itemsList.menu = contextMenu
    }

    override func applyTheme() {
        super.applyTheme()

        colorizeMagnifier()
    }

    @objc func reloadJS(_ sender: NSMenuItem) {
        prefs.loadJavascript()
        self.itemsList.reloadData()
    }

}
