//
//  StatusMenuController.swift
//  CutBox
//
//  Created by jason on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class SearchView: NSView {

    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        let (keyCode, modifier) = (
            KeyCode(rawValue: event.keyCode),
            event.modifierFlags.getModifierKey()
        )
        guard let key = keyCode else { return }

        switch (key, modifier) {
        case (.slash, .shift?):
            debugPrint("question mark")
        case (.slash, nil):
            debugPrint("slash")
        case (.up, nil):
            debugPrint("up")
        case (.down, nil):
            debugPrint("down")
        case (.left, nil):
            debugPrint("left")
        case (.right, nil):
            debugPrint("right")
        default:
            debugPrint(String(event.keyCode).padding(toLength: 8, withPad: " ", startingAt: 0),
                       String(event.modifierFlags.rawValue, radix: 2)
                        .padLeft(toLength: 24, withPad: "0"))
            super.keyDown(with: event)
        }
    }
}

class SearchController: NSObject {

}

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let searchView: SearchView
    let popup: PopupController

    override init() {
        let screen = NSScreen.main
        let modifiers = [
            ("function", NSEvent.ModifierFlags.function),
            ("help", NSEvent.ModifierFlags.help),
            ("command", NSEvent.ModifierFlags.command),
            ("option", NSEvent.ModifierFlags.option),
            ("shift", NSEvent.ModifierFlags.shift),
            ("capsLock", NSEvent.ModifierFlags.capsLock),
            ]

        modifiers.forEach { (name, modifier) in
            debugPrint(name.padding(toLength: 8, withPad: " ", startingAt: 0),
                       String(modifier.rawValue, radix: 2)
                        .padLeft(toLength: 24, withPad: "0"))
        }

        self.searchView = SearchView(frame:
            CGRect(x: 0, y: 0,
                   width: (screen?.frame.width)! / 2.5,
                   height: (screen?.frame.height)! / 2.5 )
        )

        self.popup = PopupController(contentView: searchView)
        self.popup.backgroundView.backgroundColor = NSColor.black
        self.popup.backgroundView.alphaValue = 0.8
        self.popup.resizePopup(width: searchView.frame.width,
                               height: searchView.frame.height)
        self.popup.didOpenPopup = {
            debugPrint("Opened popup")
        }

        self.popup.didClosePopup = {
            debugPrint("Closed popup")
        }
        super.init()
    }

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        // Search recent paste board items
        popup.togglePopup()
    }

    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
}

public class PopupController: NSWindowController {

    public let panel = PopupPanel()

    public let backgroundView = PopupBackgroundView()
    public let containerView = PopupContainerView()
    public var contentView: NSView

    public var openDuration: TimeInterval = 0.15
    public var closeDuration: TimeInterval = 0.2

    public var contentInset: CGFloat {
        get { return containerView.contentInset }
        set {
            let size = containerView.frame.size
            containerView.contentInset = newValue
            resizePopup(width: size.width, height: size.height)
        }
    }

    private(set) public var isOpen: Bool = false

    fileprivate var isOpening: Bool = false

    public var willOpenPopup: (()->(Void))?
    public var didOpenPopup: (()->(Void))?
    public var willClosePopup: (()->(Void))?
    public var didClosePopup: (()->(Void))?

    var lastMouseDownEvent: NSEvent?
    var mouseDownEventMonitor: Any?
    var mouseUpEventMonitor: Any?

    public init(contentView: NSView) {
        self.contentView = contentView
        super.init(window: panel)
        setup()
    }

    required public init?(coder: NSCoder) {
        self.contentView = coder.decodeObject(forKey: "contentView") as? NSView ?? NSView()

        super.init(coder: coder)
        self.window = panel

        setup()
    }

