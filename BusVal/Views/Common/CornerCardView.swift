//
//  CornerCardView.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import SwiftUI

// MARK: - CornerCardView

struct CornerCardView: View {
    var title: String
    var description: String

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .padding(.bottom)
                    Text(description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

// MARK: - CardView_Previews

#if DEBUG
    struct CornerCardView_Previews: PreviewProvider {
        static var previews: some View {
            CornerCardView(title: "Title", description: "Description")
        }
    }
#endif
