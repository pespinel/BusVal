//
//  NewsViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class NewsViewTests: XCTestCase {
    private var app: XCUIApplication!
    private let news = "Noticias"

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        if app.collectionViews["onboardingView"].exists {
            for _ in 1 ... 5 {
                app.staticTexts["onboardingBottomButton"].tap()
            }
        }
    }

    func testNewsTabLoads() {
        app.buttons[news].tap()
        XCTAssertTrue(app.navigationBars[news].exists)
        XCTAssert(app.tables["newsList"].waitForExistence(timeout: 2))
    }
}
