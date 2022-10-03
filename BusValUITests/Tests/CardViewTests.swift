//
//  CardViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class CardViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
        TabBar(app: app).openLinesTab()
        cleanCardStorage(app: app)
        TabBar(app: app).openCardTab()
    }

    func testEmptyCardView() {
        CardScreen(app: app)
            .assertCardViewElementsExist()
    }

    func testOpenAddCardSheet() {
        CardScreen(app: app)
            .openAddCardSheet()
            .assertAddCardSheetElementsExist()
    }
}
