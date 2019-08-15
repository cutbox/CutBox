//
//  VersionService.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

struct VersionService {
    static var version: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] {
            return "version: \(version) (\(buildNumber))"
        }
        return "ERROR: Cannot get version"
    }
}
