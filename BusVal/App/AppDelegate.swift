//
//  AppDelegate.swift
//  BusVal
//
//  Created by Pablo on 13/1/22.
//

import Firebase
import UIKit

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 1)
        return true
    }
}
