//
//  DeviceShakeView.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import SwiftUI

// MARK: - DeviceShakeView

struct DeviceShakeView: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}
