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
        guard let funcsDict: [[String:Any]] = js["cutboxFunctions"]
            .toArray() as? [[String:Any]] else {
            // Notify that cutbox.js isn't valid
            return []
        }

        let funcs = funcsDict.map { (dict: [String:Any]) -> (String) in
            guard let name = dict["name"] as? String else {
                return ""
            }
            return name
        }

        if filterText.isEmpty {
            return funcs
        } else {
            return funcs.fuzzySearchRankedFiltered(search: filterText, score: 0.1)
        }
    }

    var js: JSContext = JSContext()

    var count: Int {
        return self.list.count
    }

    var helpers = """

// Javascript helper functions
var cutboxFunctions = []

this.help = () => `
CutBox help:

ls: List your cutboxFunctions
`

this.ls = () => cutboxFunctions.map( e => e.name ).join("\n")

"""

    func reload(_ script: String) {
        js = JSContext()
        _ = js.evaluateScript(helpers)
        _ = js.evaluateScript(script)
    }

    func repl(_ line: String) -> String {
        return js.evaluateScript(line).toString()
    }

//    func process(_ name: String, items: [String]) -> String {
//
//    }

    func process(_ fnIndex: Int, items: [String]) -> String {
        return js.evaluateScript("cutboxFunctions[\(fnIndex)].fn").call(withArguments: [items]).toString()!
    }
}


