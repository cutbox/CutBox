//
//  PopupController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class PopupController: NSWindowController {

    let panel = PopupPanel()

    let backgroundView = PopupBackgroundView()
    let containerView = PopupContainerView()
    var contentView: NSView

    var currentHeight: CGFloat = 0
    var currentWidth: CGFloat = 0

    var yPadding: CGFloat = 0

    var contentInset: CGFloat {
        get { return containerView.contentInset }
        set {
            let size = containerView.frame.size
            containerView.contentInset = newValue
            resizePopup(width: size.width, height: size.height)
        }
    }

    private(set)  var isOpen: Bool = false

    var isOpening: Bool = false

    var willOpenPopup: (()->(Void))?
    var didOpenPopup: (()->(Void))?
    var willClosePopup: (()->(Void))?
    var didClosePopup: (()->(Void))?

    var lastMouseDownEvent: NSEvent?
    var mouseDownEventMonitor: Any?
    var mouseUpEventMonitor: Any?

    var lastKeyDownEvent: NSEvent?
    var keyDownEventMonitor: Any?

    init(content: NSView) {
        self.contentView = content
        super.init(window: panel)
        setup()
    }

    required init?(coder: NSCoder) {
        self.contentView = coder.decodeObject(forKey: "contentView") as? NSView ?? NSView()
        super.init(coder: coder)
        self.window = panel
        setup()
    }

    private func setup() {
        panel.windowController = self
        panel.acceptsMouseMovedEvents = true

        panel.level = NSWindow.Level(rawValue:
            Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
        )

        panel.isOpaque = false
        panel.backgroundColor = NSColor.clear
        panel.styleMask = .nonactivatingPanel
        panel.hidesOnDeactivate = false
        panel.hasShadow = true
        panel.delegate = self
        panel.contentView = backgroundView
        backgroundView.addSubview(containerView)

        containerView.setup()
        containerView.contentView = contentView
        panel.initialFirstResponder = contentView
    }

    func openPopup() {
        openPanel()
    }

    func closePopup() {
        closePanel()
    }

    func togglePopup() {
        isOpen ? closePanel() : openPanel()
    }


    func resizePopup(width: CGFloat, height: CGFloat) {
        var frame = panel.frame
        var newSize = CGSize(width: width,
                             height: height)

        newSize.height += contentInset * 2
        newSize.width += contentInset * 2

        frame.origin.y = ((NSScreen.main?.frame.height ?? height)
            - height)
            - self.yPadding

        frame.size.height = newSize.height

        let widthDifference = newSize.width - frame.size.width
        if widthDifference != 0 {
            frame.size.width = newSize.width
        }

        containerView.resetConstraints()
        panel.setFrame(frame, display: true, animate: panel.isVisible)
    }

    func resizePopup(width: CGFloat) {
        if width != currentWidth {
            currentWidth = width
            resizePopup(width: width, height: contentView.frame.size.height)
        }
    }

    func resizePopup(height: CGFloat) {
        if height != currentHeight {
            currentHeight = height
            resizePopup(width: contentView.frame.size.width, height: height)
        }
    }

    private func openPanel() {
        self.isOpening = true
        willOpenPopup?()
        self.isOpen = true
        self.contentView.isHidden = false
        let panelRect = rect(forPanel: self.panel)

        NSApp.activate(ignoringOtherApps: false)

        self.panel.setFrame(panelRect, display: true)
        self.panel.makeKeyAndOrderFront(self)
        self.panel.alphaValue = 1
        self.isOpening = false
        if self.isOpen {
            self.didOpenPopup?()
            self.panel.makeKeyAndOrderFront(self)
        }
    }

    private func closePanel() {
        willClosePopup?()
        self.isOpen = false
        contentView.isHidden = true
        self.panel.alphaValue = 0
        if !self.isOpen {
            self.panel.orderOut(nil)
            self.didClosePopup?()
        }
    }

    private func rect(forPanel panel: NSPanel) ->  CGRect {
        guard let screen = NSScreen.main
            else { return CGRect.zero }

        let screenRect = screen.frame
        var panelRect = panel.frame

        panelRect.origin.y = screenRect.height - panelRect.height - self.yPadding
        panelRect.origin.x = round(screenRect.midX - panelRect.width / 2)

        if panelRect.maxX > screenRect.maxX {
            panelRect.origin.x -= panelRect.maxX - screenRect.maxX
        }

        return panelRect
    }
}
