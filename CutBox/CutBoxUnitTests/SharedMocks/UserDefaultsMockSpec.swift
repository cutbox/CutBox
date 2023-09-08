//
//  UserDefaultsMockSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 19/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class UserDefaultsMockSpec: QuickSpec {
    override func spec() {
        var subject: UserDefaultsMock!

        describe("UserDefaultsMock") {
            context("Fake store of UserDefaults") {

                func insertHistoryStoreItem(_ string: String) {
                    var history = subject.array(forKey: Constants.kHistoryStoreKey)
                    as? [[String: String]] ??
                    [[String: String]]()
                    history.insert([Constants.kStringKey: string], at: 0)
                    subject.set(history, forKey: Constants.kHistoryStoreKey)
                }

                describe("insert") {
                    it("insert directly to the mock historyStore, circumventing the defaults api") {
                        // history store is keyed to "historyStore"
                        let historyKey = "historyStore"
                        subject = UserDefaultsMock()
                        insertHistoryStoreItem("test item")

                        let storedHistory = subject.array(forKey: historyKey) as? [[String: String]]

                        expect(storedHistory?[0]["string"]).to(equal("test item"))
                    }
                }

                it("sets and read a String in the store") {
                    subject = UserDefaultsMock()
                    subject.set("My String", forKey: "my_string")
                    let result = subject.string(forKey: "my_string")

                    // Check via UserDefaults api
                    expect(result).to(equal("My String"))

                    // Check that data kept in the mock storage
                    let store = subject.store as? [String: String]
                    let expect_store = ["my_string": "My String"]

                    expect(store).to(equal(expect_store))

                    // Check that data is not persisted
                    subject = UserDefaultsMock()
                    expect(subject.store.count).to(equal(0))
                }

                it("can set and read array of dictionaries in the store") {
                    subject = UserDefaultsMock()
                    subject.set(
                        [
                            ["a": 1],
                            ["a": 2],
                            ["a": 3],
                            ["a": 4]
                        ], forKey: "myArrayOfDictionaries")

                    // swiftlint:disable force_cast
                    var myArrayOfDictionaries = subject.array(forKey: "myArrayOfDictionaries") as! [[String: Int]]

                    expect(myArrayOfDictionaries).to(equal(
                        [
                            ["a": 1],
                            ["a": 2],
                            ["a": 3],
                            ["a": 4]
                        ]
                    ))

                    myArrayOfDictionaries.insert(["a": 10], at: 0)
                    subject.set(myArrayOfDictionaries, forKey: "myArrayOfDictionaries")

                    // swiftlint:disable force_cast
                    let updatedArrayOfDictionaries: [[String: Int]] = subject
                        .array(forKey: "myArrayOfDictionaries") as! [[String: Int]]

                    expect(updatedArrayOfDictionaries.count).to(equal(5))
                    expect(updatedArrayOfDictionaries.first).to(equal(["a": 10]))
                }

                it("can set and read an array in the store") {
                    subject = UserDefaultsMock()
                    subject.set([1, 2, 3, 4], forKey: "numArray")
                    // swiftlint:disable force_cast
                    var myArray = subject.array(forKey: "numArray") as! [Int]
                    // swiftlint:enable force_cast
                    expect(myArray).to(equal([1, 2, 3, 4]))

                    myArray.insert(10, at: 0)
                    subject.set(myArray, forKey: "numArray")
                    // swiftlint:disable force_cast
                    let updatedArray = subject.array(forKey: "numArray") as! [Int]
                    // swiftlint:enable force_cast

                    expect(updatedArray.count).to(equal(5))
                    expect(updatedArray.first).to(equal(10))
                }

                it("can set and read a bool in the store") {
                    subject = UserDefaultsMock()
                    subject.setValue(true, forKey: "testBool")

                    let result = subject.bool(forKey: "testBool")
                    let expectation = true

                    expect(result) == expectation
                }

                it("can set and read a float in the store") {
                    subject = UserDefaultsMock()
                    let float: Float = 2.43114324234520
                    subject.setValue(float, forKey: "testFloat")

                    let result: Float = subject.float(forKey: "testFloat")
                    let expectation: Float = 2.43114324234520

                    expect(result) == expectation
                }
            }
        }
    }
}
