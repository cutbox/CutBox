//
//  Int+doTimesSpec.swift
//  CutBox
//
//  Created by Jason Milkins on 22/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class Int_doTimesSpec: QuickSpec {
    override func spec() {
        describe("Int.doTimes") {
            context("loop int times") {
                it("with arg") {
                    let int = 100
                    var out = 0
                    int.doTimes { out += ($0 * $0) }
                    expect(out) == 328350
                }

                it("implicitly ignoring arg") {
                    let int = 100
                    var out = 0
                    int.doTimes { out += 10 }
                    expect(out) == 1000
                }
            }

            context("will not loop less than 1 time") {
                it("using count arg") {
                    let int = -1
                    var leaveItAlone = 0
                    int.doTimes {
                        leaveItAlone += $0 * 10
                    }
                    expect(leaveItAlone) == 0
                }

                it("ignoring count arg") {
                    let int = 0
                    var leaveItAlone = 0
                    int.doTimes { leaveItAlone += 10 }
                    expect(leaveItAlone) == 0
                }
            }
        }
    }
}
