//
//  Array+RgexpSearchFilteredSpec.swift
//  CutBoxTests
//
//  Created by Jason on 22/4/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class ArrayStringRegexpSearchFilteredSpec: QuickSpec {
    override func spec() {
        describe("Array[String]+regexpSearchFiltered") {
            let subject = [
                "Something with a double 24.1",
                "21.0",
                "33.1",
                "434"
            ]

            it("filters a string array on regexp pattern (string)") {
                expect(subject.regexpSearchFiltered(
                    search: "^[0-9]+\\.[0-9]+$",
                    options: NSRegularExpression.Options.anchorsMatchLines
                )).to(equal(["21.0", "33.1"]))
            }
        }
    }
}
