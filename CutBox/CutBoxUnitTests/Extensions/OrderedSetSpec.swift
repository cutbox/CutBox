//
//  OrderedSetSpec.swift
//  CutBoxTests
//
//  Created by Jason on 20/5/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class OrderedSetSpec: QuickSpec {
    override func spec() {
        describe("OrderedSet") {
            var orderedSet: OrderedSet<String>!

            beforeEach {
                orderedSet = OrderedSet<String>()
            }

            context("when adding elements") {
                it("should increase the count") {
                    orderedSet.add("Apple")
                    expect(orderedSet.count) == 1

                    orderedSet.add("Banana")
                    expect(orderedSet.count) == 2
                }

                it("should not add duplicates") {
                    orderedSet.add("Apple")
                    expect(orderedSet.count) == 1

                    orderedSet.add("Apple")
                    expect(orderedSet.count) == 1
                }
            }

            context("when inserting elements at a specific index") {
                it("should increase the count") {
                    orderedSet.add("Grape")
                    orderedSet.insert("Banana", at: 0)
                    expect(orderedSet.count) == 2
                    orderedSet.insert("Pear", at: 0)
                    expect(orderedSet.count) == 3
                }

                it("should insert at the specified index") {
                    orderedSet.add("Grape")
                    orderedSet.insert("Apple", at: 0)
                    orderedSet.insert("Banana", at: 0)

                    expect(orderedSet.all()) == ["Banana", "Apple", "Grape"]
                }

                it("does not allow insert on an empty set") {
                    expect { orderedSet.insert("Apple", at: 0) }.to(throwAssertion())
                }

                it("should not insert duplicates") {
                    orderedSet.add("Apple")

                    orderedSet.insert("Apple", at: 0)
                    expect(orderedSet.count) == 1

                    orderedSet.insert("Apple", at: 0)
                    expect(orderedSet.count) == 1
                }

                it("should assert if the index is out of bounds") {
                    orderedSet.add("Banana")
                    expect { orderedSet.insert("Apple", at: 2) }.to(throwAssertion())
                    expect { orderedSet.insert("Apple", at: -1) }.to(throwAssertion())
                }
            }

            context("when setting a new index for an element") {
                it("should assert if the index is out of bounds") {
                    orderedSet.add("Banana")
                    expect { orderedSet.set("Banana", at: 2) }.to(throwAssertion())
                    expect { orderedSet.set("Banana", at: -1) }.to(throwAssertion())
                }

                it("should set the object at a given index") {
                    orderedSet.add("Apple")
                    orderedSet.add("Orange")
                    orderedSet.add("Peach")
                    orderedSet.add("Grapefruit")

                    orderedSet.set("Strawberry", at: 0)

                    expect(orderedSet.count) == 4
                    expect(orderedSet.all()) == [
                        "Strawberry",
                        "Orange",
                        "Peach",
                        "Grapefruit"
                    ]
                }

                it("cannot set the object at a given index to a duplicate value") {
                    orderedSet.add("Apple")
                    orderedSet.add("Orange")
                    orderedSet.add("Peach")
                    orderedSet.add("Grapefruit")

                    orderedSet.set("Peach", at: 0)

                    expect(orderedSet.count) == 4
                    expect(orderedSet.all()) == [
                        "Apple",
                        "Orange",
                        "Peach",
                        "Grapefruit"
                    ]
                }
            }

            context("when removing elements") {
                it("should decrease the count") {
                    orderedSet.add("Apple")
                    orderedSet.add("Banana")

                    orderedSet.remove("Apple")
                    expect(orderedSet.count) == 1
                }

                it("should remove the specified element") {
                    orderedSet.add("Apple")
                    orderedSet.add("Banana")

                    orderedSet.remove("Apple")
                    expect(orderedSet.all()) == ["Banana"]
                }

                it("return nil if the element is not found") {
                    orderedSet.add("Apple")
                    orderedSet.add("Banana")

                    expect(orderedSet.remove("Cherry")) == ()
                }
            }

            context("when accessing elements") {
                it("should return the element at the specified index") {
                    orderedSet.add("Apple")
                    orderedSet.add("Banana")

                    expect(orderedSet.object(at: 0)) == "Apple"
                    expect(orderedSet.object(at: 1)) == "Banana"
                }

                it("should assert if the index is out of bounds") {
                    expect { _ = orderedSet.object(at: 2) }.to(throwAssertion())
                    expect { _ = orderedSet.object(at: -1) }.to(throwAssertion())
                }
            }

            context("when getting the index of an element") {
                it("should return the correct index") {
                    orderedSet.add("Apple")
                    orderedSet.add("Banana")

                    expect(orderedSet.indexOf("Apple")) == 0
                    expect(orderedSet.indexOf("Banana")) == 1
                }

                it("should return -1 for non-existent elements") {
                    expect(orderedSet.indexOf("Cherry")) == -1
                }
            }

            context("when getting the ") {
                it("throws an assertion if the index is out of range") {
                    let subject = OrderedSet<Int>()
                    subject.add(10)
                    subject.add(12)
                    expect { subject.object(at: 2) }.to(throwAssertion())
                }
                it("throws an assertion if the index is less than 0") {
                    let subject = OrderedSet<Int>()
                    subject.add(10)
                    subject.add(12)
                    expect { subject.object(at: -2) }.to(throwAssertion())
                }
            }
        }
    }
}
