//
//  StopsStore.swift
//  BusVal
//
//  Created by Pablo on 23/12/21.
//

import MapKit
import SwiftUI

class StopsStore: ObservableObject {
    @Published var stops = [Stop]()
    @Published var checkpoints = [Checkpoint]()
    @Published var loading = false
    @Published var error: Wrapper.APIError?

    func fetch() {
        if self.stops.isEmpty || self.checkpoints.isEmpty {
            self.loading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loading = false
            }
            DispatchQueue.main.async {
                Wrapper.getStops { stopsResponse in
                    switch stopsResponse {
                    case .success(let data):
                        self.stops = data
                        for item in data {
                            self.checkpoints.append(
                                Checkpoint(
                                    title: "Parada \(item.code): \(item.name)",
                                    subtitle: nil,
                                    coordinate: CLLocationCoordinate2D(
                                        latitude: item.coordinateY,
                                        longitude: item.coordinateX
                                    ),
                                    stop: item
                                )
                            )
                        }
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
}
