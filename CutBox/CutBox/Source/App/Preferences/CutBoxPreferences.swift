//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet

class CutBoxPreferences {

    static let shared = CutBoxPreferences()

    var currentTheme: CutBoxColorTheme { return themes[theme] }

    var searchViewTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 28)

    var searchViewClipItemsFont = NSFont(
        name: "Helvetica Neue",
        size: 16)

    var searchViewClipPreviewFont = NSFont(
        name: "Menlo",
        size: 14)

    private var kMultiJoinSeparator = "multiJoinSeparator"
    private var kUseJoinSeparator = "useJoinSeparator"

    var useJoinString: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kUseJoinSeparator)
        }
        get {
            return UserDefaults.standard.bool(forKey: kUseJoinSeparator)
        }
    }

    var multiJoinString: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kMultiJoinSeparator)
        }
        get {
            return useJoinString ?
                UserDefaults.standard.string(forKey: kMultiJoinSeparator) : nil
        }
    }

    private var kUseWrappingStrings = "useWrappingStrings"
    private var kWrapStringStart = "wrapStringStart"
    private var kWrapStringEnd = "wrapStringEnd"

    var useWrappingStrings: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kUseWrappingStrings)
        }
        get {
            return UserDefaults.standard.bool(forKey: kUseWrappingStrings)
        }
    }

    var wrappingStrings: (String?, String?) {
        set {
            UserDefaults.standard.set(newValue.0, forKey: kWrapStringStart)
            UserDefaults.standard.set(newValue.1, forKey: kWrapStringEnd)
        }
        get {
            return useWrappingStrings ?
                (
                    UserDefaults.standard.string(forKey: kWrapStringStart),
                    UserDefaults.standard.string(forKey: kWrapStringEnd)
                ) : (nil, nil)
        }
    }
}
