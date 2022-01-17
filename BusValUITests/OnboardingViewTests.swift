//
//  OnboardingViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import SwiftUI
import XCTest

class OnboardingViewTests: XCTestCase {
    private var app: XCUIApplication!
    private let carousels = [
        [
            "image": "bus.doubledecker",
            "title": "Bienvenid@ a BusVal"
        ],
        [
            "image": "Timer",
            "title": "Consulta tiempos",
            "description": "Consulta los tiempos para todas las paradas de Auvasa"
        ],
        [
            "image": "app.connected.to.app.below.fill",
            "title": "Consulta líneas",
            "description": "Consulta las líneas y sus recorridos"
        ],
        [
            "image": "Show Map",
            "title": "Mapa",
            "description": "Busca entre todas las paradas en el mapa"
        ],
        [
            "image": "Medical Id",
            "title": "Favoritos",
            "description": "Guarda paradas en favoritos para acceder rápidamente a ellas"
        ]
    ]

    private func checkOnboardingCarousel(image: String, title: String, description: String? = nil) {
        XCTAssertTrue(app.images["onboardingImage"].exists)
        XCTAssertEqual(app.images["onboardingImage"].label, image)
        XCTAssertTrue(app.staticTexts["onboardingTitle"].exists)
        XCTAssertEqual(app.staticTexts["onboardingTitle"].label, title)
        if description != nil {
            XCTAssertTrue(app.staticTexts["onboardingDescription"].exists)
            XCTAssertEqual(app.staticTexts["onboardingDescription"].label, description)
        } else {
            XCTAssertTrue(!app.staticTexts["onboardingDescription"].exists)
        }
    }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        if !app.collectionViews["onboardingView"].exists {
            app.images["developerSettingsButton"].tap()
            app.switches["onboardingToggle"].tap()
            app.terminate()
            app.launch()
        }
    }

    func testOnboardingLoads() {
        XCTAssertTrue(app.collectionViews["onboardingView"].exists)
    }

    func testOnboardingFlow() {
        for (index, carousel) in carousels.enumerated() {
            checkOnboardingCarousel(
                image: carousel["image"]!,
                title: carousel["title"]!,
                description: carousel["description"]
            )
            if index != carousels.count - 1 {
                app.swipeLeft()
            }
        }
    }

    func testOnboardingFlowCompletion() {
        for _ in carousels {
            app.staticTexts["onboardingBottomButton"].tap()
        }
        XCTAssertTrue(app.navigationBars["Líneas"].exists)
    }
}
