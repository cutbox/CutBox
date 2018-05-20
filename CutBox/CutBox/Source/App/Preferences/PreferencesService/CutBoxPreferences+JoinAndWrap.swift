//
//  CutBoxPreferences+JoinAndWrap.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import JavaScriptCore

extension CutBoxPreferencesService {
    func prepareClips(_ clips: [String], _ useJS: Bool) -> String {
        if useJS {
            return prepareClipsWithJS(clips)
        } else {
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

    typealias CutboxFunction = [String: Any]

    func prepareClipsWithJS(_ clips: [String]) -> String {
        guard let js = JSContext() else { fatalError("Unable to start JS context") }
        js["items"] = clips

        js.evaluateScript(self.javascript)

        guard let value = js["paste"].toString() else {
            let notification = NSUserNotification()
            notification.title = "Javascript Failure"
            notification.informativeText = "Script did not contain paste"
            NSUserNotificationCenter.default.deliver(notification)

            return clips.joined()
        }

        return value
    }
}
