//
//  UIWindow.swift
//  BusVal
//
//  Created by Pablo on 30/12/21.
//

import UIKit

// swiftlint:disable override_in_extension
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
