//
//  View.swift
//  BusVal
//
//  Created by Pablo on 28/12/21.
//

import SwiftUI

extension View {
    func tabItem(
        _ title: String,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        badgeValue: String? = nil
    ) -> UIKitTabView.TabBarItem {
        UIKitTabView.TabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage,
            badgeValue: badgeValue,
            content: self
        )
    }

    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeView(action: action))
    }
}
