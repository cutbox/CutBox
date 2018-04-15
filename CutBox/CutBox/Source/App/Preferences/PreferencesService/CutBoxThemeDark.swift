//
//  CutBoxThemeDark.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferencesService {
    var darkTheme: CutBoxColorTheme {
        return CutBoxColorTheme(
            popupBackgroundColor:            #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1),
            searchText: (
                cursorColor:                 #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1),
                textColor:                   #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1),
                backgroundColor:             #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1),
                placeholderTextColor:        #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)
            ),
            clip: (
                clipItemsBackgroundColor:    #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1),
                clipItemsTextColor:          #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1),
                clipItemsHighlightColor:     #colorLiteral(red: 0.0135, green: 0.02505, blue: 0.03, alpha: 0.4979368398)
            ),
            preview: (
                textColor:                   #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1),
                backgroundColor:             #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1),
                selectedTextBackgroundColor: #colorLiteral(red: 0.0864074271, green: 0.1963072013, blue: 0.2599330357, alpha: 1)
            )
        )
    }
}
