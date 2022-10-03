//
//  FavoritesScreen.swift
//  BusValUITests
//
//  Created by Pablo on 19/1/22.
//

import XCTest

struct FavoritesScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let list = "favoritesList"
        static let emptyTitle = "emptyFavoritesListTitle"
        static let emptyDescription = "emptyFavoritesListDescription"
        static let emptyImage = "emptyFavoritesListImage"
    }

    func assertFavoritesListDoesNotExist() -> Self {
        XCTAssert(!app.tables[Identifiers.list].exists)
        return self
    }

    func assertEmptyFavoritesElementsExists() {
        XCTAssert(app.staticTexts[Identifiers.emptyTitle].exists)
        XCTAssert(app.staticTexts[Identifiers.emptyDescription].exists)
        XCTAssert(app.images[Identifiers.emptyImage].exists)
    }
}
