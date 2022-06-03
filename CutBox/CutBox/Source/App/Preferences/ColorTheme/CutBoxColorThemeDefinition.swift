// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cutBoxColorThemeDefinition = try CutBoxColorThemeDefinition(json)

import Foundation

extension CutBoxColorTheme {
    convenience init(_ json: String) {
        do {
            try self.init(theme: CutBoxColorThemeDefinition(json))
        } catch {
            print("Malformed CutBoxTheme JSON")
            print(json)
            abort()
        }
    }

    convenience init(theme: CutBoxColorThemeDefinition) {
        print("Theme initializing: \(theme.name )")
        print(theme)
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
                    selectedTextBackgroundColor: theme.preview.selectedTextBackgroundColor.color!
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
    let spacing: Int

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
            let decoder = JSONDecoder()
            let messages = try decoder.decode(CutBoxColorThemeDefinition.self, from: data)
            print(messages as Any)

            // For debugging, build and run CutBox from the terminal
            // i.e. $ build/CutBox.app/Contents/MacOS/CutBox
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }

        self = try newJSONDecoder().decode(CutBoxColorThemeDefinition.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        print("JSON Decoded to data:")
        print(data)
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
      spacing: Int? = nil
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

    enum CodingKeys: String, CodingKey {
        case textColor
        case backgroundColor
        case selectedTextBackgroundColor
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
      selectedTextBackgroundColor: String? = nil
    ) -> Preview {
        return Preview(
          textColor: textColor ?? self.textColor,
          backgroundColor: backgroundColor ?? self.backgroundColor,
          selectedTextBackgroundColor: selectedTextBackgroundColor ?? self.selectedTextBackgroundColor
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