//
//  MapView.swift
//  BusVal
//
//  Created by Pablo on 02/03/2021.
//

import CoreLocationUI
import MapKit
import SFSafeSymbols
import SwiftUI

// MARK: VIEWS
struct MapView: View {
    @ObservedObject var stopsStore: StopsStore

    @StateObject private var locationHelper = LocationHelper()

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: .constant(locationHelper.region), showsUserLocation: true,
                    userTrackingMode: .constant(.follow), annotationItems: stopsStore.checkpoints) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            MapAnnotationView(code: item.stop!.code)
                        }
                }.edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    LocationButton {
                        locationHelper.updateLocation()
                    }
                    .cornerRadius(10.0)
                    .labelStyle(.iconOnly)
                    .foregroundColor(.white)
                }.padding()
            }
            .navigationBarTitle("Mapa", displayMode: .large)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            registerScreen(view: "MapView")
        }
        .task {
            if locationHelper.locationManager?.location == nil {
                locationHelper.checkLocationStatus()
            }
        }
    }
}

#if DEBUG
struct BusStopsView_Previews: PreviewProvider {
    static var previews: some View {
        let locationHelper = LocationHelper()
        let stopsStore = StopsStore()

        TabView {
            MapView(stopsStore: stopsStore)
                .tabItem {
                    Image(systemSymbol: .listDash)
                    Text("Preview")
                }
        }.onAppear {
            stopsStore.fetch()
            if locationHelper.locationManager?.location == nil {
                locationHelper.checkLocationStatus()
            }
        }
    }
}
#endif
