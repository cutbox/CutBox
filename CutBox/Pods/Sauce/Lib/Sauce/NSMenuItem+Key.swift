//
//  Sauce.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import AppKit

extension NSMenuItem {
    /// A `Key` instance that corresponds to the menu item's shortcut.
    public var key: Key? {
        // Prefer the shortcut overrides by the user (from "System Preferences" > "Keyboard")
        // to the developer's default.
        let keyEquivalent = !self.userKeyEquivalent.isEmpty
            ? self.userKeyEquivalent
            : self.keyEquivalent
        return Key(character: keyEquivalent, virtualKeyCode: nil)
    }
}
