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

// MARK: VIEW
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
        TabView(selection: $selectedTab) {
            LinesView(linesStore: linesStore)
                .tabItem {
                    Text(Constants.Tabs.names[0])
                    Image(uiImage: Constants.Tabs.icons[0])
                }
                .tag(0)
            NewsView(newsStore: newsStore)
                .tabItem {
                    Text(Constants.Tabs.names[1])
                    Image(uiImage: Constants.Tabs.icons[1])
                }
                .tag(1)
            SearchView(linesStore: linesStore, stopsStore: stopsStore)
                .tabItem {
                    Text(Constants.Tabs.names[3])
                    Image(uiImage: Constants.Tabs.icons[3])
                }
                .tag(2)
            CardView(cardDetailsStore: cardDetailsStore)
                .tabItem {
                    Text("Tarjeta")
                    Image(systemSymbol: .creditcard)
                }
                .tag(3)
            FavoritesView()
                .tabItem {
                    Text(Constants.Tabs.names[4])
                    Image(uiImage: Constants.Tabs.icons[4])
                }
                .tag(4)
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

// MARK: PREVIEW
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
