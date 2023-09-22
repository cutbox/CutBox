//
//  ClipItemTableRowTextViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 22/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ClipItemTableRowTextViewSpec: QuickSpec {
    override func spec() {
        describe("ClipItemTableRowTextView") {
            let subject = ClipItemTableRowTextView()

            it("should throw an assertion when nil data is set") {
                expect { subject.data = nil }
                    .to(throwAssertion())
            }

            it("should throw an assertion when invalid data is set") {
                expect { subject.data = ["foobar": "Foobar"] }
                    .to(throwAssertion())
            }

            it("should setup when the correct data is applied") {
                let title = CutBoxBaseTextField()
                subject.title = title
                subject.data = ["string": "Hello"]
                expect(subject.title.stringValue) == "Hello"
            }
        }
    }
}
