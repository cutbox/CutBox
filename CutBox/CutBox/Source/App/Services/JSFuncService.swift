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

    var funcs: [(String,Int)] {
        guard let funcsDict: [[String:Any]] = js["cutboxFunctions"]
            .toArray() as? [[String:Any]] else {
                // Notify that cutbox.js isn't valid
                return []
        }

        var idx = 0
        return funcsDict.map { (dict: [String:Any]) -> (String, Int) in
            guard let name = dict["name"] as? String else {
                fatalError("cutboxFunctions invalid: requires an array of {name: String, fn: Function}")
            }
            let index = (name, idx)
            idx += 1
            return index
        }
    }

    var list: [String] {
        let names: [String] = funcs.map { (t:(String,Int)) -> String in t.0 }

        if filterText.isEmpty {
            return names
        } else {
            return names.fuzzySearchRankedFiltered(search: filterText, score: 0.1)
        }
    }

    func selected(name: String) -> (String,Int)? {
        guard let found = funcs.first(where: { (s:(String,Int)) -> Bool in s.0 == name })
            else { return nil }
        return found
    }

    var js: JSContext = JSContext()

    var count: Int {
        return self.list.count
    }

    var helpers = "var help = `- CutBox JS REPL-\nhelp:\nls() - List your cutboxFunctions`;" +
    "var ls = () => cutboxFunctions.map(e => e.name).join(`\n`);" +
    "var list = () => JSON.stringify(cutboxFunctions, null, 2);"

    func reload(_ script: String) {
        js = JSContext()
        _ = repl(helpers)
        _ = repl(script)
    }

    func repl(_ line: String) -> String {
        return js.evaluateScript(line).toString()
    }

    func process(_ name: String, items: [String]) -> String {
        guard let index = selected(name: name)?.1
            else { return "" }
        return self.process(index, items: items)
    }

    func process(_ fnIndex: Int, items: [String]) -> String {
        return js.evaluateScript("cutboxFunctions[\(fnIndex)].fn").call(withArguments: [items]).toString()!
    }
}


