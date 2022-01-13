//
//  ProgressBarView.swift
//  BusVal
//
//  Created by Pablo Espinel on 26/12/21.
//

import SwiftUI

// MARK: - ProgressBarView

struct ProgressBarView: View {
    @Binding var value: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle()
                    .frame(
                        width: min(Double(self.value) * geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(Animation.linear, value: value)
            }.cornerRadius(45.0)
        }
    }
}

#if DEBUG
    struct ProgressBarView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                VStack {
                    ProgressBarView(value: .constant(80))
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                }.padding()
            }
        }
    }
#endif
