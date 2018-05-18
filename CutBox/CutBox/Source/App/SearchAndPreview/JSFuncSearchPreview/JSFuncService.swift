//
//  JSFuncService.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import JavaScriptCore

class JSFuncService {

    var count: Int {
        return self.list.count
    }

    var list: [[String:Any]] = []

    static let shared = JSFuncService()

    var js: JSContext = JSContext()

    func reload(_ script: String) {
        js = JSContext()

        _ = js.evaluateScript(script)

        guard let funcs: [[String:Any]] = js["cutboxFunctions"].toArray() as? [[String:Any]] else {
            // Notify that cutbox.js isn't valid
            return
        }

        self.list = funcs
    }

    func process(_ fnIndex: Int, items: [String]) -> String {
        return js.evaluateScript("cutboxFunctions[\(fnIndex)].fn").call(withArguments: [items]).toString()!
    }
}
