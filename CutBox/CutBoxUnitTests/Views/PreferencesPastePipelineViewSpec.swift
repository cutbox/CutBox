//
//  PreferencesPastePipelineViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 24/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class PreferencesPastePipelineViewSpec: QuickSpec {
    override func spec() {
        class MockJSFuncService: JSFuncService {
            var replLines: [String] = [String]()

            override func repl(_ line: String) -> String {
                replLines.append(line)
                return line
            }
        }

        class MockText: CutBoxBaseTextView {
            var selectedRangeWasSet: NSRange?

            override func setSelectedRange(_ charRange: NSRange) {
                selectedRangeWasSet = charRange
            }

            var testStorage = NSTextStorage(string: String())

            public override var textStorage: NSTextStorage? {
                if let storage = super.textStorage {
                    return storage
                }
                return testStorage
            }
        }

        class MockTextField: CutBoxBaseTextField {
            var current: MockText?
            override func currentEditor() -> NSText? {
                return current
            }
        }

        describe("PreferencesPastePipelineView") {
            it("can focusReplCommandLine") {
                let subject = PreferencesPastePipelineView()
                let javascriptReplCommandLine = MockTextField(frame: .zero)
                let jsMockTextEditor = MockText(frame: .zero, textContainer: nil)
                let javascriptTransformREPLOutput = MockText(frame: .zero, textContainer: nil)

                javascriptReplCommandLine.current = jsMockTextEditor
                subject.javascriptReplCommandLine = javascriptReplCommandLine
                subject.javascriptTransformREPLOutput = javascriptTransformREPLOutput

                subject.focusReplCommandLine()

                expect(jsMockTextEditor.selectedRangeWasSet).toNot(beNil())
            }

            it("calls repl with command line string") {
                let subject = PreferencesPastePipelineView()
                let javascriptReplCommandLine = MockTextField(frame: .zero)
                let javascriptTransformREPLOutput = MockText(frame: .zero, textContainer: nil)
                let jsMock: MockJSFuncService = MockJSFuncService()

                subject.javascriptReplCommandLine = javascriptReplCommandLine
                subject.javascriptTransformREPLOutput = javascriptTransformREPLOutput
                subject.js = jsMock

                javascriptReplCommandLine.stringValue = "10 + 10"
                subject.exec(NSObject())

                expect(jsMock.replLines.last) == "10 + 10"
            }
        }
    }
}
