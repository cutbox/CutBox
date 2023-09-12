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
    var initWithParamsCalled = false
    var awakeFromNibWasCalled = false

    public override init(contentRect: NSRect,
                         styleMask style: NSWindow.StyleMask,
                         backing backingStoreType: NSWindow.BackingStoreType,
                         defer flag: Bool) {
        super.init(contentRect: contentRect,
                   styleMask: style,
                   backing: backingStoreType,
                   defer: flag)
        self.initWithParamsCalled = true
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.awakeFromNibWasCalled = true
    }
}

public class CutBoxBaseViewController: NSViewController {
    var initCoderWasCalled = false
    var initWithParamsWasCalled = false

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCoderWasCalled = true
    }

    public override init(nibName nibNameOrNil: NSNib.Name?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
        initWithParamsWasCalled = true
    }
}

public class CutBoxBaseView: NSView {
    var awakeFromNibWasCalled = false
    var initCoderWasCalled = false
    var initFrameWasCalled = false

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCoderWasCalled = true
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initFrameWasCalled = true
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.awakeFromNibWasCalled = true
    }
}

public class CutBoxBaseTextView: NSTextView {
    var initCoderWasCalled = false
    var initFrameWasCalled = false
    var keyDownWasCalled = false
    var doCommandWasCalled = false

    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        self.initFrameWasCalled = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCoderWasCalled = true
    }

    public override func keyDown(with event: NSEvent?) {
        if let event = event {
            super.keyDown(with: event)
        }
        self.keyDownWasCalled = true
    }

    public override func doCommand(by selector: Selector?) {
        if let selector = selector {
            super.doCommand(by: selector)
        }
        self.doCommandWasCalled = true
    }
}

class CutBoxBaseTextField: NSTextField {
}

class CutBoxBaseTextFieldCell: NSTextFieldCell {
}

class CutBoxBaseButton: NSButton {
}

class CutBoxBaseTabViewItem: NSTabViewItem {
}

class CutBoxBaseTabView: NSTabView {
}

class CutBoxBaseTabViewController: NSTabViewController {
}

class CutBoxBaseTextContainer: NSTextContainer {
}

class CutBoxBasePopUpButton: NSPopUpButton {
}

class CutBoxBaseSegmentedControl: NSSegmentedControl {
}

class CutBoxBaseBox: NSBox {
}

class CutBoxBaseMenu: NSMenu {
    override func item(at index: Int) -> CutBoxBaseMenuItem? {
        return super.item(at: index) as? CutBoxBaseMenuItem
    }
}

class CutBoxBaseMenuItem: NSMenuItem {
}

class CutBoxBaseImage: NSImage {
}

class CutBoxBaseImageView: NSImageView {
}

class CutBoxBaseStackView: NSStackView {
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
