//
//  UserDefaultsMock.swift
//  CutBoxTests
//
//  Created by Jason on 20/5/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    /// fake backing store
    var store: [String: Any] = [:]

    func insertHistoryStoreItem(_ string: String) {
        var history = array(forKey: Constants.kHistoryStoreKey)
        as? [[String: String]] ??
        [[String: String]]()
        history.insert([Constants.kStringKey: string], at: 0)
        set(history, forKey: Constants.kHistoryStoreKey)
    }

    override func set(_ value: Bool, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func set(_ value: Int, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func set(_ value: Float, forKey defaultName: String) {
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

    override func integer(forKey defaultName: String) -> Int {
        return store[defaultName] as? Int ?? 0
    }

    override func float(forKey defaultName: String) -> Float {
        return store[defaultName] as? Float ?? 0.0
    }

    override func removeObject(forKey defaultName: String) {
        store[defaultName] = nil
    }
}
