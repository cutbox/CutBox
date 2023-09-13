//
//  NSImage+fakeSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class NSImage_FakeSpec: QuickSpec {
    override func spec() {
        describe("NSImage+Fake") {
            it("provides fake images of default color and size") {
                expect(NSImage.fake).to(beAnInstanceOf(NSImage.self))
            }

            it("provides fake images of specified color and size") {
                let customFake = NSImage.fake(size: NSSize(width: 200, height: 100), color: .black)
                expect(customFake).to(beAnInstanceOf(NSImage.self))
                expect(customFake.size.width) == 200.0
                expect(customFake.size.height) == 100.0
            }
        }
    }
}
