//
//  NSObject+fromNib.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa

extension NSObject {

    class func fromNib<T>() -> T? {
        var objectArray: NSArray?
        let name = String(describing: T.self)
        let bundle = Bundle(for: Self.self)
        guard bundle.loadNibNamed(
            name,
            owner: nil,
            topLevelObjects: &objectArray) else {
                fatalError("Unable to load view from nib: \(name)")
        }

        return objectArray?.first(where: { $0 is T }) as? T
    }

    class func fromNib<T>(name: String) -> T? {
        var objectArray: NSArray?
        guard Bundle.main.loadNibNamed(
            name,
            owner: nil,
            topLevelObjects: &objectArray) else {
                fatalError("Unable to load view from nib: \(name)")
        }
        return objectArray?.first(where: { $0 is T }) as? T
    }
}
