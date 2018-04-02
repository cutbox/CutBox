//
//  NSCoding+Archive.swift
//  CutBox
//
//  Created by Jason on 2/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension NSCoding {
    func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

extension Array where Element: NSCoding {
    func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
