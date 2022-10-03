//
//  SearchViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class SearchViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
        TabBar(app: app).openSearchTab()
    }

    override func tearDown() {
        super.tearDown()
        SearchScreen(app: app)
            .selectLinesSegment()
            .assertLinesListExists()
    }

    func testSearchViewLoads() {
        SearchScreen(app: app).assertLinesListExists()
    }

    func testSearchTabPicker() {
        SearchScreen(app: app)
            .selectStopsSegment()
            .assertStopsListExists()
    }
}
