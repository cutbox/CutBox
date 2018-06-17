//
//  String+L10n.swift
//  CutBox
//
//  Created by Jason on 15/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension String {

    var l7n: String {
        return self.l10n()
    }

    func l10n(tableName: String? = nil,
              bundle: Bundle = Bundle.main,
              value: String = "",
              comment: String = "") -> String {
        return NSLocalizedString(self,
                                 tableName: tableName,
                                 bundle: bundle,
                                 value: value,
                                 comment: comment)
    }

}
