//
//  LineDetailsViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 17/1/22.
//

import XCTest

class LineDetailsViewTests: XCTestCase {
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

    func testLineDetailsViewLoads() {
        for lineNumber in 1 ... 3 {
            app.staticTexts["Línea \(lineNumber)"].tap()
            XCTAssert(app.navigationBars["Línea \(lineNumber)"].exists)
            app.navigationBars.buttons[lines].tap()
        }
    }

    func testLineDetailsViewScheduleSheetLoads() {
        for lineNumber in 1 ... 3 {
            app.staticTexts["Línea \(lineNumber)"].tap()
            app.navigationBars.buttons["scheduleButton"].tap()
            XCTAssert(app.navigationBars["Horarios"].exists)
            app.navigationBars.buttons["OK"].tap()
            app.navigationBars.buttons[lines].tap()
        }
    }

    func testLineDetailsViewMapSheetLoads() {
        for lineNumber in 1 ... 3 {
            app.staticTexts["Línea \(lineNumber)"].tap()
            app.navigationBars.buttons["mapButton"].tap()
            XCTAssert(app.navigationBars["Paradas"].exists)
            app.navigationBars.buttons["OK"].tap()
            app.navigationBars.buttons[lines].tap()
        }
    }
}
