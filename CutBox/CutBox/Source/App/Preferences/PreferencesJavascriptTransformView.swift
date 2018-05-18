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
    @IBOutlet weak var javascriptReplCommandLine: NSTextField!
    @IBOutlet weak var javascriptTransformNote: NSTextView!
    @IBOutlet weak var javascriptTransformReloadButton: NSButton!

    override func awakeFromNib() {
        self.prefs = CutBoxPreferencesService.shared

        setupJavascriptTransformSection()
    }

    func setupJavascriptTransformSection() {
        self.javascriptTransformSectionTitle.stringValue = "preferences_javascript_transform_section_title".l7n

        self.javascriptTransformReloadButton.title = "preferences_javascript_transform_reload".l7n

        self.javascriptTransformReloadButton
            .rx
            .tap
            .bind {_ in self.prefs.loadJavascript() }
            .disposed(by: disposeBag)

        self.javascriptTransformNote.font = NSFont.userFixedPitchFont(ofSize: 13)
        self.javascriptTransformNote.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.javascriptReplCommandLine.font = NSFont.userFixedPitchFont(ofSize: 13)

    }

    @IBAction func exec(_ sender: AnyObject) {
        let cmd = javascriptReplCommandLine.stringValue
        javascriptReplCommandLine.stringValue = ""

        let value = JSFuncService.shared.repl(cmd)

        append("$ " + cmd)
        append("> " + value)

        javascriptTransformNote.scrollRangeToVisible(
            NSMakeRange((javascriptTransformNote
                .textStorage?
                .string
                .count)!-1, 1))
    }

    private func append(_ string: String) {
        javascriptTransformNote.string += "\n" + string
    }
}
