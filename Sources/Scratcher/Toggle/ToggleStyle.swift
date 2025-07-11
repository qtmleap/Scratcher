//
//  ToggleStyle.swift
//  Scratcher
//
//  Created by devonly on 2025/07/11.
//  Copyright © 2025 QuantumLeap. All rights reserved.
//

import SwiftUI

public struct ShadcnToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }

            configuration.label
        }
    }
}

public extension ToggleStyle where Self == ShadcnToggleStyle {
    static var shadcn: ShadcnToggleStyle {
        .init()
    }
}

struct CheckboxPreviewWrapper: View {
    @State private var isOn = true

    var body: some View {
        ScrollView {
            Toggle("Checkbox 1", isOn: $isOn)
                .toggleStyle(.button)
            Toggle("Checkbox 2", isOn: $isOn)
                .toggleStyle(.switch)
            Toggle("Checkbox 3", isOn: $isOn)
                .toggleStyle(.shadcn)
        }
        .padding()
    }
}

#Preview {
    CheckboxPreviewWrapper()
}
