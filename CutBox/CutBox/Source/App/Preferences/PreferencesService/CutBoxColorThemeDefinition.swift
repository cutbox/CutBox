// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cutBoxColorThemeDefinition = try CutBoxColorThemeDefinition(json)

import Foundation
import AppKit.NSColor

extension NSColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    var toHex: String? {
        return toHex()
    }

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                          lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

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
                  popupBackgroundColor: NSColor(hex: theme.popupBackgroundColorRGBA)!,
                  searchText: SearchTextTheme(
                    cursorColor: NSColor(hex: theme.searchText.cursorColorRGBA)!,
                    textColor: NSColor(hex: theme.searchText.textColorRGBA)!,
                    backgroundColor: NSColor(hex: theme.searchText.backgroundColorRGBA)!,
                    placeholderTextColor: NSColor(hex: theme.popupBackgroundColorRGBA)!
                  ),
                  clip: ClipTheme(
                    clipItemsBackgroundColor: NSColor(hex: theme.clip.clipItemsBackgroundColorRGBA)!,
                    clipItemsTextColor: NSColor(hex: theme.clip.clipItemsTextColorRGBA)!,
                    clipItemsHighlightColor: NSColor(hex: theme.clip.clipItemsHighlightColorRGBA)!,
                    clipItemsHighlightTextColor: NSColor(hex: theme.clip.clipItemsHighlightTextColorRGBA)!
                  ),
                  preview: PreviewTheme(
                    textColor: NSColor(hex: theme.preview.textColorRGBA)!,
                    backgroundColor: NSColor(hex: theme.preview.backgroundColorRGBA)!,
                    selectedTextBackgroundColor: NSColor(hex: theme.preview.selectedTextBackgroundColorRGBA)!
                  ),
                  spacing: CGFloat(theme.spacing))
    }
}

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
        do {
            let decoder = JSONDecoder()
            let messages = try decoder.decode(CutBoxColorThemeDefinition.self, from: data)
            print(messages as Any)
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
