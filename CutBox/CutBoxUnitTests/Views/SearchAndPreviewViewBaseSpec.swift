//
//  SearchAndPreviewViewBaseSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 21/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class SearchAndPreviewViewBaseSpec: QuickSpec {
    override func spec() {
        describe("SearchAndPreviewViewBase") {
            let subject = SearchAndPreviewView()
            let mainContainer = CutBoxBaseStackView()
            let container = CutBoxBaseStackView()
            let searchTextContainerHeight = NSLayoutConstraint()
            let mainTopConstraint = NSLayoutConstraint()
            let mainLeadingConstraint = NSLayoutConstraint()
            let mainTrailingConstraint = NSLayoutConstraint()
            let mainBottomConstraint = NSLayoutConstraint()
            let mockDefaults = UserDefaultsMock()
            let mockPrefs = CutBoxPreferencesService(defaults: mockDefaults)

            beforeEach {
                subject.prefs = mockPrefs
                subject.mainContainer = mainContainer
                subject.container = container
                subject.searchTextContainerHeight = searchTextContainerHeight
                subject.mainTopConstraint = mainTopConstraint
                subject.mainLeadingConstraint = mainLeadingConstraint
                subject.mainTrailingConstraint = mainTrailingConstraint
                subject.mainBottomConstraint = mainBottomConstraint
            }

            describe("filterTextPublisher") {
                var result = "failed"
                _ = subject.filterTextPublisher.subscribe(onNext: {
                    result = $0
                })
                subject.filterTextPublisher.onNext("    ")
                expect(result) == "    "
            }

            describe("searchTextHeight") {
                expect { subject.searchTextHeight }.to(throwAssertion())
            }

            describe("menuDelegate") {
                it("should be nil at init") {
                    expect(subject.menuDelegate).to(beNil())
                }
            }

            describe("itemsDelegate") {
                it("should be nil at init") {
                    expect(subject.itemsDelegate).to(beNil())
                }
            }

            describe("itemsDataSource") {
                it("should be nil at init") {
                    expect(subject.itemsDataSource).to(beNil())
                }
            }

            describe("previewString") {
                it("should be nil at init") {
                    expect(subject.previewString).to(beNil())
                }
            }

            describe("applyTheme") {
                it("applies the color theme to the view") {
                    subject.applyTheme()

                    expect(subject.spacing) == 0.0
                }
            }
        }
    }
}
