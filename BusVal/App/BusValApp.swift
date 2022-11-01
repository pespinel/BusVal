//
//  BusValApp.swift
//  BusVal
//
//  Created by Pablo on 5/1/22.
//

import Firebase
import SwiftUI
import UIKit
import WidgetKit

// MARK: - BusValApp

@main
struct BusValApp: App {
    @AppStorage("firstRun") var firstRun = true
    @AppStorage("uid") var uid = String()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                            guard let deeplink = deeplinker.manage(url: url) else {
                                return
                            }
                            self.deeplink = deeplink
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                self.deeplink = nil
                            }
                        }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onAppear {
                WidgetCenter.shared.reloadAllTimelines()
                Auth.auth().signInAnonymously { authResult, _ in
                    guard let user = authResult?.user else {
                        return
                    }
                    self.uid = user.uid
                }
            }
        }
    }
}

// MARK: COMPONENTS

extension BusValApp {
    private var gradient: some View {
        RadialGradient(
            gradient: Gradient(colors: [.secondary, .accentColor]),
            center: .topLeading,
            startRadius: 128,
            endRadius: UIScreen.main.bounds.height
        ).ignoresSafeArea()
    }
}
