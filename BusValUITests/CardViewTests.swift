//
//  CardViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class CardViewTests: XCTestCase {
    private var app = XCUIApplication()
    private let card = "Tarjeta"
    private let addCard = "Añadir tarjeta"

    override class func setUp() {
        let app = XCUIApplication()
        app.launch()
        if app.collectionViews["onboardingView"].exists {
            for _ in 1 ... 5 {
                app.staticTexts["onboardingBottomButton"].tap()
            }
        }
        app.images["developerSettingsButton"].tap()
        app.buttons["cleanCardStorage"].tap()
        app.terminate()
        app.launch()
    }

    func testCardTabLoads() {
        app.buttons[card].tap()
        XCTAssertTrue(app.navigationBars[card].exists)
        XCTAssert(app.buttons["addCardButton"].exists)
        XCTAssert(!app.buttons["refreshCardView"].isEnabled)
    }

    func testOpenAddCardSheet() {
        app.buttons[card].tap()
        app.buttons["addCardButton"].tap()
        XCTAssertTrue(app.navigationBars[addCard].exists)
        XCTAssertTrue(app.textFields["addCardTextField"].exists)
        XCTAssertTrue(app.staticTexts["addCardSaveButton"].exists)
    }
}
