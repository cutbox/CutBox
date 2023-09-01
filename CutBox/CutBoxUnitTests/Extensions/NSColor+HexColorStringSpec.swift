//
//  NSColor+HexColorStringSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 23/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class NSColorHexColorStringSpec: QuickSpec {
    override func spec() {
        describe("NSColor+HexColorStringSpec") {
            describe("String.color") {
                it("Returns NSColor for a hex string") {
                    let red = "#FF0000".color
                    expect(red) == NSColor.red
                }

                it("Returns nil for an unrecognized string") {
                    let invalid = "#PUDDING".color
                    expect(invalid).to(beNil())
                }
            }
        }
    }
}
