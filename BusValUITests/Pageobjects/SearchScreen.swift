//
//  SearchScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct SearchScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let linesList = "linesSearchList"
        static let stopsList = "stopsSearchList"
        static let picker = "searchPicker"
    }

    func selectStopsSegment() -> Self {
        let picker = app.segmentedControls[Identifiers.picker]
        picker.buttons["Paradas"].tap()
        return self
    }

    func assertStopsListExists() {
        XCTAssertTrue(app.tables[Identifiers.stopsList].waitForExistence(timeout: 2))
    }

    func selectLinesSegment() -> Self {
        let picker = app.segmentedControls[Identifiers.picker]
        picker.buttons["Líneas"].tap()
        return self
    }

    func assertLinesListExists() {
        XCTAssertTrue(app.tables[Identifiers.linesList].waitForExistence(timeout: 2))
    }
}
