//
//  PreferencesAdvancedView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesAdvancedView: CutBoxBaseView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var historyLimitTitle: CutBoxBaseTextField!
    @IBOutlet weak var historyLimitTextField: CutBoxBaseTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: CutBoxBaseButton!
    @IBOutlet weak var historySizeLabel: CutBoxBaseTextField!
    @IBOutlet weak var clearHistoryDropDown: CutBoxBasePopUpButton!
    @IBOutlet weak var clearHistoryActionButton: CutBoxBaseButton!

    @IBOutlet weak var joinAndWrapSectionTitle: CutBoxBaseTextField!
    @IBOutlet weak var joinAndWrapNote: CutBoxBaseTextFieldCell!
    @IBOutlet weak var joinClipsTitle: CutBoxBaseTextField!
    @IBOutlet weak var joinStyleSelector: CutBoxBaseSegmentedControl!
    @IBOutlet weak var joinStringTextField: CutBoxBaseTextField!

    @IBOutlet weak var shouldWrapMultipleSelection: CutBoxBaseButton!
    @IBOutlet weak var wrapStartTextField: CutBoxBaseTextField!
    @IBOutlet weak var wrapEndTextField: CutBoxBaseTextField!

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
        if let selector: CutBoxBaseSegmentedControl = sender as? CutBoxBaseSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isHidden = !bool
            joinStringTextField.isEnabled = bool
            prefs.useJoinString = bool
        }
    }
}
