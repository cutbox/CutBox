//
//  NSColor+HexColorString.swift
//  CutBox
//
//  Created by Jason on 30/5/22.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import AppKit.NSColor

extension String {
    var color: NSColor? {
        guard let color = NSColor(hex: self) else {
            return nil
        }
        return color
    }
}

extension NSColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var toHex: String? {
        return toHex()
    }

    var toHexAlpha: String? {
        return toHex(alpha: true)
    }

    func toHex(alpha hasAlpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        var alpha = Float(1.0)
        if components.count >= 4 {
            alpha = Float(components[3])
        }

        if hasAlpha {
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255), lroundf(alpha * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                          lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        }
    }
}
