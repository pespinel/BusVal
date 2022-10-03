//
//  OnboardingViewTests.swift
//  BusValUITests
//
//  Created by Pablo on 14/1/22.
//

import SwiftUI
import XCTest

class OnboardingViewTests: SuperTest {
    private var app = XCUIApplication()
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

    override func setUp() {
        super.setUp()
        enableOnboarding(app: app)
    }

    func testOnboardingViewLoads() {
        OnboardingScreen(app: app).assertOnboardingViewExists()
    }

    func testOnboardingFlow() {
        for (index, carousel) in carousels.enumerated() {
            OnboardingScreen(app: app)
                .checkOnboardingCarousel(
                    image: carousel["image"]!,
                    title: carousel["title"]!,
                    description: carousel["description"]
                )
                .forwardOnboarding(index: index)
        }
    }
}
