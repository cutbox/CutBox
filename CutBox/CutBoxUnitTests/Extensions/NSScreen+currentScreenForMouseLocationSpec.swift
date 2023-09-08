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
        describe("NSScreen Extension") {
            context("currentScreenForMouseLocation()") {
                it("should return the correct screen for the mouse location") {
                    // Mock the mouse location for testing
                    let mouseLocation = NSPoint(x: 1200, y: 100) // Replace with your desired mouse location

                    // Mock screens with known frames for testing
                    let screen1Frame = NSRect(x: 0, y: 0, width: 800, height: 600)
                    let screen2Frame = NSRect(x: 800, y: 0, width: 800, height: 600)

                    // Create mocked screens
                    let mockedScreen1 = MockScreen(frame: screen1Frame)
                    let mockedScreen2 = MockScreen(frame: screen2Frame)

                    // Override the screens property in NSScreen extension
                    NSScreen.overrideScreens([mockedScreen1, mockedScreen2])

                    // Override the mouse location in NSEvent extension
                    NSEvent.overrideMouseLocation(mouseLocation)

                    // Call the extension method
                    if let result = NSScreen.currentScreenForMouseLocation() {
                        // Verify that the correct screen is returned
                        expect(result.frame) == mockedScreen2.frame
                    } else {
                        fail("Expected a screen, but received nil")
                    }
                }
            }
        }
    }
}

// NSScreen extension for testing
extension NSScreen {
    static var mockedScreens: [NSScreen] = []

    static func overrideScreens(_ screens: [NSScreen]) {
        mockedScreens = screens
    }

    class var screens: [NSScreen] {
        return mockedScreens
    }
}

// NSEvent extension for testing
extension NSEvent {
    private static var mockedMouseLocation: NSPoint = NSPoint(x: 0, y: 0)

    static func overrideMouseLocation(_ location: NSPoint) {
        mockedMouseLocation = location
    }

    static var mouseLocation: NSPoint {
        return mockedMouseLocation
    }
}

// Mock NSScreen class for testing
class MockScreen: NSScreen {
    private let mockFrame: NSRect

    init(frame: NSRect) {
        self.mockFrame = frame
    }

    override var frame: NSRect {
        return mockFrame
    }
}
