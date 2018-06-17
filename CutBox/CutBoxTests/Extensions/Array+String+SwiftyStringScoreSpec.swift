//
//  Array+String+SwiftyStringScoreSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class ArrayStringSwiftyStringScoreSpec: QuickSpec {

    override func spec() {
        describe("Array+String+SwiftyStringScore") {
            let sut = [
                "Foo bar",
                "Fizz Buzz",
                "Bob the Hoojah Melon",
                "JR Bob Dobbs",
                "Relatively complicated and doesn't fuzzy match with anything else, of this I'm sure.",
                "Generic code sample",
                "Boustrophedon",
                "Bobby",
                "Robobt",
                "Unexpected analogy",
                "Boost boost",
                "39124741",
                "FF443211",
                "Bob",
                "#ff11ab",
                "#FF0022",
                "Example"
            ]

            let fuzzySearch = "Bob"

            it("filters and ranks an array using search string") {
                let results = sut.fuzzySearchRankedFiltered(search: fuzzySearch,
                                                            score: 0.5)
                let expected = ["Bob",
                                "Bobby",
                                "Boost boost",
                                "Bob the Hoojah Melon",
                                "JR Bob Dobbs"]

                expect(expected).to(equal(results))
            }
        }
    }

}
