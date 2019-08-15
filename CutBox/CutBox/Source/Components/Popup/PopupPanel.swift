//
//  PopupPanel.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

public class PopupPanel: NSPanel {}

extension PopupPanel {

    public override var canBecomeKey: Bool {
        return true
    }

}

extension PopupPanel {

    public override func cancelOperation(_ sender: Any?) {
        resignKey()
    }

}
