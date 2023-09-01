//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason Milkins on 27/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import Magnet
import RxSwift

@testable import CutBox

enum CutBoxPreferencesEvent {
    case historyLimitChanged(limit: Int)
    case compactUISettingChanged(isOn: Bool)
    case hidePreviewSettingChanged(isOn: Bool)
    case protectFavoritesChanged(isOn: Bool)
    case javascriptReload
    case themeChanged
    case themesReloaded
    case historyClearByOffset(offset: TimeInterval)
}

func notifyUser(title: String, info: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = info
    NSUserNotificationCenter.default
        .deliver(notification)
}

class CutBoxPreferencesService {

    private let kMultiJoinSeparator = "multiJoinSeparator"
    private let kUseJoinSeparator = "useJoinSeparator"
    private let kUseWrappingStrings = "useWrappingStrings"
    private let kWrapStringStart = "wrapStringStart"
    private let kWrapStringEnd = "wrapStringEnd"
    private let kHistoryLimited = "historyLimited"
    private let kHistoryLimit = "historyLimit"
    private let kUseCompactUI = "useCompactUI"
    private let kHidePreview = "hidePreview"
    private let kProtectFavorites = "protectFavorites"
    private let kSavedTimeFilterValue = "savedTimeFilterValue"

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
        self.themes = CutBoxThemeLoader.getBundledThemes() + CutBoxThemeLoader.getUserThemes()
    }

    func loadThemes() {
        self.themes = CutBoxThemeLoader.getBundledThemes() + CutBoxThemeLoader.getUserThemes()
        events.onNext(.themesReloaded)
    }

    static let shared = CutBoxPreferencesService()

    var themes: [CutBoxColorTheme]

    var minItemSize: CGFloat = 12
    var maxItemSize: CGFloat = 20

    var minPreviewSize: CGFloat = 12
    var maxPreviewSize: CGFloat = 20

    var searchViewTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 28)

    var searchViewClipTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 12)

    var searchViewClipPreviewFont = NSFont(
        name: "Menlo",
        size: 12)

    var savedTimeFilterValue: String {
        get {
            return defaults.string(forKey: kSavedTimeFilterValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: kSavedTimeFilterValue)
        }
    }

    var useJoinString: Bool {
        get {
            return defaults.bool(forKey: kUseJoinSeparator)
        }
        set {
            defaults.set(newValue, forKey: kUseJoinSeparator)
        }
    }

    var multiJoinString: String? {
        get {
            return useJoinString ?
                defaults.string(forKey: kMultiJoinSeparator) : nil
        }
        set {
            defaults.set(newValue, forKey: kMultiJoinSeparator)
        }
    }

    var useWrappingStrings: Bool {
        get {
            return defaults.bool(forKey: kUseWrappingStrings)
        }
        set {
            defaults.set(newValue, forKey: kUseWrappingStrings)
        }
    }

    var wrappingStrings: (String?, String?) {
        get {
            return useWrappingStrings ?
                (
                    defaults.string(forKey: kWrapStringStart),
                    defaults.string(forKey: kWrapStringEnd)
                ) : (nil, nil)
        }
        set {
            defaults.set(newValue.0, forKey: kWrapStringStart)
            defaults.set(newValue.1, forKey: kWrapStringEnd)
        }
    }

    var historyLimited: Bool {
        get {
            return defaults.bool(forKey: kHistoryLimited)
        }
        set {
            defaults.set(newValue, forKey: kHistoryLimited)
            if !newValue {
                historyLimit = 0
            }
            events.onNext(.historyLimitChanged(limit: historyLimit))
        }
    }

    var historyLimit: Int {
        get {
            return defaults.integer(forKey: kHistoryLimit)
        }
        set {
            defaults.set(newValue, forKey: kHistoryLimit)
            events.onNext(.historyLimitChanged(limit: newValue))
        }
    }

    var useCompactUI: Bool {
        get {
            return defaults.bool(forKey: kUseCompactUI)
        }
        set {
            defaults.set(newValue, forKey: kUseCompactUI)
            events.onNext(.compactUISettingChanged(isOn: newValue))
        }
    }

    var hidePreview: Bool {
        get {
            return defaults.bool(forKey: kHidePreview)
        }
        set {
            defaults.set(newValue, forKey: kHidePreview)
            events.onNext(.hidePreviewSettingChanged(isOn: newValue))
        }
    }

    var protectFavorites: Bool {
        get {
            return defaults.bool(forKey: kProtectFavorites)
        }
        set {
            defaults.set(newValue, forKey: kProtectFavorites)
            events.onNext(.protectFavoritesChanged(isOn: newValue))
        }
    }

    func loadJavascript() {
        JSFuncService.shared.reload()
    }
}
