//
//  PopupControllerWindowDelegate.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

extension PopupController: NSWindowDelegate {

    func windowWillClose(_ notification: Notification) {
        closePopup()
    }

    func windowDidResignKey(_ notification: Notification) {
        if window?.isVisible == true && !isOpening {
            closePopup()
        }
    }

}
