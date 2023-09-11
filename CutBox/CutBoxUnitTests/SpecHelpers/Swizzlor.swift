//
//  Swizzlor.swift
//  CutBoxUnitTests
//
//  Created by jason on 9/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Quick
import Nimble

class Swizzlor {
    private typealias SwizzleInfo = (originalMethod: Method, swizzledMethod: Method)

    private static var swizzledMethods: [String: SwizzleInfo] = [:]

    static func swap(type classType: AnyClass,
                     selector originalSelector: Selector,
                     with swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(classType, originalSelector),
              let swizzledMethod = class_getInstanceMethod(classType, swizzledSelector) else {
            return
        }

        let className = NSStringFromClass(classType)
        let key = "\(className)-\(originalSelector)-\(swizzledSelector)"

        if swizzledMethods[key] == nil {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            swizzledMethods[key] = (originalMethod, swizzledMethod)
        }
    }

    static func undo() {
        for (_, info) in swizzledMethods {
            let originalMethod = info.originalMethod
            let swizzledMethod = info.swizzledMethod
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }

        swizzledMethods.removeAll()
    }
}

class SwizzlorSpec: QuickSpec {
    override func spec() {

        class TestClass {
            @objc dynamic func originalMethod() -> String {
                return "Original"
            }

            @objc dynamic func swizzledMethod() -> String {
                return "Swizzled"
            }
        }

        describe("Swizzlor") {
            let testInstance = TestClass()

            beforeEach {
                // methods must be @objc dynamic to be swizzled in Swift types.
                Swizzlor.swap(type: TestClass.self,
                              selector: #selector(TestClass.originalMethod),
                              with: #selector(TestClass.swizzledMethod))
            }

            context("swap") {
                it("should swap the methods") {
                    expect(testInstance.originalMethod() == "Swizzled").to(beTrue())
                    expect(testInstance.swizzledMethod() == "Original").to(beTrue())
                }
           }

            context("undo") {
                it("should undo any Swizzlor.swaps") {
                    Swizzlor.undo()
                    expect(testInstance.originalMethod() == "Original").to(beTrue())
                    expect(testInstance.swizzledMethod() == "Swizzled").to(beTrue())
                }
            }
        }
    }
}
