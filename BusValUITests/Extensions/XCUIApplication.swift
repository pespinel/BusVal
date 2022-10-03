//
//  XCUIApplication.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

extension XCUIApplication {
    func uninstall(name: String? = nil) {
        terminate()

        let timeout = TimeInterval(5)
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        let appName: String
        if let name = name {
            appName = name
        } else {
            let uiTestRunnerName = Bundle.main.infoDictionary?["CFBundleName"] as! String
            appName = uiTestRunnerName.replacingOccurrences(of: "UITests-Runner", with: "")
        }

        let appIcon = springboard.icons[appName].firstMatch
        if appIcon.waitForExistence(timeout: timeout) {
            appIcon.press(forDuration: 2)
        } else {
            XCTFail("Failed to find app icon named \(appName)")
        }

        let removeAppButton = springboard.buttons["Eliminar app"]
        if removeAppButton.waitForExistence(timeout: timeout) {
            removeAppButton.tap()
        } else {
            XCTFail("Failed to find 'Remove App'")
        }

        let deleteAppButton = springboard.alerts.buttons["Eliminar app"]
        if deleteAppButton.waitForExistence(timeout: timeout) {
            deleteAppButton.tap()
        } else {
            XCTFail("Failed to find 'Delete App'")
        }

        let finalDeleteButton = springboard.alerts.buttons["Eliminar"]
        if finalDeleteButton.waitForExistence(timeout: timeout) {
            finalDeleteButton.tap()
        } else {
            XCTFail("Failed to find 'Delete'")
        }
    }
}
