//
//  LinkTextSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 8/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Cocoa

class LinkTextSpec: QuickSpec {
    override func spec() {
        describe("LinkText") {
            it("should open the correct URL when clicked") {
                let mockWorkspace = MockWorkspace()
                let linkText = LinkText()
                linkText.workspace = mockWorkspace
                let expectedURL = URL(string: "about_cutbox_home_url".l7n)
                linkText.mouseDown(with: NSEvent())
                expect(mockWorkspace.openURL).to(equal(expectedURL))
            }
        }
    }
}

class MockWorkspace: NSWorkspace {
    var openURL: URL?

    override func open(_ url: URL) -> Bool {
        openURL = url
        return true
    }
}
