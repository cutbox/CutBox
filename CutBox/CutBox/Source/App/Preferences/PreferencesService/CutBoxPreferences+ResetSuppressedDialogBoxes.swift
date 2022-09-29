//
//  CutBoxPreferences+ResetSuppressedDialogBoxes.swift
//  CutBox
//
//  Created by Jason Milkins on 24/9/22.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Foundation
import Cocoa

extension CutBoxPreferencesService {
    func resetSuppressedDialogBoxes() {
        for key in self.defaults.dictionaryRepresentation().keys
        where key.contains("CutBoxSuppressed") {
            self.defaults.removeObject(forKey: key)
        }
    }
}
