//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason Milkins on 27/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

// swiftlint:disable type_body_length

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

    // swiftlint:disable colon
    // tailor:off
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.01234312356, green: 0.2465254962, blue: 0.3791370988, alpha: 1),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.6, green: 0.519, blue: 0.06, alpha: 0.4979368398),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.1137171462, green: 0.1137312576, blue: 0.1137053147, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9367052095, green: 0.9132560753, blue: 0.797995402, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6, green: 0.519, blue: 0.06, alpha: 0.4979368398)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.4862745098, green: 0.4352941176, blue: 0.3921568627, alpha: 0.5),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.7568627451, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.8968908629, green: 0.5822916728, blue: 0.2378814167, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.08146389996, green: 0.08945310152, blue: 0.09299647553, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.4862745098, green: 0.4352941176, blue: 0.3921568627, alpha: 0.5)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.426756896, green: 0.6883502309, blue: 0.8219384518, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.08146389996, green: 0.08945310152, blue: 0.09299647553, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.6185805235, green: 0.5529411765, blue: 0.8196078431, alpha: 0.1513259243),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.9055583133, green: 0.8686919488, blue: 0.98, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.9055583133, green: 0.8686919488, blue: 0.98, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6185805235, green: 0.5529411765, blue: 0.8196078431, alpha: 0.1513259243)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.5929411765, green: 0.8196078431, blue: 0.5529411765, alpha: 0.1513259243),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.88837, green: 0.98, blue: 0.8722, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.8853881565, green: 0.98, blue: 0.8686919488, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.5929411765, green: 0.8196078431, blue: 0.5529411765, alpha: 0.1513259243)
        ),
        spacing: 1
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
            clipItemsHighlightColor:     #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            clipItemsHighlightTextColor: #colorLiteral(red: 0.98, green: 0.9081333333, blue: 0.8722, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0.9372549057, green: 0.4405228794, blue: 0.1921568662, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.3016106592)
        ),
        spacing: 1
    )

    var macOSTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_macos".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.937030488, green: 0.937030488, blue: 0.937030488, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9468789657, green: 0.9468789657, blue: 0.9468789657, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.7998691307, green: 0.7998691307, blue: 0.7998691307, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1),
            clipItemsHighlightTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9741037437, green: 0.9741037437, blue: 0.9741037437, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        ),
        spacing: 1
    )

    var macOSGraphiteTheme: CutBoxColorTheme = CutBoxColorTheme(
        name: "preferences_color_theme_name_macos_graphite".l7n,
        popupBackgroundColor:            #colorLiteral(red: 0.937030488, green: 0.937030488, blue: 0.937030488, alpha: 1),
        searchText: (
            cursorColor:                 #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9468789657, green: 0.9468789657, blue: 0.9468789657, alpha: 1),
            placeholderTextColor:        #colorLiteral(red: 0.7998691307, green: 0.7998691307, blue: 0.7998691307, alpha: 1)
        ),
        clip: (
            clipItemsBackgroundColor:    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            clipItemsTextColor:          #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            clipItemsHighlightColor:     #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            clipItemsHighlightTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ),
        preview: (
            textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            backgroundColor:             #colorLiteral(red: 0.9741037437, green: 0.9741037437, blue: 0.9741037437, alpha: 1),
            selectedTextBackgroundColor: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        ),
        spacing: 1
    )
    // swiftlint:enable colon
    // tailor:on

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
