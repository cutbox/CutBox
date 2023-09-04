//
//  CutBoxPreferences+ResetSuppressedDialogBoxes.swift
//  CutBox
//
//  Created by Jason Milkins on 24/9/22.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation
import Cocoa

extension CutBoxPreferencesService {
    func resetSuppressedDialogBoxes() {
        SuppressibleDialog.all.forEach {
            self.defaults.removeObject(forKey: $0.defaultSuppressionKey)
            self.defaults.removeObject(forKey: $0.defaultChoiceKey)
        }
    }
}
