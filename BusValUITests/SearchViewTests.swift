//
//  SearchViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class SearchViewTests: XCTestCase {
    private var app: XCUIApplication!
    private let search = "Buscar"

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

    func testSearchTabLoads() {
        app.buttons[search].tap()
        XCTAssertTrue(app.navigationBars[search].exists)
        XCTAssert(app.tables["linesSearchList"].waitForExistence(timeout: 2))
    }

    func testSearchTabPicker() {
        app.buttons[search].tap()
        app.segmentedControls["searchPicker"].buttons["Paradas"].tap()
        XCTAssertTrue(app.tables["stopsSearchList"].waitForExistence(timeout: 2))
        app.segmentedControls["searchPicker"].buttons["Líneas"].tap()
        XCTAssertTrue(app.tables["linesSearchList"].waitForExistence(timeout: 2))
    }
}
