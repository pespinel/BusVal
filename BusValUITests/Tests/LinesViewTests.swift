//
//  LinesViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class LinesViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
        TabBar(app: app).openLinesTab()
    }

    func testLinesViewLoads() {
        LinesScreen(app: app).assertListExists()
    }
}
