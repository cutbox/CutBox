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

    var searchViewTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 28)

    var searchViewClipItemsFont = NSFont(
        name: "Helvetica Neue",
        size: 16)

    var searchViewClipPreviewFont = NSFont(
        name: "Menlo",
        size: 14)

    var searchViewBackgroundAlpha = CGFloat(1.0)

    var searchViewBackgroundColor            = #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
    var searchViewTextFieldCursorColor       = #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
    var searchViewTextFieldTextColor         = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)
    var searchViewTextFieldBackgroundColor   = #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1)
    var searchViewPlaceholderTextColor       = #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)
    var searchViewClipItemsBackgroundColor   = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)
    var searchViewClipItemsTextColor         = #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1)
    var searchViewClipItemsHighlightColor    = #colorLiteral(red: 0.0135, green: 0.02505, blue: 0.03, alpha: 0.4979368398)
    var searchViewClipPreviewTextColor       = #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1)
    var searchViewClipPreviewBackgroundColor = #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1)
    var searchViewClipPreviewSelectedTextBackgroundColor = #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)

    func darkTheme() {
        searchViewBackgroundColor            = #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
        searchViewTextFieldCursorColor       = #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
        searchViewTextFieldTextColor         = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)
        searchViewTextFieldBackgroundColor   = #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1)
        searchViewPlaceholderTextColor       = #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)
        searchViewClipItemsBackgroundColor   = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)
        searchViewClipItemsTextColor         = #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1)
        searchViewClipItemsHighlightColor    = #colorLiteral(red: 0.09438117825, green: 0.1953456035, blue: 0.2386160714, alpha: 0.4979368398)
        searchViewClipPreviewTextColor       = #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1)
        searchViewClipPreviewBackgroundColor = #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1)
        searchViewClipPreviewSelectedTextBackgroundColor = #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
    }

    func lightTheme() {
        searchViewBackgroundColor            = #colorLiteral(red: 0.9489700198, green: 0.9490540624, blue: 0.9488998055, alpha: 1)
        searchViewTextFieldCursorColor       = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchViewTextFieldTextColor         = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchViewTextFieldBackgroundColor   = #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1)
        searchViewPlaceholderTextColor       = #colorLiteral(red: 0.624992013, green: 0.625007093, blue: 0.6249989867, alpha: 1)
        searchViewClipItemsBackgroundColor   = #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1)
        searchViewClipItemsTextColor         = #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1)
        searchViewClipItemsHighlightColor    = #colorLiteral(red: 0.09438117825, green: 0.1953456035, blue: 0.2386160714, alpha: 0.4979368398)
        searchViewClipPreviewTextColor       = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchViewClipPreviewBackgroundColor = #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1)
        searchViewClipPreviewSelectedTextBackgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

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
