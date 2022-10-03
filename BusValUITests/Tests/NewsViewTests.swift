//
//  NewsViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class NewsViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
        TabBar(app: app).openNewsTab()
    }

    func testNewsViewLoads() {
        NewsScreen(app: app).assertListExists()
    }
}
