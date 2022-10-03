//
//  TabBar.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct TabBar: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let linesTab = "Líneas"
        static let newsTab = "Noticias"
        static let searchTab = "Buscar"
        static let cardTab = "Tarjeta"
        static let favsTab = "Favoritos"
    }

    func openLinesTab() {
        app.buttons[Identifiers.linesTab].tap()
        XCTAssertTrue(app.navigationBars["Líneas"].exists)
    }

    func openNewsTab() {
        app.buttons[Identifiers.newsTab].tap()
        XCTAssertTrue(app.navigationBars["Noticias"].exists)
    }

    func openSearchTab() {
        app.buttons[Identifiers.searchTab].tap()
        XCTAssertTrue(app.navigationBars["Buscar"].exists)
    }

    func openCardTab() {
        app.buttons[Identifiers.cardTab].tap()
        XCTAssertTrue(app.navigationBars["Tarjeta"].exists)
    }

    func openFavoritesTab() {
        app.buttons[Identifiers.favsTab].tap()
        XCTAssertTrue(app.navigationBars["Favoritos"].exists)
    }
}
