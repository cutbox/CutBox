//
//  MockCoder.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

func mockCoder(for object: Any) -> NSCoder? {
    do {
        let data =  try NSKeyedArchiver.archivedData(
            withRootObject: object,
            requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    } catch {
        return nil
    }
}
