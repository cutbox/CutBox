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
    private var kSuppressHistoryLimitWarning = "suppressHistoryLimitWarning"
    private var kSuppressClearHistoryWarning = "suppressClearHistoryWarning"
    private var kSuppressClearSelectedWarning = "suppressClearSelectedWarning"

    var events: PublishSubject<CutBoxPreferencesEvent>!

    var defaults: UserDefaults!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.events = PublishSubject<CutBoxPreferencesEvent>()
        self.defaults = defaults
    }

    static let shared = CutBoxPreferencesService()

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

    var suppressClearSelectedWarning: Bool {
        set {
            defaults.set(newValue, forKey: kSuppressClearSelectedWarning)
        }
        get {
            return defaults.bool(forKey: kSuppressClearSelectedWarning)
        }
    }

    var suppressClearHistoryWarning: Bool {
        set {
            defaults.set(newValue, forKey: kSuppressClearHistoryWarning)
        }
        get {
            return defaults.bool(forKey: kSuppressClearHistoryWarning)
        }
    }

    var suppressHistoryLimitWarning: Bool {
        set {
            defaults.set(newValue, forKey: kSuppressHistoryLimitWarning)
        }
        get {
            return defaults.bool(forKey: kSuppressHistoryLimitWarning)
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
