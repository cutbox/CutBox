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
                   "popupBackgroundColorRGBA": "#163242",
                   "searchText": {
                       "cursorColorRGBA": "#0E1C20",
                       "textColorRGBA": "#0E1B21",
                       "backgroundColorRGBA": "#ECF3F6",
                       "placeholderTextColorRGBA": "#ADC3CC"
                   },
                   "clip": {
                       "clipItemsBackgroundColorRGBA": "#0E1B21",
                       "clipItemsTextColorRGBA": "#ACC0CA",
                       "clipItemsHighlightColorRGBA": "#033E60",
                       "clipItemsHighlightTextColorRGBA": "#ACC0CA"
                   },
                   "preview": {
                       "textColorRGBA": "#ADC2CC",
                       "backgroundColorRGBA": "#060707",
                       "selectedTextBackgroundColorRGBA": "#163242"
                   },
                   "spacing": 1
               }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_skylight".l7n)",
                    "popupBackgroundColorRGBA":            "#F1F2F1",
                    "searchText": {
                        "cursorColorRGBA":                 "#000000",
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#FEFFFE",
                        "placeholderTextColorRGBA":        "#9F9F9F"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#FEFFFE",
                        "clipItemsTextColorRGBA":          "#1C1C1C",
                        "clipItemsHighlightColorRGBA":     "#79D6F9",
                        "clipItemsHighlightTextColorRGBA": "#1C1C1C"
                    },
                    "preview": {
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#FEFFFE",
                        "selectedTextBackgroundColorRGBA": "#808080"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_sandy_beach".l7n)",
                    "popupBackgroundColorRGBA":            "#D8D2AB",
                    "searchText": {
                        "cursorColorRGBA":                 "#000000",
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#E5DFB6",
                        "placeholderTextColorRGBA":        "#7E7751"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#EBE6C9",
                        "clipItemsTextColorRGBA":          "#1C1C1C",
                        "clipItemsHighlightColorRGBA":     "#99840F",
                        "clipItemsHighlightTextColorRGBA": "#1C1C1C"
                    },
                    "preview": {
                        "textColorRGBA":                   "#1C1D1C",
                        "backgroundColorRGBA":             "#EEE8CB",
                        "selectedTextBackgroundColorRGBA": "#99840F"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_darktooth".l7n)",
                    "popupBackgroundColorRGBA":            "#1C1C1C",
                    "searchText": {
                        "cursorColorRGBA":                 "#A79983",
                        "textColorRGBA":                   "#FCF4C1",
                        "backgroundColorRGBA":             "#1C1F20",
                        "placeholderTextColorRGBA":        "#3B3736"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#1C1F20",
                        "clipItemsTextColorRGBA":          "#FCF4C1",
                        "clipItemsHighlightColorRGBA":     "#7B6E63",
                        "clipItemsHighlightTextColorRGBA": "#FCF4C1"
                    },
                    "preview": {
                        "textColorRGBA":                   "#E4943C",
                        "backgroundColorRGBA":             "#141617",
                        "selectedTextBackgroundColorRGBA": "#7B6E63"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_creamsody".l7n)",
                    "popupBackgroundColorRGBA":            "#1C1C1C",
                    "searchText": {
                        "cursorColorRGBA":                 "#86D6FF",
                        "textColorRGBA":                   "#86D6FF",
                        "backgroundColorRGBA":             "#282B32",
                        "placeholderTextColorRGBA":        "#283D41"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#282B32",
                        "clipItemsTextColorRGBA":          "#86D6FF",
                        "clipItemsHighlightColorRGBA":     "#8DD0C9",
                        "clipItemsHighlightTextColorRGBA": "#86D6FF"
                    },
                    "preview": {
                        "textColorRGBA":                   "#6CAFD1",
                        "backgroundColorRGBA":             "#141617",
                        "selectedTextBackgroundColorRGBA": "#8DD0C9"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_purplehaze".l7n)",
                    "popupBackgroundColorRGBA":            "#15141C",
                    "searchText": {
                        "cursorColorRGBA":                 "#8E5AF7",
                        "textColorRGBA":                   "#E6DDF9",
                        "backgroundColorRGBA":             "#2F2D3D",
                        "placeholderTextColorRGBA":        "#565470"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#2F2D3D",
                        "clipItemsTextColorRGBA":          "#E6DDF9",
                        "clipItemsHighlightColorRGBA":     "#9D8DD0",
                        "clipItemsHighlightTextColorRGBA": "#E6DDF9"
                    },
                    "preview": {
                        "textColorRGBA":                   "#E6DDF9",
                        "backgroundColorRGBA":             "#000000",
                        "selectedTextBackgroundColorRGBA": "#9D8DD0"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_verdant".l7n)",
                    "popupBackgroundColorRGBA":            "#161C15",
                    "searchText": {
                        "cursorColorRGBA":                 "#71F75A",
                        "textColorRGBA":                   "#E1F9DD",
                        "backgroundColorRGBA":             "#20281E",
                        "placeholderTextColorRGBA":        "#587054"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#20281E",
                        "clipItemsTextColorRGBA":          "#E2F9DE",
                        "clipItemsHighlightColorRGBA":     "#97D08D",
                        "clipItemsHighlightTextColorRGBA": "#E2F9DE"
                    },
                    "preview": {
                        "textColorRGBA":                   "#E1F9DD",
                        "backgroundColorRGBA":             "#000000",
                        "selectedTextBackgroundColorRGBA": "#97D08D"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_amber_cathode".l7n)",
                    "popupBackgroundColorRGBA":            "#1C1715",
                    "searchText": {
                        "cursorColorRGBA":                 "#EF7031",
                        "textColorRGBA":                   "#F9E6DD",
                        "backgroundColorRGBA":             "#332A26",
                        "placeholderTextColorRGBA":        "#705D54"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#3D332D",
                        "clipItemsTextColorRGBA":          "#F9E7DE",
                        "clipItemsHighlightColorRGBA":     "#EC3C1A",
                        "clipItemsHighlightTextColorRGBA": "#F9E7DE"
                    },
                    "preview": {
                        "textColorRGBA":                   "#EF7031",
                        "backgroundColorRGBA":             "#000000",
                        "selectedTextBackgroundColorRGBA": "#EC3C1A"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_macos".l7n)",
                    "popupBackgroundColorRGBA":            "#EEEEEE",
                    "searchText": {
                        "cursorColorRGBA":                 "#000000",
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#F1F1F1",
                        "placeholderTextColorRGBA":        "#CBCBCB"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#FFFFFF",
                        "clipItemsTextColorRGBA":          "#000000",
                        "clipItemsHighlightColorRGBA":     "#4277F4",
                        "clipItemsHighlightTextColorRGBA": "#FFFFFF"
                    },
                    "preview": {
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#F8F8F8",
                        "selectedTextBackgroundColorRGBA": "#B2D6FF"
                    },
                    "spacing": 1
                }
              """,
              """
                {
                    "name": "\("preferences_color_theme_name_macos_graphite".l7n)",
                    "popupBackgroundColorRGBA":            "#EEEEEE",
                    "searchText": {
                        "cursorColorRGBA":                 "#000000",
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#F1F1F1",
                        "placeholderTextColorRGBA":        "#CBCBCB"
                    },
                    "clip": {
                        "clipItemsBackgroundColorRGBA":    "#FFFFFF",
                        "clipItemsTextColorRGBA":          "#000000",
                        "clipItemsHighlightColorRGBA":     "#808080",
                        "clipItemsHighlightTextColorRGBA": "#FFFFFF"
                    },
                    "preview": {
                        "textColorRGBA":                   "#000000",
                        "backgroundColorRGBA":             "#F8F8F8",
                        "selectedTextBackgroundColorRGBA": "#B2D6FF"
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
