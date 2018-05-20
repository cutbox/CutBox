//
//  CutBoxPreferences+JoinAndWrap.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import JavaScriptCore

extension CutBoxPreferencesService {
    func prepareClips(_ clips: [String]) -> String {
        if clips.count == 1 {
            return clips.first!
        }

        var clip = clips.joined(separator: "\n")

        if useJoinString {
            clip = clips.joined(separator: multiJoinString ?? "")
        }

        if useWrappingStrings {
            let (start, end) = wrappingStrings
            clip = "\(start ?? "")\(clip)\(end ?? "")"
        }

        return clip
    }
}
