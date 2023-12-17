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

// MARK: - MapView

struct MapView: View {
    // MARK: Internal

    @ObservedObject var stopsStore: StopsStore

    var body: some View {
        NavigationView {
            Map(
                initialPosition: .region(locationHelper.region)
            ) {
                ForEach(stopsStore.checkpoints) { item in
                    Annotation(
                        item.title ?? "",
                        coordinate: item.coordinate
                    ) {
                        MapAnnotationView(code: item.stop!.code)
                    }
                }
            }
            .mapControls {
                MapScaleView()
                MapCompass()
                MapUserLocationButton()
                MapPitchToggle()
            }
            .navigationBarTitle("Mapa", displayMode: .inline)
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

    // MARK: Private

    @StateObject private var locationHelper = LocationHelper()
}

// MARK: - MapView_Previews

#if DEBUG
    struct MapView_Previews: PreviewProvider {
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
