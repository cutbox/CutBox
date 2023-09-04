//
//  JSFuncService.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

// swiftlint:disable identifier_name

import JavaScriptCore

class JSFuncService: NSObject {
    static let shared = JSFuncService()

    let cutboxJSFilename: String = NSString(string: "~/.cutbox.js").expandingTildeInPath

    let require: @convention(block) (String) -> JSValue? = { path in
        let expandedPath = NSString(string: path).expandingTildeInPath

        guard FileManager.default.fileExists(atPath: expandedPath)
            else {
                notifyUser(
                    title: "Require: filename \(expandedPath)",
                    info: " does not exist")
                return nil
        }

        guard let fileContent = getStringFromFile(expandedPath)
            else {
                notifyUser(
                    title: "Cannot read: \(expandedPath)",
                    info: "unknown error processing file")
                return nil
        }

        return JSFuncService.shared.js.evaluateScript(fileContent)
    }

    let shellCommand: @convention(block) (String) -> String = { command in
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    var filterText: String = ""

    var funcs: [(String, Int)] {
        guard let funcsDict: [[String: Any]] = js["cutboxFunctions"]
            .toArray() as? [[String: Any]] else {
                return []
        }

        var idx = 0
        return funcsDict.map { (dict: [String: Any]) -> (String, Int) in
            guard let name = dict["name"] as? String else {
                fatalError("cutboxFunctions invalid: requires an array of {name: String, fn: Function}")
            }
            let index = (name, idx)
            idx += 1
            return index
        }
    }

    var funcList: [String] {
        let names: [String] = funcs.map { (t: (String, Int)) -> String in t.0 }

        if filterText.isEmpty {
            return names
        } else {
            return names.substringSearchFiltered(search: filterText)
        }
    }

    func selected(name: String) -> (String, Int)? {
        guard let found = funcs.first(where: { $0.0 == name })
            else { return nil }
        return found
    }

    var js: JSContext = JSContext()

    var count: Int {
        return self.funcList.count
    }

    var isEmpty: Bool {
        return self.funcList.isEmpty
    }

    var helpers = """
        help = `
        CutBox JS Help:
          cutboxFunctions - Array of loaded functions

        ${ls()}`

        var ls = () => cutboxFunctions.map(e => e.name).join(`\n`)
        var list = () => JSON.stringify(cutboxFunctions, null, 2)
        """

    var noCutboxJSHelp = """
        var help = `CutBox JS Help:\n
          ~/.cutbox.js does not exist\n
        Add and reload to paste through JS.
        See the wiki for more advanced info:
        https://github.com/cutbox/CutBox/wiki`
        """

    func setup() {
        self.js = JSContext()
        self.js["require"] = self.require
        self.js["shellCommand"] = self.shellCommand
    }

    func reload() {
        setup()

        _ = repl(noCutboxJSHelp)

        guard let cutboxJS = getStringFromFile(cutboxJSFilename) else {
            return
        }

        _ = repl(helpers)
        _ = repl(cutboxJS)

        if self.isEmpty {
            notifyUser(title: "Problem with ~/.cutbox.js",
                       info: "cutboxFunctions has no functions")
        } else {
            notifyUser(title: "Javascript loaded",
                       info: "~/.cutbox.js loaded \(self.count) function(s)")
        }
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

func getStringFromFile(_ expandedFilename: String) -> String? {
    guard let fileContent = try? String(contentsOfFile: expandedFilename)
    else { return nil }
    return fileContent
}
