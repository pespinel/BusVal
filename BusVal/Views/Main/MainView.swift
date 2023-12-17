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
    @AppStorage("cardID")
    var cardID = ""

    @Environment(\.deeplink)
    var deeplink

    @State var selectedTab = 0

    #if DEBUG
        @State var showDeveloperSettings = false
    #endif

    @ObservedObject var linesStore = LinesStore()
    @ObservedObject var newsStore = NewsStore()
    @ObservedObject var stopsStore = StopsStore()
    @ObservedObject var cardDetailsStore = CardDetailsStore()

    var body: some View {
        UIKitTabView(selection: $selectedTab) {
            LinesView(linesStore: linesStore)
                .accessibility(identifier: "linesTab")
                .tabItem(Constants.Tabs.names[0], image: Constants.Tabs.icons[0])
            NewsView(newsStore: newsStore)
                .accessibility(identifier: "newsTab")
                .tabItem(Constants.Tabs.names[1], image: Constants.Tabs.icons[1])
            SearchView(linesStore: linesStore, stopsStore: stopsStore)
                .accessibility(identifier: "searchTab")
                .tabItem(Constants.Tabs.names[2], image: Constants.Tabs.icons[2])
            MapView(stopsStore: stopsStore)
                .accessibility(identifier: "mapTab")
                .tabItem(Constants.Tabs.names[3], image: Constants.Tabs.icons[3])
            CardView(cardDetailsStore: cardDetailsStore)
                .accessibility(identifier: "cardTab")
                .tabItem(Constants.Tabs.names[4], image: Constants.Tabs.icons[4])
            FavoritesView()
                .accessibility(identifier: "favoritesTab")
                .tabItem(Constants.Tabs.names[5], image: Constants.Tabs.icons[5])
        }
        .tint(.accentColor)
        .onChange(of: deeplink) {
            selectedTab = 4
        }
        .onAppear {
            let apparence = UITabBarAppearance()
            apparence.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = apparence
            linesStore.fetch()
            stopsStore.fetch()
            newsStore.fetch()
            if !cardID.isEmpty {
                cardDetailsStore.fetch(card: cardID)
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
