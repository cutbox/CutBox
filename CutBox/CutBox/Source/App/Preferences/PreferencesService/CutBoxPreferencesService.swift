//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason Milkins on 27/3/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa
import Magnet
import RxSwift

enum CutBoxPreferencesEvent {
    case historyLimitChanged(limit: Int)
    case compactUISettingChanged(isOn: Bool)
    case hidePreviewSettingChanged(isOn: Bool)
    case protectFavoritesChanged(isOn: Bool)
    case javascriptReload
    case themeChanged
    case themesReloaded
}

func notifyUser(title: String, info: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = info
    NSUserNotificationCenter.default
        .deliver(notification)
}

class CutBoxPreferencesService {

    private var kMultiJoinSeparator = "multiJoinSeparator"
    private var kUseJoinSeparator = "useJoinSeparator"
    private var kUseWrappingStrings = "useWrappingStrings"
    private var kWrapStringStart = "wrapStringStart"
    private var kWrapStringEnd = "wrapStringEnd"
    private var kHistoryLimited = "historyLimited"
    private var kHistoryLimit = "historyLimit"
    private var kUseCompactUI = "useCompactUI"
    private var kHidePreview = "hidePreview"
    private var kProtectFavorites = "protectFavorites"

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

    var minItemSize: CGFloat = 24.0
    var maxItemSize: CGFloat = 40.0

    var minPreviewSize: CGFloat = 12.0
    var maxPreviewSize: CGFloat = 40.0

    var searchViewTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 28)

    var searchViewClipPreviewFont = NSFont(
        name: "Menlo",
        size: 12)

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
