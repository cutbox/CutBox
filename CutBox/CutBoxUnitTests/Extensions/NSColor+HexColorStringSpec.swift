//
//  NSColor+HexColorStringSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 23/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

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

            describe("NSColor.toHex(alpha:)") {
                it("returns a hex color with alpha component, last 2 of 8 digits") {
                    let colorWithAlpha = NSColor(deviceRed: 1.0, green: 0, blue: 0, alpha: 0.3)
                    expect(colorWithAlpha.toHex(alpha: true)) == "FF00004D"
                }
            }

            describe("NSColor.toHex") {
                it("Returns the hex string for a color") {
                    let red = NSColor.red
                    expect("FF0000") == red.toHex
                }
            }

            describe("NSColor.toHexAlpha") {
                it("Returns the RGBA hex string for a color") {
                    let red = NSColor.red
                    expect("FF0000FF") == red.toHexAlpha

                    let colorWithAlpha = NSColor(deviceRed: 1.0, green: 0, blue: 0, alpha: 0.3)
                    expect("FF00004D") == colorWithAlpha.toHexAlpha
                }
            }
        }
    }
}
