//
//  LineDetailsScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct LineDetailsScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let scheduleButton = "scheduleButton"
        static let mapButton = "mapButton"
    }

    func assertNavBarExists(line: Int) -> Self {
        XCTAssert(app.navigationBars["Línea \(line)"].exists)
        return self
    }

    func tapOnBackButton() {
        app.navigationBars.buttons["Líneas"].tap()
    }

    func openScheduleSheet() -> Self {
        app.navigationBars.buttons["scheduleButton"].tap()
        return self
    }

    func assertScheduleSheetElementsExist() -> Self {
        XCTAssert(app.navigationBars["Horarios"].exists)
        return self
    }

    func openMapSheet() -> Self {
        app.navigationBars.buttons["mapButton"].tap()
        return self
    }

    func assertMapSheetElementsExist() -> Self {
        XCTAssert(app.navigationBars["Paradas"].exists)
        return self
    }

    func closeSheet() -> Self {
        app.navigationBars.buttons["OK"].tap()
        return self
    }
}
