//
//  UserDefaultsMock.swift
//  CutBoxTests
//
//  Created by Jason on 20/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

class UserDefaultsMock: UserDefaults {

    var store = [String: Any?]()

    override func set(_ value: Bool, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func array(forKey defaultName: String) -> [Any]? {
        return store[defaultName] as? [Any]
    }

    override func bool(forKey defaultName: String) -> Bool {
        return store[defaultName] as? Bool ?? false
    }

    override func string(forKey defaultName: String) -> String? {
        return store[defaultName] as? String
    }

}
