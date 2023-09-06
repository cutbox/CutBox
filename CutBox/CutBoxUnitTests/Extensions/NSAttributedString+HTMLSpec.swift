//
//  NSAttributedString+HTMLSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 6/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class NSAttributedString_HTMLSpec: QuickSpec {
    override func spec() {
        describe("NSAttributedString+HTML") {
            it("is a convenience init for NSAttributedString") {
                let subject = NSAttributedString(
                    html: """
                      <div style="background-color: #FF0000">Red</div>
                      """)
                if let redBackground = subject?
                    .fontAttributes(in: NSRange(0...1))[NSAttributedString.Key.backgroundColor] as? NSColor {
                    expect(redBackground.toHex) == "FF0000"
                } else {
                    fail()
                }
            }
        }
    }
}
