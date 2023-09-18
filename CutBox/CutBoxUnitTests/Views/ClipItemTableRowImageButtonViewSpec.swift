//
//  ClipItemTableRowImageButtonViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ClipItemTableRowImageButtonViewSpec: QuickSpec {
    override func spec() {
        describe("ClipItemTableRowImageButtonView") {
            let mockImageButton = CutBoxBaseButton(frame: .zero)
            let subject = ClipItemTableRowImageButtonView(
                frame: NSRect(x: 0, y: 0, width: 100, height: 30))

            describe("setup") {
                beforeEach {
                    subject.imageButton = mockImageButton
                }

                it("configures itself as a clip item") {
                    subject.color = .red
                    subject.data = ["string": "This is a clip"]

                    let tiff = CutBoxImageRef.page.image()
                        .tint(color: subject.color)
                        .tiffRepresentation

                    expect(mockImageButton.image?.tiffRepresentation) == tiff
                }

                it("configures itself as a favorite item") {
                    subject.color = .red
                    subject.data = ["string": "This is a clip", "favorite": "Literally anything"]

                    let tiff = CutBoxImageRef.star.image()
                        .tint(color: subject.color)
                        .tiffRepresentation

                    expect(mockImageButton.image?.tiffRepresentation) == tiff
                }

                it("can configure color without clip data") {
                    subject.color = .red

                    let tiff = CutBoxImageRef.page.image()
                        .tint(color: subject.color)
                        .tiffRepresentation

                    expect(mockImageButton.image?.tiffRepresentation) == tiff
                }

                it("throws a fatalError if data is nil") {
                    expect { subject.data = nil }.to(throwAssertion())
                }
            }
        }
    }
}
