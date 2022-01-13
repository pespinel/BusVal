//
//  TextFieldClearButton.swift
//  BusVal
//
//  Created by Pablo on 11/1/22.
//

import SwiftUI

// MARK: - TextFieldClearButton

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemSymbol: .clearFill)
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}
