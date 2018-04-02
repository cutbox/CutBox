//
//  KeyCombo+Archive.swift
//  CutBox
//
//  Created by Jason on 2/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet

extension KeyCombo {
    func saveToUserDefaults(identifier: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: identifier)
    }

    static func loadFromUserDefaults(identifier: String) -> KeyCombo? {
        guard let data = UserDefaults.standard.data(forKey: identifier) else { return nil }

        if let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: data) as! KeyCombo? {
            return keyCombo
        } else {
            return nil
        }
    }
}

