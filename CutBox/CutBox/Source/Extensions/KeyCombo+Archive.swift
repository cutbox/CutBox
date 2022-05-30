//
//  KeyCombo+Archive.swift
//  CutBox
//
//  Created by Jason Milkins on 2/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Magnet

extension KeyCombo {

    func saveUserDefaults(identifier: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: identifier)
    }

    static func loadUserDefaults(identifier: String) -> KeyCombo? {
        guard let data = UserDefaults.standard.data(forKey: identifier) else { return nil }

        if let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: data) as? KeyCombo? {
            return keyCombo
        } else {
            return nil
        }
    }
}
