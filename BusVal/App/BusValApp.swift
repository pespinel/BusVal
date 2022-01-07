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

    @State var deeplink: Deeplinker.Deeplink?

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                gradient
                if firstRun {
                    OnboardingView()
                } else {
                    MainView()
                        .environment(\.deeplink, deeplink)
                        .onOpenURL { url in
                            let deeplinker = Deeplinker()
                            guard let deeplink = deeplinker.manage(url: url) else { return }
                            self.deeplink = deeplink
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                self.deeplink = nil
                            }
                        }
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
