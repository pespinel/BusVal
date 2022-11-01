//
//  FavoritesView.swift
//  BusVal
//
//  Created by Pablo on 20/8/21.
//

import SkeletonUI
import SwiftUI
import WidgetKit

// MARK: - FavoritesView

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.deeplink) var deeplink

    @State var stopCodeDeeplink = ""
    @State var showDeeplink = false

    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.code)
    ]) var favoriteStops: FetchedResults<FavoriteStop>

    var body: some View {
        NavigationView {
            VStack {
                if favoriteStops.isEmpty {
                    emptyFavorites
                } else {
                    favoritesList
                }
                NavigationLink(destination: StopDetailsView(stop: stopCodeDeeplink), isActive: $showDeeplink) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Favoritos", displayMode: .large)
            .onChange(of: deeplink) { _ in
                guard let deeplink = deeplink else {
                    return
                }
                let strCode = String(describing: deeplink)
                    .replacingOccurrences(of: "details(code: \"", with: "")
                    .replacingOccurrences(of: "\")", with: "")
                if strCode.isEmpty {
                    return
                } else {
                    self.stopCodeDeeplink = strCode
                    self.showDeeplink = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            registerScreen(view: "FavoritesView")
        }
    }
}

// MARK: Components

extension FavoritesView {
    private var emptyFavorites: some View {
        VStack {
            Spacer()
            Text("Todavía no tienes paradas favoritas")
                .accessibility(identifier: "emptyFavoritesListTitle")
                .font(.title2)
                .padding()
            Text("Añade tus paradas favoritas desde la vista de detalles de parada usando el icono:")
                .accessibility(identifier: "emptyFavoritesListDescription")
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()
            Image(systemSymbol: .heart)
                .renderingMode(.original)
                .imageScale(.large)
                .padding()
                .accessibility(identifier: "emptyFavoritesListImage")
            Spacer()
        }
    }

    private var favoritesList: some View {
        List {
            ForEach(favoriteStops) { stop in
                NavigationLink(destination: StopDetailsView(stop: stop.code)) {
                    HStack {
                        Image(
                            systemSymbol: .grid)
                            .imageScale(.large)
                            .font(.body)
                            .padding(.trailing)
                            .foregroundColor(.accentColor)
                        VStack(alignment: .leading) {
                            Text("Parada \(stop.code)").bold()
                            Text(stop.name)
                        }
                    }
                }.padding([.top, .bottom])
            }.onDelete(perform: delete)
        }
        .listStyle(PlainListStyle())
        .accessibility(identifier: "favoritesList")
        .toolbar { EditButton() }
    }
}

// MARK: Methods

extension FavoritesView {
    private func delete(offsets: IndexSet) {
        do {
            offsets.forEach { index in
                self.context.delete(favoriteStops[index])
            }
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Error removing favorite")
        }
    }
}

// MARK: - FavoritesView_Previews

#if DEBUG
    struct FavoritesView_Previews: PreviewProvider {
        static var previews: some View {
            let persistenceController = PersistenceController.shared
            TabView {
                FavoritesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemSymbol: .listDash)
                        Text("Preview")
                    }
            }
        }
    }
#endif
