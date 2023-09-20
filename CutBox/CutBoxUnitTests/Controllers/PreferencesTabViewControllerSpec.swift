//
//  PreferencesTabViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 20/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class PreferencesTabViewControllerSpec: QuickSpec {
    override func spec() {
        describe("PreferencesTabViewController") {
            let subject = PreferencesTabViewController()

            context("viewDidLoad") {
                subject.viewDidLoad()
                expect(subject.view.isHidden).to(beFalse())
            }

            context("open") {
                subject.open()
                expect(subject.view.isHidden).to(beFalse())
            }
        }
    }
}
