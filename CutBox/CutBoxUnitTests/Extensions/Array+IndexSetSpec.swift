//
//  Array+IndexSetSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble

class ArrayIndexSetSpec: QuickSpec {

    override func spec() {
        describe("Array+IndexSet") {
            it("Accesses an array using an indexset") {
                let sut = [0, 1, 2, 3, 4, 5, 6, 7]
                let indexes = [1, 3, 6] as IndexSet
                let expected = [1, 3, 6]
                let actual = sut[indexes]
                expect(expected).to(equal(actual))
            }
        }
    }
}
