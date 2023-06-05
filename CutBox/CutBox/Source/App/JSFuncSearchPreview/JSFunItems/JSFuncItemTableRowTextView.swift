//
//  JSFuncItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//
import Cocoa

class JSFuncItemTableRowTextView: ItemTableRowTextView {

    override func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on row view before setup.")
        }

        guard let titleString = data["string"] as? String else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
