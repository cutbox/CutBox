//
//  JSFuncItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//
import Cocoa

class JSFuncItemTableRowTextView: ItemTableRowTextView {
    override func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        guard let titleString = data["string"] as? String else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
