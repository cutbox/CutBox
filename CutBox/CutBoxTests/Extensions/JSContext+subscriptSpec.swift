//
//  JSContext+subscriptSpec.swift
//  CutBoxTests
//
//  Created by Jason on 11/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

import JavaScriptCore

@testable import CutBox

class JSContext_subscriptSpec: QuickSpec {
    override func spec() {
        describe("JSContext+subscript") {
            let ctx = JSContext()!
            context("subscript") {

                it("test ES6") {
                    expect(ctx.evaluateScript("""

                      let a = (e) => e * 10
                      a(5)

                    """).toInt32()).to(equal(50))
                }

                context("set") {
                    it("sets objects on the JSContext") {
                        ctx["items"] = [123, 524, 213, 523, 315, 213]

                        expect(ctx.evaluateScript("items")
                            .toArray() as? [Int])
                            .to(equal([123, 524, 213, 523, 315, 213]))
                    }
                }

                context("get") {
                    it("gets objects from the JSContext") {
                        ctx.evaluateScript("var items = [1,2,3,4,5,6]")

                        expect(ctx["items"].toArray() as? [Int]).to(equal([1, 2, 3, 4, 5, 6]))
                    }
                }
            }
        }
    }
}
