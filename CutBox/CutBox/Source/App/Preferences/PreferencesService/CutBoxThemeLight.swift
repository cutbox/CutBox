//
//  CutBoxThemeLight.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferencesService {
    var lightTheme: CutBoxColorTheme {
        return  CutBoxColorTheme(
            popupBackgroundColor:            #colorLiteral(red: 0.9489700198, green: 0.9490540624, blue: 0.9488998055, alpha: 1),
            searchText: (
                cursorColor:                 #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                backgroundColor:             #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
                placeholderTextColor:        #colorLiteral(red: 0.624992013, green: 0.625007093, blue: 0.6249989867, alpha: 1)
            ),
            clip: (
                clipItemsBackgroundColor:    #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
                clipItemsTextColor:          #colorLiteral(red: 0.1119977679, green: 0.1119977679, blue: 0.1119977679, alpha: 1),
                clipItemsHighlightColor:     #colorLiteral(red: 0.09438117825, green: 0.1953456035, blue: 0.2386160714, alpha: 0.4979368398)
            ),
            preview: (
                textColor:                   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                backgroundColor:             #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1),
                selectedTextBackgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            )
        )
    }
}
