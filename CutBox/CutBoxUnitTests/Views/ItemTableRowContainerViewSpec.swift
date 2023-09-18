//
//  ItemTableRowContainerViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ItemTableRowContainerViewSpec: QuickSpec {
    override func spec() {
        describe("ItemTableRowContainerView") {
            let subject = ItemTableRowContainerView()
            it("should draw") {
                expect {
                    subject.drawSelection(in: NSRect(x: 0, y: 0, width: 200, height: 200))
                }.toNot(throwAssertion())
            }
        }
    }
}
