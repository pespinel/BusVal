//
//  XCTestCase.swift
//  BusValUITests
//
//  Created by Pablo on 18/1/22.
//

import XCTest

extension XCTestCase {
    func dismissOnboarding(app: XCUIApplication) {
        if app.collectionViews["onboardingView"].exists {
            for _ in 1 ... 5 {
                app.staticTexts["onboardingBottomButton"].tap()
            }
        }
    }

    func enableOnboarding(app: XCUIApplication) {
        if !app.collectionViews["onboardingView"].exists {
            app.images["developerSettingsButton"].tap()
            app.switches["onboardingToggle"].tap()
            closeDeveloperSettings(app: app)
        }
    }

    func closeDeveloperSettings(app: XCUIApplication) {
        while app.navigationBars["Developer Settings"].exists {
            app.swipeDown(velocity: .fast)
        }
    }

    func cleanCoreData(app: XCUIApplication) {
        app.images["developerSettingsButton"].tap()
        app.buttons["cleanCoreData"].tap()
        closeDeveloperSettings(app: app)
    }

    func cleanCardStorage(app: XCUIApplication) {
        app.images["developerSettingsButton"].tap()
        app.buttons["cleanCardStorage"].tap()
        closeDeveloperSettings(app: app)
    }
}
