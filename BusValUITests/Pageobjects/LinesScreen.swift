//
//  LinesScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct LinesScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let list = "linesList"
    }

    func assertListExists() {
        XCTAssert(app.tables[Identifiers.list].waitForExistence(timeout: 2))
    }

    func tapOnCellByIndex(index: Int) -> LineDetailsScreen {
        let table = app.tables[Identifiers.list]
        let cell = table.cells.element(boundBy: index)
        cell.tap()
        return LineDetailsScreen(app: app)
    }
}
