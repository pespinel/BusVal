//
//  FavoritesView.swift
//  BusVal
//
//  Created by Pablo on 20/8/21.
//

import SkeletonUI
import SwiftUI

// MARK: VIEWS
struct FavoritesView: View {
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: FavoriteStop.entity(),
        sortDescriptors: []
    )

    var favoriteStops: FetchedResults<FavoriteStop>

    var body: some View {
        NavigationView {
            VStack {
                if favoriteStops.isEmpty {
                    emptyFavorites
                } else {
                    favoritesList
                }
            }.navigationBarTitle("Favoritos", displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: COMPONENTS
extension FavoritesView {
    private var emptyFavorites: some View {
        VStack {
            Spacer()
            Text("Todavía no tienes paradas favoritas")
                .font(.title2)
                .padding()
            Text("Añade tus paradas favoritas desde la vista de detalles de parada usando el icono:")
                .font(.body)
                .padding()
            Image(systemSymbol: .heartSquare)
                .renderingMode(.original)
                .padding()
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
                            .foregroundColor(Color(UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)))
                            .imageScale(.large)
                            .font(.body)
                            .padding(.trailing)
                            .foregroundColor(Color.accentColor)
                        VStack(alignment: .leading) {
                            Text("Parada \(stop.code)").bold()
                            Text(stop.name)
                        }
                    }
                }.padding([.top, .bottom])
            }.onDelete(perform: delete)
        }
        .listStyle(InsetListStyle())
        .toolbar {
            EditButton()
        }
    }
}

// MARK: METHODS
extension FavoritesView {
    private func delete(offsets: IndexSet) {
        offsets.forEach { index in
            self.context.delete(favoriteStops[index])
        }
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
    }
}

// MARK: PREVIEW
#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Image(systemSymbol: .listDash)
                    Text("Preview")
                }
        }
    }
}
#endif
