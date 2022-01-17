//
//  LinesViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class LinesViewTests: XCTestCase {
    private var app: XCUIApplication!
    private let lines = "Líneas"

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

    func testLinesTabLoads() {
        XCTAssertTrue(app.navigationBars[lines].exists)
        XCTAssert(app.tables["linesList"].waitForExistence(timeout: 2))
    }
}