    private func setup() {
        panel.windowController = self
        panel.acceptsMouseMovedEvents = true
        panel.level = NSWindow.Level(rawValue:
            Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)))
        panel.isOpaque = false
        panel.backgroundColor = NSColor.clear
        panel.styleMask = .nonactivatingPanel
        panel.hidesOnDeactivate = false
        panel.hasShadow = true
        panel.delegate = self
        panel.contentView = backgroundView
        backgroundView.addSubview(containerView)

        let contentSize = contentView.frame.size

        containerView.setup()
        containerView.contentView = contentView

        panel.initialFirstResponder = contentView

        resizePopup(width: contentSize.width, height: contentSize.height)
    }

    public func openPopup() {
        openPanel()
    }

    public func closePopup() {
        closePanel()
    }

    public func togglePopup() {
        isOpen ? closePanel() : openPanel()
    }

    public func resizePopup(width: CGFloat, height: CGFloat) {
        var frame = panel.frame

        var newSize = CGSize(width: width, height: height)
        newSize.height += contentInset * 2
        newSize.width += contentInset * 2

        frame.origin.y -= newSize.height - frame.size.height
        frame.size.height = newSize.height

        let widthDifference = newSize.width - frame.size.width
        if widthDifference != 0 {
            frame.origin.x -= widthDifference / 2
            frame.size.width = newSize.width
        }

        containerView.resetConstraints()
        panel.setFrame(frame, display: true, animate: panel.isVisible)
    }

    public func resizePopup(width: CGFloat) {
        resizePopup(width: width, height: contentView.frame.size.height)
    }

    public func resizePopup(height: CGFloat) {
        resizePopup(width: contentView.frame.size.width, height: height)
    }

    private func openPanel() {
        self.isOpening = true

        willOpenPopup?()

        self.isOpen = true

        contentView.isHidden = false
        let panelRect = rect(forPanel: panel)

        NSApp.activate(ignoringOtherApps: false)
        panel.alphaValue = 0
        panel.setFrame(panelRect, display: true)
        panel.makeKeyAndOrderFront(self)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = openDuration
            self.panel.animator().alphaValue = 1
        }, completionHandler: {
            self.isOpening = false

            if self.isOpen {
                self.didOpenPopup?()
                self.panel.makeKeyAndOrderFront(self)
            }
        })
    }

    private func closePanel() {
        willClosePopup?()

        self.isOpen = false

        contentView.isHidden = true

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = closeDuration
            self.panel.animator().alphaValue = 0
        }, completionHandler: {
            guard !self.isOpen else {
                return
            }

            self.panel.orderOut(nil)
            self.didClosePopup?()
        })
    }

    private func rect(forPanel panel: NSPanel) ->  CGRect {
        guard let screen = NSScreen.main else {
            return CGRect.zero
        }

        let screenRect = screen.frame

        var panelRect = panel.frame
        panelRect.origin.x = round(screenRect.midX - panelRect.width / 2)
        panelRect.origin.y = round(screenRect.midY - panelRect.height / 2)

        if panelRect.maxX > screenRect.maxX {
            panelRect.origin.x -= panelRect.maxX - screenRect.maxX
        }

        return panelRect
    }
}

extension PopupController: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        closePopup()
    }

    public func windowDidResignKey(_ notification: Notification) {
        if window?.isVisible == true && !isOpening {
            closePopup()
        }
    }
}

public class PopupPanel: NSPanel {}

extension PopupPanel {
    public override var canBecomeKey: Bool {
        get {
            return true
        }
    }
}

extension PopupPanel {
    public override func cancelOperation(_ sender: Any?) {
        resignKey()
    }
}

public class PopupBackgroundView: NSView {
    public var cornerRadius: CGFloat = 6
    public var backgroundColor = NSColor.windowBackgroundColor

    public override func draw(_ dirtyRect: NSRect) {
        let contentRect = self.bounds
        let path = NSBezierPath()
        path.appendRoundedRect(contentRect, xRadius: cornerRadius, yRadius: cornerRadius)
        path.close()
        backgroundColor.setFill()
        path.fill()
    }
}

public class PopupContainerView: NSView {
    public var contentInset: CGFloat = 1

    var contentView: NSView? {
        didSet {
            removeConstraints(constraints)
            guard let contentView = contentView else { return }

            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            ["H:|-0-[contentView]-0-|", "V:|-0-[contentView]-0-|"].forEach {
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: $0,
                                                              options: .directionLeadingToTrailing,
                                                              metrics: nil,
                                                              views: ["contentView": contentView]))
            }
        }
    }

    var superviewConstraints = [NSLayoutConstraint]()

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        resetConstraints()
    }

    func resetConstraints() {
        guard let superview = superview as? PopupBackgroundView else { return }

        superview.removeConstraints(superviewConstraints)

        let horizontalFormat = "H:|-\(contentInset)-[containerView]-\(contentInset)-|"
        let verticalFormat = "V:|-\(contentInset)-[containerView]-\(contentInset)-|"

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat,
                                                                   options: .directionLeadingToTrailing,
                                                                   metrics: nil,
                                                                   views: ["containerView" : self])

        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat,
                                                                 options: .directionLeadingToTrailing,
                                                                 metrics: nil,
                                                                 views: ["containerView" : self])

        self.superviewConstraints = horizontalConstraints + verticalConstraints
        superview.addConstraints(superviewConstraints)
    }
}

extension String {
    func padLeft(toLength: Int, withPad: String) -> String {
        let toPad = toLength - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: withPad, startingAt: 0) + self
    }
}
