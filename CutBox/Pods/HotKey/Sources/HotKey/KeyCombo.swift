//
//  CarbonKeyCombo.swift
//  HotKey
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Sam Soffes. All rights reserved.
//

import AppKit

public struct KeyCombo {

	// MARK: - Properties

	public var carbonKeyCode: UInt32
	public var carbonModifiers: UInt32

	public var key: Key? {
		get {
			return Key(carbonKeyCode: carbonKeyCode)
		}

		set {
			carbonKeyCode = newValue?.carbonKeyCode ?? 0
		}
	}

	public var modifiers: NSEvent.ModifierFlags {
		get {
			return NSEvent.ModifierFlags(carbonFlags: carbonModifiers)
		}

		set {
			carbonModifiers = modifiers.carbonFlags
		}
	}

	public var isValid: Bool {
		return carbonKeyCode >= 0
	}


	// MARK: - Initializers

	public init(carbonKeyCode: UInt32, carbonModifiers: UInt32 = 0) {
		self.carbonKeyCode = carbonKeyCode
		self.carbonModifiers = carbonModifiers
	}

	public init(key: Key, modifiers: NSEvent.ModifierFlags = []) {
		self.carbonKeyCode = key.carbonKeyCode
		self.carbonModifiers = modifiers.carbonFlags
	}


	// MARK: - Converting Keys

	public static func carbonKeyCodeToString(_ carbonKeyCode: UInt32) -> String? {
		return nil
	}
}


extension KeyCombo {
	public var dictionary: [String: Any] {
		return [
			"keyCode": Int(carbonKeyCode),
			"modifiers": Int(carbonModifiers)
		]
	}

	public init?(dictionary: [String: Any]) {
		guard let keyCode = dictionary["keyCode"] as? Int,
			let modifiers = dictionary["modifiers"] as? Int
		else {
			return nil
		}

		self.init(carbonKeyCode: UInt32(keyCode), carbonModifiers: UInt32(modifiers))
	}
}


extension KeyCombo: Equatable {
	public static func == (lhs: KeyCombo, rhs: KeyCombo) -> Bool {
		return lhs.carbonKeyCode == rhs.carbonKeyCode && lhs.carbonModifiers == rhs.carbonModifiers
	}
}
