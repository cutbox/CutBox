//
//  ValidIndicatorTextFieldSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class TestValidIndicatorTextField: ValidIndicatorTextField {
    // This sub class exposes self.layer for property tests
    var fieldLayer: CALayer? {
        return self.layer
    }
}

class ValidIndicatorTextFieldSpec: QuickSpec {
    override func spec() {
        describe("ValidIndicatorTextField") {
            let subject = TestValidIndicatorTextField()
            it("should changed color when validity is set") {
                subject.isValid = false
                let redness = subject.fieldLayer?.borderColor?.components?[0]
                let greenness = subject.fieldLayer?.borderColor?.components?[1]
                expect(redness) > greenness
            }
        }
    }
}
