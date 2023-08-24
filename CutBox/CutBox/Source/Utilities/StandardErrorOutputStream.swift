//
//  StandardError.swift
//
//  Created by Jason Milkins on 23/8/23.
//

import Foundation

public struct StandardErrorOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}

public var errStream = StandardErrorOutputStream()
