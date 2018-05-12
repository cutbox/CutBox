//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet
import RxSwift

enum CutBoxPreferencesEvent {
    case historyLimitChanged(limit: Int)
    case compactUISettingChanged(isOn: Bool)
    case protectFavoritesChanged(isOn: Bool)
    case javascriptEnabledChanged(isOn: Bool)
    case javascriptChanged
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
    private var kProtectFavorites = "protectFavorites"

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
    }

    static let shared = CutBoxPreferencesService()

    var darkTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_darkness".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1),
            textColor:                   #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.0135, green: 0.02505, blue: 0.03, alpha: 0.4979368398)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
        )
    )

    var lightTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_skylight".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.9489700198, green: 0.9490540624, blue: 0.9488998055, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.624992013, green: 0.625007093, blue: 0.6249989867, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.09438117825, green: 0.1953456035, blue: 0.2386160714, alpha: 0.4979368398)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        )
    )


    var sandyBeachTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_sandy_beach".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.85, green: 0.823628418, blue: 0.6741894531, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.901735723, green: 0.8747611046, blue: 0.7138736844, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.4943917411, green: 0.4682189127, blue: 0.3199062184, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.9245729634, green: 0.9039393231, blue: 0.7889568901, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.6, green: 0.519, blue: 0.06, alpha: 0.4979368398)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.1137171462, green: 0.1137312576, blue: 0.1137053147, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9367052095, green: 0.9132560753, blue: 0.797995402, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6, green: 0.519, blue: 0.06, alpha: 0.4979368398)
        )
    )

    var darktoothTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_darktooth".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.5176470588, alpha: 1),
            textColor:                   #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.7568627451, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.1136818007, green: 0.1254841089, blue: 0.1293821037, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.2352941176, green: 0.2196078431, blue: 0.2117647059, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.1136818007, green: 0.1254841089, blue: 0.1293821037, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.7568627451, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.4862745098, green: 0.4352941176, blue: 0.3921568627, alpha: 0.5)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.7568627451, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.1136818007, green: 0.1254841089, blue: 0.1293821037, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.4862745098, green: 0.4352941176, blue: 0.3921568627, alpha: 0.5)
        )
    )

    var creamSodyTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_creamsody".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
            textColor:                   #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.1591003184, green: 0.2392678358, blue: 0.2553013393, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243)
        )
    )

    var purpleHaze: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_purplehaze".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.08464309139, green: 0.08192104101, blue: 0.1098039216, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
            textColor:                   #colorLiteral(red: 0.9055583133, green: 0.8686919488, blue: 0.98, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.1859181625, green: 0.1799391913, blue: 0.2411838108, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.3405955495, green: 0.3296422841, blue: 0.4418402778, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.1859181625, green: 0.1799391913, blue: 0.2411838108, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.9055583133, green: 0.8686919488, blue: 0.98, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.6185805235, green: 0.5529411765, blue: 0.8196078431, alpha: 0.1513259243)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.9055583133, green: 0.8686919488, blue: 0.98, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6185805235, green: 0.5529411765, blue: 0.8196078431, alpha: 0.1513259243)
        )
    )

    var verdantTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_verdant".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.08647058826, green: 0.1098039216, blue: 0.0823529412, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.445925108, green: 0.97, blue: 0.3534413036, alpha: 1),
            textColor:                   #colorLiteral(red: 0.8853881565, green: 0.98, blue: 0.8686919488, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.126, green: 0.16, blue: 0.12, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.3479492188, green: 0.4418402778, blue: 0.3313802084, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.126, green: 0.16, blue: 0.12, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.88837, green: 0.98, blue: 0.8722, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.5929411765, green: 0.8196078431, blue: 0.5529411765, alpha: 0.1513259243)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.8853881565, green: 0.98, blue: 0.8686919488, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.5929411765, green: 0.8196078431, blue: 0.5529411765, alpha: 0.1513259243)
        )
    )

    var amberCathodeTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_amber_cathode".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.1098039216, green: 0.091503268, blue: 0.0823529412, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0.9372549057, green: 0.4405228794, blue: 0.1921568662, alpha: 1),
            textColor:                   #colorLiteral(red: 0.98, green: 0.9057946325, blue: 0.8686919488, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.2, green: 0.1661422165, blue: 0.1492133246, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.4418402778, green: 0.3682002315, blue: 0.3313802084, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 0.2411838108, green: 0.2003540645, blue: 0.1799391913, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0.98, green: 0.9081333333, blue: 0.8722, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.9254902005, green: 0.2392156882, blue: 0.1019607857, alpha: 0.3)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.9372549057, green: 0.4405228794, blue: 0.1921568662, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.3016106592)
        )
    )

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


    var useJoinString: Bool {
        set {
            defaults.set(newValue, forKey: kUseJoinSeparator)
        }
        get {
            return defaults.bool(forKey: kUseJoinSeparator)
        }
    }

    var multiJoinString: String? {
        set {
            defaults.set(newValue, forKey: kMultiJoinSeparator)
        }
        get {
            return useJoinString ?
                defaults.string(forKey: kMultiJoinSeparator) : nil
        }
    }

    var useWrappingStrings: Bool {
        set {
            defaults.set(newValue, forKey: kUseWrappingStrings)
        }
        get {
            return defaults.bool(forKey: kUseWrappingStrings)
        }
    }

    var wrappingStrings: (String?, String?) {
        set {
            defaults.set(newValue.0, forKey: kWrapStringStart)
            defaults.set(newValue.1, forKey: kWrapStringEnd)
        }
        get {
            return useWrappingStrings ?
                (
                    defaults.string(forKey: kWrapStringStart),
                    defaults.string(forKey: kWrapStringEnd)
                ) : (nil, nil)
        }
    }

    var historyLimited: Bool {
        set {
            defaults.set(newValue, forKey: kHistoryLimited)
            if !newValue {
                historyLimit = 0
            }
            events.onNext(.historyLimitChanged(limit: historyLimit))
        }
        get {
            return defaults.bool(forKey: kHistoryLimited)
        }
    }

    var historyLimit: Int {
        set {
            defaults.set(newValue, forKey: kHistoryLimit)
            events.onNext(.historyLimitChanged(limit: newValue))
        }
        get {
            return defaults.integer(forKey: kHistoryLimit)
        }
    }

    var useCompactUI: Bool {
        set {
            defaults.set(newValue, forKey: kUseCompactUI)
            events.onNext(.compactUISettingChanged(isOn: newValue))
        }
        get {
            return defaults.bool(forKey: kUseCompactUI)
        }
    }

    var protectFavorites: Bool {
        set {
            defaults.set(newValue, forKey: kProtectFavorites)
            events.onNext(.protectFavoritesChanged(isOn: newValue))
        }
        get {
            return defaults.bool(forKey: kProtectFavorites)
        }
    }

    var kJavascriptEnabled = "javascriptEnabled"

    var javascriptEnabled: Bool {
        set {
            defaults.set(newValue, forKey: kJavascriptEnabled)
            events.onNext(.javascriptEnabledChanged(isOn: newValue))
        }
        get {
            return defaults.bool(forKey: kJavascriptEnabled)
        }
    }


    var kJavascript = "javascript"

    var javascript: String? {
        set {
            defaults.set(newValue, forKey: kJavascript)
            events.onNext(.javascriptChanged)
        }
        get {
            return defaults.string(forKey: kJavascript)
        }
    }
}


