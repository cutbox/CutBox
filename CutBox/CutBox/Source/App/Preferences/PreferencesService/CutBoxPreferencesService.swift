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
}

class CutBoxPreferencesService {

    private var kMultiJoinSeparator = "multiJoinSeparator"
    private var kUseJoinSeparator = "useJoinSeparator"
    private var kUseWrappingStrings = "useWrappingStrings"
    private var kWrapStringStart = "wrapStringStart"
    private var kWrapStringEnd = "wrapStringEnd"
    private var kHistoryLimited = "historyLimited"
    private var kHistoryLimit = "historyLimit"

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
    }

    static let shared = CutBoxPreferencesService()

    var darkTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_dark".l7n,
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
        name: "preferences_color_theme_name_light".l7n,
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
}
