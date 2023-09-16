//
//  JSFuncSearchAndPreviewViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 16/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class JSFuncSearchAndPreviewViewSpec: QuickSpec {
    override func spec() {
        describe("JSFuncSearchAndPreviewView") {
            let subject = JSFuncSearchAndPreviewView()

            describe("Search text view delegate") {
                let mockSearchText = SearchTextView(frame: .zero, textContainer: .none)

                beforeEach {
                    subject.searchText = mockSearchText
                    subject.searchText.string = "TESTING"
                }

                it("notifies subscribers when text changes") {
                    var result: String = ""
                    _ = subject.filterTextPublisher.subscribe(onNext: {
                        result = $0
                    })
                    let notification = Notification(name: NSTextField.textDidChangeNotification, object: subject.searchText)
                    subject.textDidChange(notification)
                    expect(result) == subject.searchText.string
                }

                it("allows key shortcut editing methods") {
                    [
                        "deleteBackwards:",
                        "deleteForwards:",
                        "deleteWord:",
                        "deleteWordBackwards:"
                    ]
                        .map { Selector($0) }
                        .forEach {
                            expect(subject.textView(subject.searchText, doCommandBy: $0)).to(beTrue())
                        }
                }
            }
        }
    }
}
