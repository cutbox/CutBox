//
//  PreferencesAdvancedView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

enum SuppressibleDialog: String, Equatable, CaseIterable {
    case clearHistoryActionClicked
    case destructiveLimitChangeWarning
    case clearHistoryWarning

    var defaultKey: String{
        return "\(self)_CutBoxSuppressed"
    }

    var defaultChoiceKey: String {
        return "\(defaultKey)Choice"
    }

    static var all: [SuppressibleDialog] {
        return Self.allCases
    }
}

class PreferencesAdvancedView: NSView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var historyLimitTitle: NSTextField!
    @IBOutlet weak var historyLimitTextField: NSTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: NSButton!
    @IBOutlet weak var historySizeLabel: NSTextField!
    @IBOutlet weak var clearHistoryDropDown: NSPopUpButton!
    @IBOutlet weak var clearHistoryActionButton: NSButton!

    @IBOutlet weak var joinAndWrapSectionTitle: NSTextField!
    @IBOutlet weak var joinAndWrapNote: NSTextFieldCell!
    @IBOutlet weak var joinClipsTitle: NSTextField!
    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!

    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!

    let clearHistoryOptions: [(title: String, offset: TimeInterval?)] = [
      (title: "preferences_history_select_option".l7n, offset: nil),
      (title: "preferences_history_clear_last_5_minutes".l7n, offset: 300),
      (title: "preferences_history_clear_last_hour".l7n, offset: 3600),
      (title: "preferences_history_clear_last_24_hours".l7n, offset: 86400),
      (title: "preferences_history_clear_older_than_7_days".l7n, offset: -604800),
      (title: "preferences_history_clear_older_than_30_days".l7n, offset: -2592000),
      (title: "preferences_history_clear_entire_history".l7n, offset: 0)
    ]

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        setupWrappingStringTextFields()
        setupJoinStringTextField()
        setupHistoryLimitControls()
        setupHistorySizeLabel()
        setupClearHistoryControls()
    }

    @IBAction func joinStyleSelectorAction(_ sender: Any) {
        if let selector: NSSegmentedControl = sender as? NSSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isHidden = !bool
            joinStringTextField.isEnabled = bool
            prefs.useJoinString = bool
        }
    }
}
