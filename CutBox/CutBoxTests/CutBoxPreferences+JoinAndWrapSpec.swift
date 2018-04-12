//
//  CutBoxPreferences+JoinAndWrapSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class CutBoxPreferences_JoinAndWrapSpec: QuickSpec {
    override func spec() {
        describe("CutBoxPreferences+JoinAndWrap") {

            var subject: CutBoxPreferences!
            var defaults: UserDefaults!
            let items = [
                "Fakes",
                "To kill a mockingbird"
            ]

            beforeEach {
                defaults = UserDefaults(suiteName: "CutBoxPreferences+JoinAndWrap")!
                subject = CutBoxPreferences(defaults: defaults)
                subject.useJoinString = false
                subject.multiJoinString = nil
                subject.useWrappingStrings = false
                subject.wrappingStrings = (nil,nil)
            }

            afterEach {
                defaults.removeSuite(named: "CutBoxPreferences+JoinAndWrap")
            }

            context("multiple clips") {
                context("default behavior") {
                    it("joins multiple clips by newlines") {
                        let joined = subject.prepareClips(items)
                        expect(joined).to(equal("Fakes\nTo kill a mockingbird"))
                    }
                }

                context("joined by string") {
                    context("nil string") {
                        it("joins each item with nothing between them") {
                            subject.useJoinString = true

                            let joined = subject.prepareClips(items)
                            expect(joined).to(equal("FakesTo kill a mockingbird"))
                        }
                    }

                    context("has join string (comma)") {
                        it("joins each item with a comma") {
                            subject.useJoinString = true
                            subject.multiJoinString = ","

                            let joined = subject.prepareClips(items)
                            expect(joined).to(equal("Fakes,To kill a mockingbird"))
                        }
                    }
                }

                context("wrapped") {
                    context("nil strings") {
                        it("surrounds the joined strings with nothing") {
                            subject.useWrappingStrings = true
                            subject.wrappingStrings = (nil, nil)

                            let wrapped = subject.prepareClips(items)
                            let expected = "Fakes\nTo kill a mockingbird"
                            expect(wrapped).to(equal(expected))
                        }
                    }
                    context("using strings") {
                        it("surrounds the joined strings with start and end strings") {
                            subject.useWrappingStrings = true
                            subject.wrappingStrings = ("[", "]")

                            let wrapped = subject.prepareClips(items)
                            let expected = "[Fakes\nTo kill a mockingbird]"
                            expect(wrapped).to(equal(expected))
                        }
                    }
                }
            }
        }
    }
}

