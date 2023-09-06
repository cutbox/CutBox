//
//  JSContext+subscript.swift
//  CutBox
//
//  Created by Jason Milkins on 12/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import JavaScriptCore

extension JSContext {
    subscript(_ get: String) -> JSValue! {
        return self.objectForKeyedSubscript(get)
    }

    subscript(_ set: String) -> Any! {
        get { fatalError("unreachable code") }
        set {
            self.setObject(newValue, forKeyedSubscript: set as NSString)
        }
    }
}

