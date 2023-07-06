//
//  OnboardingScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct OnboardingScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let view = "onboardingView"
        static let image = "onboardingImage"
        static let title = "onboardingTitle"
        static let description = "onboardingDescription"
        static let bottomButton = "onboardingBottomButton"
    }

    func assertOnboardingViewExists() {
        let view = app.collectionViews[Identifiers.view]
        XCTAssertTrue(view.exists)
    }

    func checkOnboardingCarousel(image: String, title: String, description: String? = nil) -> Self {
        checkImage(image: image)
        checkTitle(title: title)
        checkDescription(description: description)
        return Self(app: app)
    }

    func forwardOnboarding(index: Int) {
        let bottomButton = app.staticTexts[Identifiers.bottomButton]
        if index != 4 {
            app.swipeLeft()
        } else {
            bottomButton.tap()
        }
    }

    private func checkImage(image: String) {
        let imageElement = app.images[Identifiers.image]
        XCTAssertTrue(imageElement.exists)
        XCTAssertEqual(imageElement.label, image)
    }

    private func checkTitle(title: String) {
        let titleElement = app.staticTexts[Identifiers.title]
        XCTAssertTrue(titleElement.exists)
        XCTAssertEqual(titleElement.label, title)
    }

    private func checkDescription(description: String?) {
        let descriptionElement = app.staticTexts[Identifiers.description]
        if description != nil {
            XCTAssertTrue(descriptionElement.exists)
            XCTAssertEqual(descriptionElement.label, description)
        } else {
            XCTAssertTrue(!descriptionElement.exists)
        }
    }
}
