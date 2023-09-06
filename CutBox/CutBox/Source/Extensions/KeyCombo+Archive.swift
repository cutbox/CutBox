//
//  KeyCombo+Archive.swift
//  CutBox
//
//  Created by Jason Milkins on 2/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Magnet

extension KeyCombo {

    func saveUserDefaults(identifier: String, defaults: UserDefaults = .standard) {
        let data = NSKeyedArchiver
            .archivedData(withRootObject: self)
        defaults.set(data, forKey: identifier)
    }

    static func loadUserDefaults(identifier: String, defaults: UserDefaults = .standard) -> KeyCombo? {
        guard let data = defaults.data(forKey: identifier) else { return nil }

        if let keyCombo = NSKeyedUnarchiver
            .unarchiveObject(with: data) as? KeyCombo? {
            return keyCombo
        } else {
            return nil
        }
    }
}
