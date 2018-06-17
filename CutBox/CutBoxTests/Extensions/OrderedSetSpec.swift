//
//  OrderedSetSpec.swift
//  CutBoxTests
//
//  Created by Jason on 20/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class OrderedSetSpec: QuickSpec {

    override func spec() {
        describe("OrderedSetSpec") {
            it("adds objects to itself") {
                let subject = OrderedSet<String>()
                subject.add("hello world")
                expect(subject.count).to(equal(1))
            }

            it("has unique value objects") {
                let subject = OrderedSet<String>()
                subject.add("Hello")
                subject.add("Hello")
                expect(subject.count).to(equal(1))
            }

            it("can remove items from the set") {
                let subject = OrderedSet<String>()
                subject.add("Hello")
                subject.add("Hello")
                subject.remove("Hello")
                expect(subject.count).to(equal(0))
            }

            it("finds the index of an object in the set") {
                let subject = OrderedSet<String>()
                subject.add("Hello")
                subject.add("World")
                subject.add("Foo")
                subject.add("Bar")
                expect(subject.indexOf("Foo")).to(equal(2))
            }

            it("can set an object at index") {
                let subject = OrderedSet<String>()
                subject.add("Hello")
                subject.add("World")
                subject.add("Foo")
                subject.add("Bar")
                subject.set("Plaster", at: 2)
                expect(subject.indexOf("Foo")).to(equal(-1))
                expect(subject.indexOf("Plaster")).to(equal(2))
            }

            it("returns the set as an ordered array") {
                let subject = OrderedSet<String>()
                subject.add("Hello")
                subject.add("World")
                subject.add("Foo")
                subject.add("Bar")
                expect(subject.all()).to(equal(
                    ["Hello", "World", "Foo", "Bar"]
                ))
            }
        }
    }

}
