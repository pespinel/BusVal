//
//  NewsScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct NewsScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let list = "newsList"
    }

    func assertListExists() {
        XCTAssert(app.tables[Identifiers.list].waitForExistence(timeout: 2))
    }
}
