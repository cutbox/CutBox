//
//  JSFuncService.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import JavaScriptCore

class JSFuncService {
    static let shared = JSFuncService()

    var filterText: String = ""
    var list: [String] {

        guard let funcsDict: [[String:Any]] = js["cutboxFunctions"].toArray() as? [[String:Any]] else {
            // Notify that cutbox.js isn't valid
            return []
        }

        return funcsDict.map {
            $0["name"] as! String
        }

    }

    var js: JSContext = JSContext()

    var count: Int {
        return self.list.count
    }

    func reload(_ script: String) {
        js = JSContext()
        _ = js.evaluateScript(script)
    }

    func process(_ fnIndex: Int, items: [String]) -> String {
        return js.evaluateScript("cutboxFunctions[\(fnIndex)].fn").call(withArguments: [items]).toString()!
    }
}
