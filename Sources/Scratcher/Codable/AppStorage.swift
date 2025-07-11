//
//  AppStorage.swift
//  Scratcher
//
//  Created by devonly on 2025/07/08.
//  Copyright © 2025 QuantumLeap. All rights reserved.
//

import Foundation

/// Array<:Codable>型をRawRepresentableに拡張し、UserDefaultsや@AppStorageで配列を直接保存・復元できるようにします。
/// - Note: ElementはCodableに準拠している必要があります。
/// - SeeAlso: [Swift RawRepresentable](https://developer.apple.com/documentation/swift/rawrepresentable)
extension Array: @retroactive RawRepresentable where Element: Codable {
    /// JSON文字列からArrayを復元します。
    /// - Parameter rawValue: JSON文字列
    /// - Returns: 復元されたArray、失敗時はnil
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    /// ArrayをJSON文字列に変換します。
    /// - Returns: JSON文字列
    public var rawValue: String {
        (try? JSONEncoder().encode(self))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
    }
}

/// Date型をRawRepresentableに拡張し、UserDefaultsや@AppStorageでISO8601文字列として保存・復元できるようにします。
/// - Note: ISO8601DateFormatterはスレッドセーフではないため、毎回インスタンスを生成しています。
/// - SeeAlso: [ISO8601DateFormatter](https://developer.apple.com/documentation/foundation/iso8601dateformatter)
extension Date: @retroactive RawRepresentable {
    /// DateをISO8601形式の文字列に変換します。
    /// - Returns: ISO8601形式の文字列
    public var rawValue: String {
        ISO8601DateFormatter().string(from: self)
    }

    /// ISO8601形式の文字列からDateを復元します。
    /// - Parameter rawValue: ISO8601形式の文字列
    /// - Returns: 復元されたDate、失敗時は現在時刻
    public init?(rawValue: String) {
        self = ISO8601DateFormatter().date(from: rawValue) ?? Date()
    }
}
