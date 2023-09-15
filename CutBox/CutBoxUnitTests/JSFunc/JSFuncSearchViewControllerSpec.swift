//
//  JSFuncSearchViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 15/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class MockJSFuncSearchAndPreviewView: JSFuncSearchAndPreviewView {

}

class JSFuncSearchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("JSFuncSearchViewController") {
            var subject: JSFuncSearchViewController!
            var mockUserDefaults: UserDefaultsMock!
            var prefs: CutBoxPreferencesService!
            var mockFakeKey: FakeKey!
            var mockJSFuncService: MockJSFuncService!
            var mockJSFuncView: JSFuncSearchAndPreviewView!
            var mockSearchScopeImageButton = CutBoxBaseButton()

            beforeEach {
                SearchAndPreviewViewBase.testing = true

                mockJSFuncService = MockJSFuncService()
                mockUserDefaults = UserDefaultsMock()
                prefs = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockFakeKey = FakeKey()
                mockFakeKey.testing = true
                mockJSFuncView = MockJSFuncSearchAndPreviewView()
                mockJSFuncView.searchScopeImageButton = mockSearchScopeImageButton

                subject = JSFuncSearchViewController(
                    jsFuncService: mockJSFuncService,
                    cutBoxPreferences: prefs,
                    fakeKey: mockFakeKey,
                    jsFuncView: mockJSFuncView
                )
            }

            context("when initialized") {
                it("should have the correct initial properties") {
                    expect(subject.jsFuncService).to(beIdenticalTo(mockJSFuncService))
                    expect(subject.prefs).to(beIdenticalTo(prefs))
                    expect(subject.fakeKey).to(beIdenticalTo(mockFakeKey))
                    expect(subject.jsFuncView).to(beIdenticalTo(mockJSFuncView))
                    expect(subject.jsFuncView.searchScopeImageButton).toNot(beNil())
                    expect(subject.selectedClips).to(beEmpty())
                    expect(subject.hasFuncs).to(beFalse())
                    expect(subject.count).to(equal(0))
                }
            }

            context("when configured") {
                it("should have a funcList") {
                    expect(subject.funcList).toNot(beNil())
                }

                it("should configure JS popup and view correctly") {
                    expect(subject.jsFuncPopup).toNot(beNil())
                }

                it("should set up search text event bindings") {
                    expect(subject.events.hasObservers).to(beTrue())
                }

                it("should apply the current theme") {
                    subject.jsFuncView.applyTheme()
                    expect { subject.jsFuncView.applyTheme() }.toNot(throwAssertion())
                }

                it("has a search view that can become first responder") {
                    expect(subject.jsFuncView.acceptsFirstResponder).to(beTrue())
                }
            }
        }
    }
}
