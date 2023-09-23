//
//  JSFuncService.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import JavaScriptCore

class JSFuncService: NSObject {
    static var context: JSContext = JSContext()

    var prefs: CutBoxPreferencesService!

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

        return JSFuncService.context.evaluateScript(fileContent)
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

    let shell: @convention(block)
    (String, String?) -> [String] = { command, stdin -> [String] in
        let task = Process()

        if let stdinString = stdin {
            let stdinPipe = Pipe()
            task.standardInput = stdinPipe
            if let stdinData = stdinString.data(using: .utf8) {
                stdinPipe.fileHandleForWriting.write(stdinData)
                stdinPipe.fileHandleForWriting.closeFile()
            }
        }

        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        task.standardOutput = stdoutPipe
        task.standardError = stderrPipe

        do {
            try task.run()
        } catch {
            return ["", "Error running: shell(command: \(command), stdin: \(String(describing: stdin))"]
        }

        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderr = String(data: stderrData, encoding: .utf8) ?? ""

        return [stdout, stderr]
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

    var js: JSContext = JSFuncService.context

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
        self.js["require"] = self.require
        self.js["shellCommand"] = self.shellCommand
        self.js["shell"] = self.shell
    }

    func reload() {
        setup()

        repl(noCutboxJSHelp)
        let cutBoxJSLocation = prefs.cutBoxJSLocation

        guard let cutboxJS = getStringFromFile(cutBoxJSLocation) else {
            return
        }

        repl(helpers)
        repl(cutboxJS)

        if self.isEmpty {
            notifyUser(title: "Problem in cutbox js",
                       info: "Error: no function objects in cutboxFunctions")
        } else {
            notifyUser(title: "Javascript loaded",
                       info: "cutbox js loaded \(self.count) function(s)")
        }
    }

    @discardableResult
    func repl(_ line: String) -> String {
        return js.evaluateScript(line).toString()
    }

    func replValue(_ line: String) -> JSValue? {
        return js.evaluateScript(line)
    }

    func process(_ name: String, items: [String]) -> String {
        guard let index = selected(name: name)?.1
            else { return "" }
        return self.process(index, items: items)
    }

    func process(_ fnIndex: Int, items: [String]) -> String {
        return js.evaluateScript("cutboxFunctions[\(fnIndex)].fn")
            .call(withArguments: [items]).toString()!
    }
}

func getStringFromFile(_ expandedFilename: String) -> String? {
    guard let fileContent = try? String(contentsOfFile: expandedFilename)
    else { return nil }
    return fileContent
}
