//
//  NSView+fromNib.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension NSView {
    class func fromNib<T: NSView>() -> T? {
        var viewArray: NSArray? = nil
        guard Bundle.main.loadNibNamed(NSNib.Name(rawValue: String(describing: T.self)),
                                       owner: nil,
                                       topLevelObjects: &viewArray) else { return nil }
        return viewArray?.first(where: { $0 is T }) as? T
    }
}
