// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cutBoxColorThemeDefinition = try CutBoxColorThemeDefinition(json)

import Foundation

// MARK: - CutBoxColorThemeDefinition
struct CutBoxColorThemeDefinition: Codable {
    let name: String
    let popupBackgroundColorRGBA: String
    let searchText: SearchText
    let clip: Clip
    let preview: Preview
    let spacing: Int

    enum CodingKeys: String, CodingKey {
        case name
        case popupBackgroundColorRGBA
        case searchText
        case clip
        case preview
        case spacing
    }
}

// MARK: CutBoxColorThemeDefinition convenience initializers and mutators

extension CutBoxColorThemeDefinition {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CutBoxColorThemeDefinition.self, from: data)
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
        popupBackgroundColorRGBA: String? = nil,
        searchText: SearchText? = nil,
        clip: Clip? = nil,
        preview: Preview? = nil,
        spacing: Int? = nil
    ) -> CutBoxColorThemeDefinition {
        return CutBoxColorThemeDefinition(
            name: name ?? self.name,
            popupBackgroundColorRGBA: popupBackgroundColorRGBA ?? self.popupBackgroundColorRGBA,
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
    let clipItemsBackgroundColorRGBA: String
    let clipItemsTextColorRGBA: String
    let clipItemsHighlightColorRGBA: String
    let clipItemsHighlightTextColorRGBA: String

    enum CodingKeys: String, CodingKey {
        case clipItemsBackgroundColorRGBA
        case clipItemsTextColorRGBA
        case clipItemsHighlightColorRGBA
        case clipItemsHighlightTextColorRGBA
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
        clipItemsBackgroundColorRGBA: String? = nil,
        clipItemsTextColorRGBA: String? = nil,
        clipItemsHighlightColorRGBA: String? = nil,
        clipItemsHighlightTextColorRGBA: String? = nil
    ) -> Clip {
        return Clip(
            clipItemsBackgroundColorRGBA: clipItemsBackgroundColorRGBA ?? self.clipItemsBackgroundColorRGBA,
            clipItemsTextColorRGBA: clipItemsTextColorRGBA ?? self.clipItemsTextColorRGBA,
            clipItemsHighlightColorRGBA: clipItemsHighlightColorRGBA ?? self.clipItemsHighlightColorRGBA,
            clipItemsHighlightTextColorRGBA: clipItemsHighlightTextColorRGBA ?? self.clipItemsHighlightTextColorRGBA
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
    let textColorRGBA: String
    let backgroundColorRGBA: String
    let selectedTextBackgroundColorRGBA: String

    enum CodingKeys: String, CodingKey {
        case textColorRGBA
        case backgroundColorRGBA
        case selectedTextBackgroundColorRGBA
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
        textColorRGBA: String? = nil,
        backgroundColorRGBA: String? = nil,
        selectedTextBackgroundColorRGBA: String? = nil
    ) -> Preview {
        return Preview(
            textColorRGBA: textColorRGBA ?? self.textColorRGBA,
            backgroundColorRGBA: backgroundColorRGBA ?? self.backgroundColorRGBA,
            selectedTextBackgroundColorRGBA: selectedTextBackgroundColorRGBA ?? self.selectedTextBackgroundColorRGBA
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
    let cursorColorRGBA: String
    let textColorRGBA: String
    let backgroundColorRGBA: String
    let placeholderTextColorRGBA: String

    enum CodingKeys: String, CodingKey {
        case cursorColorRGBA
        case textColorRGBA
        case backgroundColorRGBA
        case placeholderTextColorRGBA
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
        cursorColorRGBA: String? = nil,
        textColorRGBA: String? = nil,
        backgroundColorRGBA: String? = nil,
        placeholderTextColorRGBA: String? = nil
    ) -> SearchText {
        return SearchText(
            cursorColorRGBA: cursorColorRGBA ?? self.cursorColorRGBA,
            textColorRGBA: textColorRGBA ?? self.textColorRGBA,
            backgroundColorRGBA: backgroundColorRGBA ?? self.backgroundColorRGBA,
            placeholderTextColorRGBA: placeholderTextColorRGBA ?? self.placeholderTextColorRGBA
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
