//
//  FavoritesViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class FavoritesViewTests: XCTestCase {
    private var app = XCUIApplication()
    private let favorites = "Favoritos"

    override class func setUp() {
        let app = XCUIApplication()
        app.launch()
        if app.collectionViews["onboardingView"].exists {
            for _ in 1 ... 5 {
                app.staticTexts["onboardingBottomButton"].tap()
            }
        }
        app.images["developerSettingsButton"].tap()
        app.buttons["cleanCoreData"].tap()
        app.terminate()
        app.launch()
    }

    func testFavoritesTabLoads() {
        app.buttons[favorites].tap()
        XCTAssertTrue(app.navigationBars[favorites].exists)
        XCTAssert(!app.tables["favoritesList"].exists)
        XCTAssert(app.staticTexts["emptyFavoritesListTitle"].exists)
        XCTAssert(app.staticTexts["emptyFavoritesListDescription"].exists)
        XCTAssert(app.images["emptyFavoritesListImage"].exists)
    }
}
