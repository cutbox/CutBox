//
//  NSTableView+getRowView.swift
//  CutBox
//
//  Created by Jason Milkins on 10/5/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa

extension NSTableView {

    func getRowView<T: NSView>() -> T {
        let identifier = NSUserInterfaceItemIdentifier(
            rawValue: "\(T.self)")

        var dequeuedRowView: T? = self.makeView(
            withIdentifier: identifier, owner: self
            ) as? T

        if dequeuedRowView == nil {
            dequeuedRowView = T.fromNib()
            dequeuedRowView?.identifier = identifier
        }

        guard let rowView: T = dequeuedRowView
            else { fatalError("Unable to get a \(T.self)") }

        return rowView
    }
}
