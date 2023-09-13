//
//  String+dashedSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class StringDashedSpec: QuickSpec {
    override func spec() {
        describe("String+dashed") {
            it("should return a camel case string dashed") {
                expect("ThisTestShouldDash".dashed) == "this-test-should-dash"
                expect("thisTestShouldDash".dashed) == "this-test-should-dash"
            }
            it("should return a spaced string as dashed") {
                expect("this is a Test".dashed) == "this-is-a-test"
                expect("This is A BIG test".dashed) == "this-is-a-big-test"
            }
        }
    }
}
