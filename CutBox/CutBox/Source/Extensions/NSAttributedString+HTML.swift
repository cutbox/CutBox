//
//  NSAttributedString+HTML.swift
//  CutBox
//
//  Created by Jason Milkins on 15/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Foundation

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
            else { return nil }

        self.init(attributedString: attributedString)
    }
}
