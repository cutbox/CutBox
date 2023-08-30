//
//  Output.swift
//
//  Created by jason on 31/8/23.
//

import Foundation

public class Output {
    public init() {
    }

    public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Swift.print(items, separator: separator, terminator: terminator)
    }

    public func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let errorOutput = items.map { String(describing: $0) }.joined(separator: separator)
        FileHandle.standardError.write(Data((errorOutput + terminator).utf8))
    }
}
