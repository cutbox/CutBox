//
//  Sauce.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Foundation
import AppKit

public extension NSNotification.Name {
    static let SauceSelectedKeyboardInputSourceChanged = Notification.Name("SauceSelectedKeyboardInputSourceChanged")
    static let SauceEnabledKeyboardInputSourcesChanged = Notification.Name("SauceEnabledKeyboardInputSourcesChanged")
    static let SauceSelectedKeyboardKeyCodesChanged = Notification.Name("SauceSelectedKeyboardKeyCodesChanged")
}

public final class Sauce {

    // MARK: - Properties
    public static let shared = Sauce()

    private let layout: KeyboardLayout
    private let modifierTransformar: ModifierTransformer

    // MARK: - Initialize
    init(layout: KeyboardLayout = KeyboardLayout(), modifierTransformar: ModifierTransformer = ModifierTransformer()) {
        self.layout = layout
        self.modifierTransformar = modifierTransformar
    }

}

// MARK: - Input Sources
public extension Sauce {
    func currentInputSources() -> [InputSource] {
        return layout.inputSources
    }
}

// MARK: - KeyCodes
public extension Sauce {
    func keyCode(for key: Key) -> CGKeyCode {
        return currentKeyCode(for: key) ?? key.QWERTYKeyCode
    }

    func currentKeyCode(for key: Key) -> CGKeyCode? {
        return layout.currentKeyCode(for: key)
    }

    func currentKeyCodes() -> [Key: CGKeyCode]? {
        return layout.currentKeyCodes()
    }

    func keyCode(with source: InputSource, key: Key) -> CGKeyCode? {
        return layout.keyCode(with: source, key: key)
    }

    func keyCodes(with source: InputSource) -> [Key: CGKeyCode]? {
        return layout.keyCodes(with: source)
    }
}

// MARK: - Key
public extension Sauce {
    func key(for keyCode: Int) -> Key? {
        return currentKey(for: keyCode) ?? Key(QWERTYKeyCode: keyCode)
    }

    func currentKey(for keyCode: Int) -> Key? {
        return layout.currentKey(for: keyCode)
    }

    func key(with source: InputSource, keyCode: Int) -> Key? {
        return layout.key(with: source, keyCode: keyCode)
    }
}

// MARK: - Characters
public extension Sauce {
    func character(for keyCode: Int, carbonModifiers: Int) -> String? {
        return currentCharacter(for: keyCode, carbonModifiers: carbonModifiers) ?? currentASCIICapableCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func currentCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func currentASCIICapableCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentASCIICapableCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentASCIICapableCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentASCIICapableCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.character(with: source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }
}
