//
//  CutBoxImageRefSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxImageRefSpec: QuickSpec {
    override func spec() {
        describe("CutBoxImageRef") {
            it("provides images by reference") {
                let image = CutBoxImageRef.magnitude.image()
                expect(image).to(beAKindOf(NSImage.self))
            }
        }
    }
}
