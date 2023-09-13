//
//  CutBoxNSAppProvider.swift
//  CutBox
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Cocoa

class CutBoxNSAppProvider {
    static var testing: Bool = false
    var terminateWasCalled = false

    func terminate(_ sender: CutBoxBaseMenuItem) {
        if Self.testing {
            terminateWasCalled = true
        } else {
            NSApp.terminate(sender)
        }
    }
}
