//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason Milkins on 27/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa
import Magnet
import RxSwift

enum CutBoxPreferencesEvent {
    case historyLimitChanged(limit: Int)
    case compactUISettingChanged(isOn: Bool)
    case protectFavoritesChanged(isOn: Bool)
    case javascriptReload
    case themeChanged
}

// swiftlint:disable type_body_length
class CutBoxPreferencesService {

    private var kMultiJoinSeparator = "multiJoinSeparator"
    private var kUseJoinSeparator = "useJoinSeparator"
    private var kUseWrappingStrings = "useWrappingStrings"
    private var kWrapStringStart = "wrapStringStart"
    private var kWrapStringEnd = "wrapStringEnd"
    private var kHistoryLimited = "historyLimited"
    private var kHistoryLimit = "historyLimit"
    private var kUseCompactUI = "useCompactUI"
    private var kProtectFavorites = "protectFavorites"

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
        self.themes = [
              """
               {
                   "name": "\("preferences_color_theme_name_darkness".l7n)",
                   "popupBackgroundColor": "#163242",
                   "searchText": {
                       "cursorColor": "#0E1C20",
                       "textColor": "#0E1B21",
                       "backgroundColor": "#ECF3F6",
                       "placeholderTextColor": "#ADC3CC"
                   },
                   "clip": {
                       "clipItemsBackgroundColor": "#0E1B21",
                       "clipItemsTextColor": "#ACC0CA",
                       "clipItemsHighlightColor": "#033E60",
                       "clipItemsHighlightTextColor": "#ACC0CA"
                   },
                   "preview": {
                       "textColor": "#ADC2CC",
                       "backgroundColor": "#060707",
                       "selectedTextBackgroundColor": "#163242"
                   },
                   "spacing": 1
               }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_skylight".l7n)",
                    "popupBackgroundColor":            "#F1F2F1",
                    "searchText": {
                        "cursorColor":                 "#000000",
                        "textColor":                   "#000000",
                        "backgroundColor":             "#FEFFFE",
                        "placeholderTextColor":        "#9F9F9F"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#FEFFFE",
                        "clipItemsTextColor":          "#1C1C1C",
                        "clipItemsHighlightColor":     "#79D6F9",
                        "clipItemsHighlightTextColor": "#1C1C1C"
                    },
                    "preview": {
                        "textColor":                   "#000000",
                        "backgroundColor":             "#FEFFFE",
                        "selectedTextBackgroundColor": "#808080"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_sandy_beach".l7n)",
                    "popupBackgroundColor":            "#D8D2AB",
                    "searchText": {
                        "cursorColor":                 "#000000",
                        "textColor":                   "#000000",
                        "backgroundColor":             "#E5DFB6",
                        "placeholderTextColor":        "#7E7751"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#EBE6C9",
                        "clipItemsTextColor":          "#1C1C1C",
                        "clipItemsHighlightColor":     "#99840F",
                        "clipItemsHighlightTextColor": "#1C1C1C"
                    },
                    "preview": {
                        "textColor":                   "#1C1D1C",
                        "backgroundColor":             "#EEE8CB",
                        "selectedTextBackgroundColor": "#99840F"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_darktooth".l7n)",
                    "popupBackgroundColor":            "#1C1C1C",
                    "searchText": {
                        "cursorColor":                 "#A79983",
                        "textColor":                   "#FCF4C1",
                        "backgroundColor":             "#1C1F20",
                        "placeholderTextColor":        "#3B3736"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#1C1F20",
                        "clipItemsTextColor":          "#FCF4C1",
                        "clipItemsHighlightColor":     "#7B6E63",
                        "clipItemsHighlightTextColor": "#FCF4C1"
                    },
                    "preview": {
                        "textColor":                   "#E4943C",
                        "backgroundColor":             "#141617",
                        "selectedTextBackgroundColor": "#7B6E63"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_creamsody".l7n)",
                    "popupBackgroundColor":            "#1C1C1C",
                    "searchText": {
                        "cursorColor":                 "#86D6FF",
                        "textColor":                   "#86D6FF",
                        "backgroundColor":             "#282B32",
                        "placeholderTextColor":        "#283D41"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#282B32",
                        "clipItemsTextColor":          "#86D6FF",
                        "clipItemsHighlightColor":     "#8DD0C9",
                        "clipItemsHighlightTextColor": "#86D6FF"
                    },
                    "preview": {
                        "textColor":                   "#6CAFD1",
                        "backgroundColor":             "#141617",
                        "selectedTextBackgroundColor": "#8DD0C9"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_purplehaze".l7n)",
                    "popupBackgroundColor":            "#15141C",
                    "searchText": {
                        "cursorColor":                 "#8E5AF7",
                        "textColor":                   "#E6DDF9",
                        "backgroundColor":             "#2F2D3D",
                        "placeholderTextColor":        "#565470"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#2F2D3D",
                        "clipItemsTextColor":          "#E6DDF9",
                        "clipItemsHighlightColor":     "#9D8DD0",
                        "clipItemsHighlightTextColor": "#E6DDF9"
                    },
                    "preview": {
                        "textColor":                   "#E6DDF9",
                        "backgroundColor":             "#000000",
                        "selectedTextBackgroundColor": "#9D8DD0"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_verdant".l7n)",
                    "popupBackgroundColor":            "#161C15",
                    "searchText": {
                        "cursorColor":                 "#71F75A",
                        "textColor":                   "#E1F9DD",
                        "backgroundColor":             "#20281E",
                        "placeholderTextColor":        "#587054"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#20281E",
                        "clipItemsTextColor":          "#E2F9DE",
                        "clipItemsHighlightColor":     "#97D08D",
                        "clipItemsHighlightTextColor": "#E2F9DE"
                    },
                    "preview": {
                        "textColor":                   "#E1F9DD",
                        "backgroundColor":             "#000000",
                        "selectedTextBackgroundColor": "#97D08D"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_amber_cathode".l7n)",
                    "popupBackgroundColor":            "#1C1715",
                    "searchText": {
                        "cursorColor":                 "#EF7031",
                        "textColor":                   "#F9E6DD",
                        "backgroundColor":             "#332A26",
                        "placeholderTextColor":        "#705D54"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#3D332D",
                        "clipItemsTextColor":          "#F9E7DE",
                        "clipItemsHighlightColor":     "#EC3C1A",
                        "clipItemsHighlightTextColor": "#F9E7DE"
                    },
                    "preview": {
                        "textColor":                   "#EF7031",
                        "backgroundColor":             "#000000",
                        "selectedTextBackgroundColor": "#EC3C1A"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_macos".l7n)",
                    "popupBackgroundColor":            "#EEEEEE",
                    "searchText": {
                        "cursorColor":                 "#000000",
                        "textColor":                   "#000000",
                        "backgroundColor":             "#F1F1F1",
                        "placeholderTextColor":        "#CBCBCB"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#FFFFFF",
                        "clipItemsTextColor":          "#000000",
                        "clipItemsHighlightColor":     "#4277F4",
                        "clipItemsHighlightTextColor": "#FFFFFF"
                    },
                    "preview": {
                        "textColor":                   "#000000",
                        "backgroundColor":             "#F8F8F8",
                        "selectedTextBackgroundColor": "#B2D6FF"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_macos_graphite".l7n)",
                    "popupBackgroundColor":            "#EEEEEE",
                    "searchText": {
                        "cursorColor":                 "#000000",
                        "textColor":                   "#000000",
                        "backgroundColor":             "#F1F1F1",
                        "placeholderTextColor":        "#CBCBCB"
                    },
                    "clip": {
                        "clipItemsBackgroundColor":    "#FFFFFF",
                        "clipItemsTextColor":          "#000000",
                        "clipItemsHighlightColor":     "#808080",
                        "clipItemsHighlightTextColor": "#FFFFFF"
                    },
                    "preview": {
                        "textColor":                   "#000000",
                        "backgroundColor":             "#F8F8F8",
                        "selectedTextBackgroundColor": "#B2D6FF"
                    },
                    "spacing": 1
                }
              """
        ].map { CutBoxColorTheme($0) }
    }

    static let shared = CutBoxPreferencesService()

    var themes: [CutBoxColorTheme]

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

func notifyUser(title: String, info: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = info
    NSUserNotificationCenter.default
        .deliver(notification)
}
