//
//  BusValApp.swift
//  BusVal
//
//  Created by Pablo on 5/1/22.
//

import SwiftUI

// MARK: APP
@main
struct BusValApp: App {
    @AppStorage("firstRun") var firstRun = true

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                gradient
                if firstRun {
                    OnboardingView()
                } else {
                    MainView()
                }
            }.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// MARK: COMPONENTS
extension BusValApp {
    private var gradient: some View {
        RadialGradient(
            gradient: Gradient(colors: [Color.secondary, Color.accentColor]),
            center: .topLeading,
            startRadius: 128,
            endRadius: UIScreen.main.bounds.height
        ).ignoresSafeArea()
    }
}
