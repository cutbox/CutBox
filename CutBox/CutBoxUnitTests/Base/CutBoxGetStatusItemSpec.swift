//
//  CutBoxGetStatusItemSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxGetStatusItemSpec: QuickSpec {
    override func spec() {
        describe("cutBoxGetStatusItem") {
            it("returns a StatusItem from System") {
                let statusItem = cutBoxGetStatusItem()
                expect(statusItem).to(beAnInstanceOf(NSStatusItem.self))
            }
        }
    }
}
