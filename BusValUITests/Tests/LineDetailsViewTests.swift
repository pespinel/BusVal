//
//  LineDetailsViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 17/1/22.
//

import XCTest

class LineDetailsViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
    }

    func testLineDetailsViewLoads() {
        for index in 0 ... 9 {
            LinesScreen(app: app)
                .tapOnCellByIndex(index: index)
                .assertNavBarExists(line: index + 1)
                .tapOnBackButton()
        }
    }

    func testLineDetailsViewScheduleSheetLoads() {
        for index in 0 ... 2 {
            LinesScreen(app: app)
                .tapOnCellByIndex(index: index)
                .openScheduleSheet()
                .assertScheduleSheetElementsExist()
                .closeSheet()
                .tapOnBackButton()
        }
    }

    func testLineDetailsViewMapSheetLoads() {
        for index in 0 ... 2 {
            LinesScreen(app: app)
                .tapOnCellByIndex(index: index)
                .openMapSheet()
                .assertMapSheetElementsExist()
                .closeSheet()
                .tapOnBackButton()
        }
    }
}
