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

enum CutBoxPreferencesEvent: Equatable {
    case historyLimitChanged(limit: Int)
    case compactUISettingChanged(isOn: Bool)
    case hidePreviewSettingChanged(isOn: Bool)
    case protectFavoritesChanged(isOn: Bool)
    case javascriptReload
    case javascriptReloaded
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

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    var js: JSFuncService!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
        self.js = JSFuncService()
        self.themes = []
        js.prefs = self
        loadThemes()
    }

    func loadThemes() {
        let themeLoader = CutBoxThemeLoader()
        themeLoader.cutBoxUserThemesLocation = cutBoxUserThemesLocation
        let bundledThemes = themeLoader.getBundledThemes()
        let userThemes = themeLoader.getUserThemes()
        self.themes = bundledThemes + userThemes
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
            return defaults.string(forKey: Constants.kSavedTimeFilterValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Constants.kSavedTimeFilterValue)
        }
    }

    var useJoinString: Bool {
        get {
            return defaults.bool(forKey: Constants.kUseJoinSeparator)
        }
        set {
            defaults.set(newValue, forKey: Constants.kUseJoinSeparator)
        }
    }

    var multiJoinString: String? {
        get {
            return useJoinString ?
            defaults.string(forKey: Constants.kMultiJoinSeparator) : nil
        }
        set {
            defaults.set(newValue, forKey: Constants.kMultiJoinSeparator)
        }
    }

    var useWrappingStrings: Bool {
        get {
            return defaults.bool(forKey: Constants.kUseWrappingStrings)
        }
        set {
            defaults.set(newValue, forKey: Constants.kUseWrappingStrings)
        }
    }

    var wrappingStrings: (String?, String?) {
        get {
            return useWrappingStrings ?
                (
                    defaults.string(forKey: Constants.kWrapStringStart),
                    defaults.string(forKey: Constants.kWrapStringEnd)
                ) : (nil, nil)
        }
        set {
            defaults.set(newValue.0, forKey: Constants.kWrapStringStart)
            defaults.set(newValue.1, forKey: Constants.kWrapStringEnd)
        }
    }

    var historyLimited: Bool {
        get {
            return defaults.bool(forKey: Constants.kHistoryLimited)
        }
        set {
            defaults.set(newValue, forKey: Constants.kHistoryLimited)
            if !newValue {
                historyLimit = 0
            }
            events.onNext(.historyLimitChanged(limit: historyLimit))
        }
    }

    var historyLimit: Int {
        get {
            return defaults.integer(forKey: Constants.kHistoryLimit)
        }
        set {
            defaults.set(newValue, forKey: Constants.kHistoryLimit)
            events.onNext(.historyLimitChanged(limit: newValue))
        }
    }

    var useCompactUI: Bool {
        get {
            return defaults.bool(forKey: Constants.kUseCompactUI)
        }
        set {
            defaults.set(newValue, forKey: Constants.kUseCompactUI)
            events.onNext(.compactUISettingChanged(isOn: newValue))
        }
    }

    var hidePreview: Bool {
        get {
            return defaults.bool(forKey: Constants.kHidePreview)
        }
        set {
            defaults.set(newValue, forKey: Constants.kHidePreview)
            events.onNext(.hidePreviewSettingChanged(isOn: newValue))
        }
    }

    var protectFavorites: Bool {
        get {
            return defaults.bool(forKey: Constants.kProtectFavorites)
        }
        set {
            defaults.set(newValue, forKey: Constants.kProtectFavorites)
            events.onNext(.protectFavoritesChanged(isOn: newValue))
        }
    }

    var cutBoxUserThemesLocation: String {
        get {
            if let userThemesLocation = defaults.string(forKey: Constants.kCutBoxUserThemesLocation) {
                return userThemesLocation
            }
            let defaultLocation = "~/.config/cutbox"
            self.cutBoxUserThemesLocation = defaultLocation
            return defaultLocation
        }

        set {
            defaults.set(newValue, forKey: Constants.kCutBoxUserThemesLocation)
        }
    }

    var cutBoxJSLocation: String {
        get {
            if let jsLocation = defaults.string(forKey: Constants.kCutBoxJSLocation) {
                return jsLocation
            }
            let defaultLocation = "~/.cutbox.js"
            self.cutBoxJSLocation = defaultLocation
            return defaultLocation
        }

        set {
            defaults.set(newValue, forKey: Constants.kCutBoxJSLocation)
        }
    }

    func loadJavascript() {
        js.reload()
        events.onNext(.javascriptReloaded)
    }
}
