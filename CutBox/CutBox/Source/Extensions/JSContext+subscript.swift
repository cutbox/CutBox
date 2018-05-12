//
//  JSContext+subscript.swift
//  CutBox
//
//  Created by Jason on 12/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import JavaScriptCore

extension JSContext {
    subscript(_ get: String) -> JSValue! {
        get {
            return self.objectForKeyedSubscript(get)
        }
        set { fatalError("get: cannot be used to set") }
    }

    subscript(_ set: String) -> Any! {
        set {
            self.setObject(newValue, forKeyedSubscript: set as NSString)
        }
        get { fatalError("set: cannot be used to get") }
    }
}
