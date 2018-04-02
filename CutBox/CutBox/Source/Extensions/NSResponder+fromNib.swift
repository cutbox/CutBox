//
//  NSResponder+fromNib.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension NSResponder {
    class func fromNib<T>() -> T? {
        var windowArray: NSArray? = nil
        let name = String(describing: T.self)
        guard Bundle.main.loadNibNamed(
            NSNib.Name(rawValue: name),
            owner: nil,
            topLevelObjects: &windowArray) else {
                fatalError("Unable to load Window from nib: \(name)")
        }
        return windowArray?.first(where: { $0 is T }) as? T
    }
}
