//
//  CutBoxColorThemeDefinition.swift
//  CutBox
//
//  Created by Jason Milkins on 13/6/22.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension CutBoxColorTheme {

    convenience init(name: String, theme: CutBoxColorTheme) {
        self.init(name: name,
                  popupBackgroundColor: theme.popupBackgroundColor,
                  searchText: theme.searchText,
                  clip: theme.clip,
                  preview: theme.preview,
                  spacing: theme.spacing
        )
    }

    convenience init(_ json: String) {
        do {
            self.init(theme: try CutBoxColorThemeDefinition(json))
        } catch { fatalError("CutBoxTheme invalid: \(json)")}
    }

    convenience init(theme: CutBoxColorThemeDefinition) {
        print("Theme initializing: \(theme.name )", to: &errStream)

        self.init(name: theme.name,
                  popupBackgroundColor: theme.popupBackgroundColor.color!,
                  searchText: SearchTextTheme(
                    cursorColor: theme.searchText.cursorColor.color!,
                    textColor: theme.searchText.textColor.color!,
                    backgroundColor: theme.searchText.backgroundColor.color!,
                    placeholderTextColor: theme.searchText.placeholderTextColor.color!
                  ),
                  clip: ClipTheme(
                    backgroundColor: theme.clip.backgroundColor.color!,
                    textColor: theme.clip.textColor.color!,
                    highlightColor: theme.clip.highlightColor.color!,
                    highlightTextColor: theme.clip.highlightTextColor.color!
                  ),
                  preview: PreviewTheme(
                    textColor: theme.preview.textColor.color!,
                    backgroundColor: theme.preview.backgroundColor.color!,
                    selectedTextBackgroundColor: theme.preview.selectedTextBackgroundColor.color!,
                    selectedTextColor: theme.preview.selectedTextColor.color!
                  ),
                  spacing: CGFloat(theme.spacing))
    }
}

struct CutBoxColorThemeDefinition: Codable {
    let name: String
    let popupBackgroundColor: String
    let searchText: SearchText
    let clip: Clip
    let preview: Preview
    let spacing: CGFloat

    enum CodingKeys: String, CodingKey {
        case name
        case popupBackgroundColor
        case searchText
        case clip
        case preview
        case spacing
    }
}

extension CutBoxColorThemeDefinition {
    init(data: Data) throws {
        do {
            _ = try newJSONDecoder()
              .decode(CutBoxColorThemeDefinition.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            print(context, to: &errStream)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription, to: &errStream)
            print("codingPath:", context.codingPath, to: &errStream)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription, to: &errStream)
            print("codingPath:", context.codingPath, to: &errStream)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription, to: &errStream)
            print("codingPath:", context.codingPath, to: &errStream)
        } catch {
            print("error: ", error, to: &errStream)
        }
        self = try newJSONDecoder()
            .decode(CutBoxColorThemeDefinition.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

struct Clip: Codable {
    let backgroundColor: String
    let textColor: String
    let highlightColor: String
    let highlightTextColor: String

    enum CodingKeys: String, CodingKey {
        case backgroundColor
        case textColor
        case highlightColor
        case highlightTextColor
    }
}

extension Clip {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Clip.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

struct Preview: Codable {
    let textColor: String
    let backgroundColor: String
    let selectedTextBackgroundColor: String
    let selectedTextColor: String

    enum CodingKeys: String, CodingKey {
        case textColor
        case backgroundColor
        case selectedTextBackgroundColor
        case selectedTextColor
    }
}

extension Preview {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Preview.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

struct SearchText: Codable {
    let cursorColor: String
    let textColor: String
    let backgroundColor: String
    let placeholderTextColor: String

    enum CodingKeys: String, CodingKey {
        case cursorColor
        case textColor
        case backgroundColor
        case placeholderTextColor
    }
}

extension SearchText {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchText.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
