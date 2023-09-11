//
//  CutBoxBaseClasses.swift
//  CutBox
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Cocoa

public class CutBoxBaseWindowController: NSWindowController {
    var initCoderWasCalled = false
    var initWindowWasCalled = false

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCoderWasCalled = true
    }

    public override init(window: NSWindow?) {
        super.init(window: window)
        self.initWindowWasCalled = true
    }
}

public class CutBoxBaseWindow: NSWindow {

    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }
}

public class CutBoxBaseViewController: NSViewController {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

public class CutBoxBaseView: NSView {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    public override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

public class CutBoxBaseTextView: NSTextView {

    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }

    public override func doCommand(by selector: Selector) {
        super.doCommand(by: selector)
    }

    // Plan for NSWrappers
    // marshall calls to super

    // Step 1: All existing subclasses or uses of NS(T) cocoa
    // objects demand a App Base sub-class of NS(T) to exist
    // and be used instead.

    // Caveat:
    // (Monitor carefully for breakage before tests are
    // added on the view & controller layers)

    // Step 2: Trial the idea of T.static var testMode: Bool
    // To provide a test mode, so all super calls to base
    // class can be caught and recorded in test state
    // Turning this App Base layer into a  set of function
    // spies.

    // Caveat:
    // Move slowly and catch one super call at a time
    // per Test / Commit cycle.

    // Step 3: Utilize test mode, write specs for the larger
    // controller classes, add more testing/encapsulation
    // via the app base classes as required.
}
