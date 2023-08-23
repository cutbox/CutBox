//
//  VersionService.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

enum VersionService {
    static var bundle = Bundle.main

    static var version: String {
        if let version = bundle.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = bundle.infoDictionary?["CFBundleVersion"] {
            return "version: \(version) (\(buildNumber))"
        }
        return "ERROR: Cannot get version"
    }
}
