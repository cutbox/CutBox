//
//  String+L10n.swift
//  CutBox
//
//  Created by Jason on 15/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension String {
    var l10n: String {
        return NSLocalizedString(self, comment: "")
    }
}
