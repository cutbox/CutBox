//
//  PreferencesJavascriptTransformView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesJavascriptTransformView: CutBoxBaseView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var javascriptTransformSectionTitle: CutBoxBaseTextField!
    @IBOutlet weak var javascriptReplCommandLine: CutBoxBaseTextField!
    @IBOutlet weak var javascriptTransformInfo: CutBoxBaseTextField!
    @IBOutlet weak var javascriptTransformREPLOutput: CutBoxBaseTextView!
    @IBOutlet weak var javascriptTransformReloadButton: CutBoxBaseButton!
    @IBOutlet weak var javascriptClearReplButton: CutBoxBaseButton!

    override func awakeFromNib() {
        self.prefs = CutBoxPreferencesService.shared

        applyJavascriptREPLTheme()
        setupJavascriptTransformSection()
    }

    func focusReplCommandLine() {
        if let replTextField = javascriptReplCommandLine {
            self.window?.makeFirstResponder(replTextField)
            if let editor = replTextField.currentEditor() as? CutBoxBaseTextView {
                let size = editor.string.count
                editor.setSelectedRange(NSRange(location: size, length: 0))
            }
        }
    }

    func applyJavascriptREPLTheme() {
        let textColor = NSColor.white
        let backgroundColor = NSColor.black
        let commandLineBackground = #colorLiteral(red: 0.03556041353, green: 0.08317251856, blue: 0.1092823802, alpha: 1)

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

        self.javascriptClearReplButton.rx.tap
            .bind { _ in self.javascriptTransformREPLOutput.string = "" }
            .disposed(by: disposeBag)

        self.javascriptTransformReloadButton.rx.tap
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

            if let textStorage = javascriptTransformREPLOutput.textStorage {
                let textCount = textStorage.string.count
                let location = max(textCount - 1, 0)
                let range = NSRange(location: location, length: 1)
                javascriptTransformREPLOutput.scrollRangeToVisible(range)
            }
        }
    }

    private func append(_ string: String) {
        javascriptTransformREPLOutput.string += "\n" + string
    }
}
