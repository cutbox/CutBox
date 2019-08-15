//
//  Collection+SafeSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class CollectionSafeSpec: QuickSpec {

    override func spec() {
        describe("Collection+Safe") {
            let sut = [1, 2, 3]

            it("returns nil when index is out of range") {
                let actual = sut[safe: 4]

                expect(actual).to(beNil())
            }
        }
    }

}
