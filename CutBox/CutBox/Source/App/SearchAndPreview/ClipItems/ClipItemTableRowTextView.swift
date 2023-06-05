//
//  ClipItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason Milkins on 7/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowTextView: ItemTableRowTextView {

    private var isFavorite: Bool {
        if let data = internalData {
            if let favoriteData = data["favorite"] as? String, !favoriteData.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

    override func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        guard let titleString = data["string"] as? String else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .truncate(limit: 1000)
    }
}
