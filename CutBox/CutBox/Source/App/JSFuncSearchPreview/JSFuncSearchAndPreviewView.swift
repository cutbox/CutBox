//
//  JSFuncSearchAndPreviewView.swift
//  CutBox
//
//  Created by Jason on 16/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

class JSFuncSearchAndPreviewView: SearchPreviewView {

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
    
    override func applyTheme() {
        super.applyTheme()

        colorizeMagnifier()
    }
}

