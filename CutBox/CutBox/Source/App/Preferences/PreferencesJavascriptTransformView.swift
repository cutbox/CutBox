//
//  PreferencesJavascriptTransformView.swift
//  CutBox
//
//  Created by Jason on 13/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesJavascriptTransformView: NSView {
    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var javascriptTransformSectionTitle: NSTextField!
    @IBOutlet weak var javascriptTransformNote: NSTextView!
    @IBOutlet weak var javascriptTransformReloadButton: NSButton!

    override func awakeFromNib() {
        self.prefs = CutBoxPreferencesService.shared

        setupJavascriptTransformSection()
    }

    func setupJavascriptTransformSection() {
        self.javascriptTransformSectionTitle.stringValue = "preferences_javascript_transform_section_title".l7n
        self.javascriptTransformNote.textStorage?.setAttributedString(NSAttributedString(html:         "preferences_javascript_transform_section_note".l7n)!)
        self.javascriptTransformReloadButton.title = "preferences_javascript_transform_reload".l7n

        self.javascriptTransformReloadButton
            .rx
            .tap
            .bind {_ in self.prefs.loadJavascript() }
            .disposed(by: disposeBag)
    }
}
