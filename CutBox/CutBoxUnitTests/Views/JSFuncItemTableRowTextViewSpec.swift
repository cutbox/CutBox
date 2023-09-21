//
//  JSFuncItemTableRowTextViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 21/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class JSFuncItemTableRowTextViewSpec: QuickSpec {
    override func spec() {
        describe("JSFuncItemTableRowTextView") {

            let subject = JSFuncItemTableRowTextView()
            let titleText = CutBoxBaseTextField()
            beforeEach {
                subject.title = titleText
            }

            it("should throw errors when data is nil") {
                expect {
                    subject.data = nil
                }.to(throwAssertion())
            }

            it("should throw errors when data is invalid") {
                expect {
                    subject.data = ["nope": "This will not work either"]
                }.to(throwAssertion())
            }

            it("should configure itself when data is valid") {
                expect {
                    subject.data = ["string": "This is it"]
                }.toNot(throwAssertion())
                expect(subject.title.stringValue) == "This is it"
            }
        }
    }
}
