import Foundation

public func diffStrings(_ string1: String, _ string2: String) {
    let length = max(string1.count, string2.count)
    var diffResult = ""

    for i in 0..<length {
        let char1 = i < string1.count ? string1[string1.index(string1.startIndex, offsetBy: i)] : " "
        let char2 = i < string2.count ? string2[string2.index(string2.startIndex, offsetBy: i)] : " "

        if char1 == char2 {
            diffResult.append(" ")
        } else {
            diffResult.append("^")
        }
    }

    print(diffResult)
}

public enum FileHelpers {
    public static func findFullPathAsync(forFilename name: String, atPath path: String) async throws -> String {
        let fm = FileManager.default
        var queue = [path]

        while !queue.isEmpty {
            let currentPath = queue.removeFirst()
            do {
                let entries = try fm.contentsOfDirectory(atPath: currentPath)
                for entry in entries {
                    let fullPath = "\(currentPath)/\(entry)"
                    if fm.fileExists(atPath: fullPath) {
                        if entry == name {
                            return fullPath
                        } else if (try? fm
                                     .attributesOfItem(atPath: fullPath))?[.type] as?
                                    FileAttributeType == .typeDirectory {
                            queue.append(fullPath)
                        }
                    }
                }
            } catch {
                throw error
            }
        }

        let errorDomain = "info.ocodo.CutBox"
        let errorCode = 404
        let errorDescription = "File '\(name)' not found below path '\(path)'"
        throw NSError(domain: errorDomain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])
    }

    public static func findFullPath(forFilename name: String, atPath path: String) -> String? {
        let fm = FileManager.default
        do {
            let entries = try fm.contentsOfDirectory(atPath: path)
            for entry in entries {
                let fullPath = "\(path)/\(entry)"
                print(fullPath)
                var isDirectory: ObjCBool = false
                if fm.fileExists(atPath: fullPath,
                                 isDirectory: &isDirectory) {
                    if entry == name {
                        return fullPath
                    } else if isDirectory.boolValue {
                        if let matchingPath = FileHelpers.findFullPath(forFilename: name,
                                                                       atPath: fullPath) {
                            return matchingPath
                        }
                    }
                }
            }
            return nil
        } catch {
            return nil
        }
    }
}
