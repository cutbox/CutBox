//
//  PreferencesAdvancedView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesAdvancedView: NSView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var historyLimitTitle: NSTextField!
    @IBOutlet weak var historyLimitTextField: NSTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: NSButton!
    @IBOutlet weak var historySizeLabel: NSTextField!

    @IBOutlet weak var joinAndWrapSectionTitle: NSTextField!
    @IBOutlet weak var joinAndWrapNote: NSTextFieldCell!
    @IBOutlet weak var joinClipsTitle: NSTextField!
    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!

    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        setupWrappingStringTextFields()
        setupJoinStringTextField()
        setupHistoryLimitControls()
        setupHistorySizeLabel()
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
