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
        get {
            return self.layer
        }

        set {
            self.layer = newValue
        }
    }
}

class ValidIndicatorTextFieldSpec: QuickSpec {
    override func spec() {
        describe("ValidIndicatorTextField") {
            let subject = TestValidIndicatorTextField()
            subject.fieldLayer = CALayer()

            it("should have a red border when invalid") {
                subject.isValid = false
                if let redness: CGFloat = subject.fieldLayer?.borderColor?.components?[0],
                   let greenness: CGFloat = subject.fieldLayer?.borderColor?.components?[1] {
                    // We don't care about the specific color or tint alteration
                    // just that it is simplistically more red than green.
                    expect(redness) > greenness
                } else {
                    fail("Could not access field layer border color components")
                }
            }

            it("should have a green border when valid") {
                subject.isValid = true
                if let redness: CGFloat = subject.fieldLayer?.borderColor?.components?[0],
                   let greenness: CGFloat = subject.fieldLayer?.borderColor?.components?[1] {
                    // We don't care about the specific color or tint alteration
                    // just that it is simplistically more green than red.
                    expect(greenness) > redness
                } else {
                    fail("Could not access field layer border color components")
                }
            }
        }
    }
}
