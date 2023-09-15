//
//  JSContext+subscriptSpec.swift
//  CutBoxTests
//
//  Created by Jason on 11/5/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

import JavaScriptCore

class JSContextSubscriptSpec: QuickSpec {
    override func spec() {
        let ctx = JSContext()!

        describe("JSContext") {
            it("test ES6") {
                expect(ctx.evaluateScript("""

                      let a = (e) => e * 10
                      a(5)

                    """).toInt32()).to(equal(50))
            }
        }

        describe("JSContext+subscript") {
            let ctx = JSContext()!
            context("subscript") {
                context("set") {
                    it("sets objects on the JSContext") {
                        ctx["items"] = [123, 524, 213, 523, 315, 213]

                        expect(ctx.evaluateScript("items").toArray() as? [Int])
                        == [123, 524, 213, 523, 315, 213]
                    }
                }

                context("get") {
                    it("gets objects from the JSContext") {
                        ctx.evaluateScript("var items = [1,2,3,4,5,6]")

                        expect(ctx["items"].toArray() as? [Int]) == [1, 2, 3, 4, 5, 6]
                    }
                }
            }
        }
    }
}
