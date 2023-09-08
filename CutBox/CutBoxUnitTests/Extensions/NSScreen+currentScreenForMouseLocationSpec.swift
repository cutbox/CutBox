//
//  NSScreen+currentScreenForMouseLocationSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 8/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Cocoa

class NSScreen_currentScreenForMouseLocationSpec: QuickSpec {
    override func spec() {
        describe("NSScreen+currentScreenForMouseLocation()") {
            let screen1Frame = NSRect(x: 0, y: 0, width: 800, height: 600)
            let screen2Frame = NSRect(x: 800, y: 0, width: 800, height: 600)
            let mockedScreen1 = MockScreen(frame: screen1Frame)
            let mockedScreen2 = MockScreen(frame: screen2Frame)

            beforeEach {
                NSScreen.overrideScreens([mockedScreen1, mockedScreen2])
            }

            it("should return the screen 1 for the mouse location") {
                let mouseLocation = NSPoint(x: 100, y: 100) // Inside Screen 1
                NSEvent.overrideMouseLocation(mouseLocation)
                if let result = NSScreen.currentScreenForMouseLocation() {
                    expect(result.frame) == mockedScreen1.frame
                } else {
                    fail("Expected a screen, but received nil")
                }
            }

            it("should return the screen 2 for the mouse location") {
                let mouseLocation = NSPoint(x: 900, y: 100) // Inside Screen 2
                NSEvent.overrideMouseLocation(mouseLocation)
                if let result = NSScreen.currentScreenForMouseLocation() {
                    expect(result.frame) == mockedScreen2.frame
                } else {
                    fail("Expected a screen, but received nil")
                }
            }
        }
    }
}

extension NSScreen {
    static var mockedScreens: [NSScreen] = []
    static func overrideScreens(_ screens: [NSScreen]) {
        mockedScreens = screens
    }
    class var screens: [NSScreen] {
        return mockedScreens
    }
}
extension NSEvent {
    private static var mockedMouseLocation: NSPoint = NSPoint(x: 0, y: 0)
    static func overrideMouseLocation(_ location: NSPoint) {
        mockedMouseLocation = location
    }
    static var mouseLocation: NSPoint {
        return mockedMouseLocation
    }
}
class MockScreen: NSScreen {
    private let mockFrame: NSRect

    init(frame: NSRect) {
        self.mockFrame = frame
    }

    override var frame: NSRect {
        return mockFrame
    }
}
