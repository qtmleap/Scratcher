//
//  ButtonStyle.swift
//  Scratcher
//
//  Created by devonly on 2025/07/11.
//  Copyright © 2025 QuantumLeap. All rights reserved.
//

import Foundation
import SwiftUI

/// ボタンのバリアント（見た目の種類）を表す列挙型だよ
public enum ButtonVariant {
    /// デフォルトのボタン
    case `default`
    /// 破壊的な操作用のボタン
    case destructive
    /// 枠線だけのアウトラインボタン
    case outline
    /// セカンダリーボタン
    case secondary
    /// ゴーストボタン（背景なし）
    case ghost
    /// リンク風ボタン
    case link

    public func foregroundColor(configuration: ButtonStyleConfiguration) -> Color {
        switch self {
            case .default:
                Shadcn.primaryForeground
            case .destructive:
                Shadcn.destructiveForeground
            case .outline:
                Shadcn.accentForeground
            case .secondary:
                Shadcn.secondaryForeground
            case .ghost:
                configuration.isPressed ? Shadcn.accentForeground : Shadcn.primary
            case .link:
                Shadcn.primary
        }
    }

    public func backgroundColor(configuration: ButtonStyleConfiguration) -> Color {
        switch self {
            case .default:
                Shadcn.primary.opacity(configuration.isPressed ? 0.8 : 1.0)
            case .destructive:
                Shadcn.destructive
            case .outline:
                configuration.isPressed ? Shadcn.accent : Shadcn.background
            case .secondary:
                Shadcn.secondary.opacity(configuration.isPressed ? 0.8 : 1.0)
            case .ghost:
                configuration.isPressed ? Shadcn.accent : .clear
            case .link:
                .clear
        }
    }
}

/// ボタンのサイズを表す列挙型だよ
public enum ButtonSize {
    /// 標準サイズ
    case `default`
    /// 小さいサイズ
    case small
    /// 大きいサイズ
    case large
    /// アイコン用サイズ
    case icon

    /// ボタンのフォントを返すプロパティだよ
    public var font: Font {
        switch self {
            case .default:
                .system(size: 14, weight: .medium)
            case .small:
                .system(size: 12, weight: .medium)
            case .large:
                .system(size: 16, weight: .medium)
            case .icon:
                .system(size: 20, weight: .medium)
        }
    }

    /// ボタンのパディングを返すプロパティだよ
    public var padding: EdgeInsets {
        switch self {
            case .default:
                .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .small:
                .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            case .large:
                .init(top: 0, leading: 32, bottom: 0, trailing: 32)
            case .icon:
                .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }

    /// ボタンの最小高さを返すプロパティだよ
    public var height: CGFloat {
        switch self {
            case .default:
                36
            case .small:
                32
            case .large:
                40
            case .icon:
                36
        }
    }

    /// ボタンの角丸を返すプロパティだよ
    public var cornerRadius: CGFloat {
        switch self {
            case .default, .small, .large:
                6
            case .icon:
                0
        }
    }
}

/// カスタムなボタンスタイルを提供する構造体だよ
public struct ShadcnButtonStyle: ButtonStyle {
    /// ボタンのバリアント
    public let variant: ButtonVariant
    /// ボタンのサイズ
    public let size: ButtonSize

    /// 新しいカスタムボタンスタイルを作るイニシャライザだよ
    /// - Parameters:
    ///   - variant: ボタンのバリアント
    ///   - size: ボタンのサイズ
    public init(variant: ButtonVariant = .default, size: ButtonSize = .default) {
        self.variant = variant
        self.size = size
    }

    /// ボタンの見た目を実際に作る関数だよ
    /// - Parameter configuration: ボタンの設定情報
    /// - Returns: カスタムスタイルのボタンビュー
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .padding(size.padding)
            .frame(height: size.height)
            .background(variant.backgroundColor(configuration: configuration))
            .foregroundColor(variant.foregroundColor(configuration: configuration))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .cornerRadius(size.cornerRadius)
            .if(variant == .outline) { view in
                view.overlay(RoundedRectangle(cornerRadius: size.cornerRadius).stroke(Shadcn.input, lineWidth: 1.5))
            }
            .if(variant == .link) { view in
                view.underline()
            }
    }
}

public extension ButtonStyle where Self == ShadcnButtonStyle {
    /// ShadcnButtonStyleのデフォルトインスタンスを返すよ
    static func shadcn(variant: ButtonVariant, size: ButtonSize) -> ShadcnButtonStyle {
        .init(variant: variant, size: size)
    }
}

/// CustomButtonStyleの全バリアント・全サイズをSwiftUIのGridでプレビューするよ！
///
/// - Note: XcodeのCanvasで開くと、バリアント×サイズの全パターンが一目で見れるよ！
#Preview {
    let variants: [ButtonVariant] = [.default, .destructive, .outline, .secondary, .ghost, .link]
    let sizes: [ButtonSize] = [.default, .small, .large, .icon]

    ScrollView(.horizontal) {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
            // ヘッダー行
            GridRow {
                Text("")
                ForEach(sizes, id: \.self) { size in
                    switch size {
                        case .default: Text("Default")
                        case .small: Text("Small")
                        case .large: Text("Large")
                        case .icon: Text("Icon")
                    }
                }
            }
            // 各バリアントごとに行を作るよ
            ForEach(variants, id: \.self) { variant in
                GridRow {
                    // バリアント名
                    switch variant {
                        case .default: Text("Default")
                        case .destructive: Text("Destructive")
                        case .outline: Text("Outline")
                        case .secondary: Text("Secondary")
                        case .ghost: Text("Ghost")
                        case .link: Text("Link")
                    }
                    // 各サイズごとにボタンを並べるよ
                    ForEach(sizes, id: \.self) { size in
                        if size == .icon {
                            Button(action: {}) {
                                Image(systemName: "star.fill")
                            }
                            .buttonStyle(ShadcnButtonStyle(variant: variant, size: size))
                        } else {
                            Button("Button") {}
                                .buttonStyle(ShadcnButtonStyle(variant: variant, size: size))
                        }
                    }
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
