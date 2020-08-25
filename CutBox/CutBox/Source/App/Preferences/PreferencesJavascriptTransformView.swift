//
//  PreferencesJavascriptTransformView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesJavascriptTransformView: NSView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var javascriptTransformSectionTitle: NSTextField!
    @IBOutlet weak var javascriptReplCommandLine: NSTextField!
    @IBOutlet weak var javascriptTransformInfo: NSTextField!
    @IBOutlet var javascriptTransformREPLOutput: NSTextView!
    @IBOutlet weak var javascriptTransformReloadButton: NSButton!
    @IBOutlet weak var javascriptClearReplButton: NSButton!

    override func awakeFromNib() {
        self.prefs = CutBoxPreferencesService.shared

        applyJavascriptREPLTheme()
        setupJavascriptTransformSection()
    }

    func applyJavascriptREPLTheme() {
        let textColor = NSColor.black
        let backgroundColor = NSColor.white
        let commandLineBackground = #colorLiteral(red: 0.8720445421, green: 0.9284945442, blue: 0.95, alpha: 1)

        self.javascriptTransformREPLOutput.font = NSFont.userFixedPitchFont(ofSize: 13)
        self.javascriptTransformREPLOutput.textColor = textColor
        self.javascriptTransformREPLOutput.backgroundColor = backgroundColor

        self.javascriptReplCommandLine.font = NSFont.userFixedPitchFont(ofSize: 13)
        self.javascriptReplCommandLine.textColor = textColor
        self.javascriptReplCommandLine.backgroundColor = commandLineBackground
    }

    func setupJavascriptTransformSection() {
        self.javascriptTransformSectionTitle
            .stringValue = "preferences_javascript_transform_section_title".l7n

        self.javascriptTransformInfo
            .stringValue = "preferences_javascript_transform_section_note".l7n

        self.javascriptTransformREPLOutput
            .string = "preferences_javascript_repl_help".l7n

        self.javascriptTransformReloadButton
            .title = "preferences_javascript_transform_reload".l7n

        self.javascriptClearReplButton
            .title = "preferences_javascript_clear_button".l7n

        self.javascriptClearReplButton
            .rx
            .tap
            .bind { _ in self.javascriptTransformREPLOutput.string = "" }
            .disposed(by: disposeBag)

        self.javascriptTransformReloadButton
            .rx
            .tap
            .bind { _ in self.prefs.loadJavascript() }
            .disposed(by: disposeBag)
    }

    @IBAction func exec(_ sender: AnyObject) {
        let cmd = javascriptReplCommandLine.stringValue
        javascriptReplCommandLine.stringValue = ""

        if !cmd.isEmpty {
            let value = JSFuncService.shared.repl(cmd)

            append("> " + cmd)
            append(value)

            javascriptTransformREPLOutput.scrollRangeToVisible(
                NSRange(location: (javascriptTransformREPLOutput
                    .textStorage?
                    .string
                    .count)!-1, length: 1))
        }
    }

    private func append(_ string: String) {
        javascriptTransformREPLOutput.string += "\n" + string
    }

}
