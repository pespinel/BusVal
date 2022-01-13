//
//  MainView.swift
//  BusVal
//
//  Created by Pablo on 02/03/2021.
//

import MapKit
import SFSafeSymbols
import SwiftUI
import UIKit

// MARK: - MainView

struct MainView: View {
    #if DEBUG
        @State var showDeveloperSettings = false
    #endif

    @AppStorage("cardID") var cardID = ""

    @State var selectedTab = 0

    @Environment(\.deeplink) var deeplink

    @ObservedObject var linesStore = LinesStore()
    @ObservedObject var newsStore = NewsStore()
    @ObservedObject var stopsStore = StopsStore()
    @ObservedObject var cardDetailsStore = CardDetailsStore()

    var body: some View {
        UIKitTabView(selection: $selectedTab) {
            LinesView(linesStore: linesStore)
                .tabItem(Constants.Tabs.names[0], image: Constants.Tabs.icons[0])
            NewsView(newsStore: newsStore)
                .tabItem(Constants.Tabs.names[1], image: Constants.Tabs.icons[1])
            SearchView(linesStore: linesStore, stopsStore: stopsStore)
                .tabItem(Constants.Tabs.names[2], image: Constants.Tabs.icons[2])
            CardView(cardDetailsStore: cardDetailsStore)
                .tabItem(Constants.Tabs.names[3], image: Constants.Tabs.icons[3])
            FavoritesView()
                .tabItem(Constants.Tabs.names[4], image: Constants.Tabs.icons[4])
        }
        .tint(.accentColor)
        .onChange(of: deeplink, perform: { _ in
            self.selectedTab = 4
        })
        .onAppear {
            let apparence = UITabBarAppearance()
            apparence.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = apparence
            self.linesStore.fetch()
            self.stopsStore.fetch()
            self.newsStore.fetch()
            if !cardID.isEmpty {
                self.cardDetailsStore.fetch(card: cardID)
            }
        }
        #if DEBUG
            .sheet(isPresented: $showDeveloperSettings) {
                DeveloperSettingsView()
            }
            .onShake {
                showDeveloperSettings.toggle()
            }
        #endif
    }
}

// MARK: - MainView_Previews

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            let persistenceController = PersistenceController.shared

            MainView()
                .previewDevice("iPhone 13 Pro")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
#endif
