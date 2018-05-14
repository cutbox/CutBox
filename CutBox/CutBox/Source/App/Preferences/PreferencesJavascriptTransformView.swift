//
//  PreferencesJavascriptTransformView.swift
//  CutBox
//
//  Created by Jason on 13/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
            else { return nil }

        self.init(attributedString: attributedString)
    }
}

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
