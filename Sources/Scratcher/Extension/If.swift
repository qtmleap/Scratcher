//
//  If.swift
//  Scratcher
//
//  Created by devonly on 2025/07/11.
//  Copyright © 2025 QuantumLeap. All rights reserved.
//

import SwiftUI

/// 条件付きでViewModifierを適用する拡張だよ
/// - Parameters:
///   - condition: 条件
///   - transform: 条件がtrueのときに適用する変換
/// - Returns: 変換後のView
extension View {
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            return AnyView(transform(self))
        } else {
            return AnyView(self)
        }
    }
}
