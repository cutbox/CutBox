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
            try self.init(theme: CutBoxColorThemeDefinition(json))
        } catch {
            print("Malformed CutBoxTheme JSON", to: &errStream)
            print(json, to: &errStream)
            abort()
        }
    }

    convenience init(theme: CutBoxColorThemeDefinition) {
        print("Theme initializing: \(theme.name )", to: &errStream)

        // print("⟶  \(theme)", to: &errStream)

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

// MARK: - CutBoxColorThemeDefinition
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

// MARK: CutBoxColorThemeDefinition convenience initializers and mutators

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

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
      name: String? = nil,
      popupBackgroundColor: String? = nil,
      searchText: SearchText? = nil,
      clip: Clip? = nil,
      preview: Preview? = nil,
      spacing: CGFloat? = nil
    ) -> CutBoxColorThemeDefinition {
        return CutBoxColorThemeDefinition(
          name: name ?? self.name,
          popupBackgroundColor: popupBackgroundColor ?? self.popupBackgroundColor,
          searchText: searchText ?? self.searchText,
          clip: clip ?? self.clip,
          preview: preview ?? self.preview,
          spacing: spacing ?? self.spacing
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Clip
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

// MARK: Clip convenience initializers and mutators

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

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
      backgroundColor: String? = nil,
      textColor: String? = nil,
      highlightColor: String? = nil,
      highlightTextColor: String? = nil
    ) -> Clip {
        return Clip(
          backgroundColor: backgroundColor ?? self.backgroundColor,
          textColor: textColor ?? self.textColor,
          highlightColor: highlightColor ?? self.highlightColor,
          highlightTextColor: highlightTextColor ?? self.highlightTextColor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Preview
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

// MARK: Preview convenience initializers and mutators

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

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
      textColor: String? = nil,
      backgroundColor: String? = nil,
      selectedTextBackgroundColor: String? = nil,
      selectedTextColor: String? = nil
    ) -> Preview {
        return Preview(
          textColor: textColor ?? self.textColor,
          backgroundColor: backgroundColor ?? self.backgroundColor,
          selectedTextBackgroundColor: selectedTextBackgroundColor ?? self.selectedTextBackgroundColor,
          selectedTextColor: selectedTextColor ?? self.selectedTextColor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SearchText
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

// MARK: SearchText convenience initializers and mutators

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

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
      cursorColor: String? = nil,
      textColor: String? = nil,
      backgroundColor: String? = nil,
      placeholderTextColor: String? = nil
    ) -> SearchText {
        return SearchText(
          cursorColor: cursorColor ?? self.cursorColor,
          textColor: textColor ?? self.textColor,
          backgroundColor: backgroundColor ?? self.backgroundColor,
          placeholderTextColor: placeholderTextColor ?? self.placeholderTextColor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
