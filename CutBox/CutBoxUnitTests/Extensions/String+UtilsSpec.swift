//
//  String+UtilsSpec.swift
//  CutBoxTests
//
//  Created by denis.st on 29/4/19.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble
import Foundation

class StringUtilsSpec: QuickSpec {
    override func spec() {
        describe("String+Utils") {
            it("Truncate with limit == 0") {
                let source   = "123456789.123456789.123"
                let expected = ""
                let actual = source.truncate(limit: 0)
                expect(expected).to(equal(actual))
            }
            it("Truncate a long string with ellipsis") {
                let source   = "123456789.123456789.123"
                let expected = "123456789.12345…"
                let actual = source.truncate(limit: 16)
                expect(expected).to(equal(actual))
            }
            it("Don't truncate a string if it's short enough") {
                let source   = "123456789.123456789.123"
                let expected = source
                let actual = source.truncate(limit: 100)
                expect(expected).to(equal(actual))
            }
            it("Don't truncate a string with a length equal to a limit") {
                let source   = "123456789.123456789.123"
                let expected = source
                let actual = source.truncate(limit: source.count)
                expect(expected).to(equal(actual))
            }
            it("Don't truncate on a boundary case") {
                let source   = "123456789.123456789.123"
                let expected = source
                let actual = source.truncate(limit: source.count+1)
                expect(expected).to(equal(actual))
            }
        }
    }
}
