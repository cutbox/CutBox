//
//  PopupContainerView.swift
//  CutBox
//
//  Created by Jason Milkins on 31/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

class PopupContainerView: NSView {
    var contentInset: CGFloat = 1

    var contentView: NSView? {
        didSet {
            removeConstraints(constraints)
            guard let contentView = contentView
                else { return }

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
        guard let superview = superview as? PopupBackgroundView
            else { return }

        superview.removeConstraints(superviewConstraints)

        let horizontalFormat = "H:|-\(contentInset)-[containerView]-\(contentInset)-|"
        let verticalFormat = "V:|-\(contentInset)-[containerView]-\(contentInset)-|"

        let horizontalConstraints = NSLayoutConstraint
            .constraints(withVisualFormat: horizontalFormat,
                         options: .directionLeadingToTrailing,
                         metrics: nil,
                         views: ["containerView": self])

        let verticalConstraints = NSLayoutConstraint
            .constraints(withVisualFormat: verticalFormat,
                         options: .directionLeadingToTrailing,
                         metrics: nil,
                         views: ["containerView": self])

        self.superviewConstraints = horizontalConstraints + verticalConstraints
        superview.addConstraints(superviewConstraints)
    }

}
