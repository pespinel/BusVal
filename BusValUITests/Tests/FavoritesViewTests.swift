//
//  FavoritesViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import XCTest

class FavoritesViewTests: SuperTest {
    private var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        dismissOnboarding(app: app)
        cleanCoreData(app: app)
        TabBar(app: app).openFavoritesTab()
    }

    func testEmptyFavoritesView() {
        FavoritesScreen(app: app)
            .assertFavoritesListDoesNotExist()
            .assertEmptyFavoritesElementsExists()
    }
}
