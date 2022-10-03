//
//  CardScreen.swift
//  BusValUITests
//
//  Created by Pablo on 20/1/22.
//

import XCTest

struct CardScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let addCardButton = "addCardButton"
        static let refreshCardViewButton = "refreshCardView"
        static let addCardTextField = "addCardTextField"
        static let addCardSaveButton = "addCardSaveButton"
    }

    func openAddCardSheet() -> Self {
        let button = app.buttons[Identifiers.addCardButton]
        let navBar = app.navigationBars["Añadir tarjeta"]
        button.tap()
        XCTAssertTrue(navBar.exists)
        return self
    }

    func assertCardViewElementsExist() {
        let refreshButton = app.buttons[Identifiers.refreshCardViewButton]
        let addCardButton = app.buttons[Identifiers.addCardButton]
        XCTAssert(!refreshButton.isEnabled)
        XCTAssert(addCardButton.exists)
    }

    func assertAddCardSheetElementsExist() {
        let textField = app.textFields[Identifiers.addCardTextField]
        let button = app.staticTexts[Identifiers.addCardSaveButton]
        XCTAssertTrue(textField.exists)
        XCTAssertTrue(button.exists)
    }
}
