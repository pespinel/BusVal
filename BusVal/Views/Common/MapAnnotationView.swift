//
//  MapAnnotationView.swift
//  App
//
//  Created by Pablo Espinel on 2/1/22.
//

import SwiftUI

struct MapAnnotationView: View {
    let code: String

    var body: some View {
        NavigationLink(destination: StopDetailsView(stop: code)) {
            VStack(spacing: 0) {
                Image(systemSymbol: .mapCircleFill)
                .font(.title)
                .foregroundColor(.red)
                Image(systemSymbol: .arrowtriangleDownFill)
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
            }
        }
    }
}

#if DEBUG
struct MapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MapAnnotationView(code: "567")
        }
    }
}
#endif
