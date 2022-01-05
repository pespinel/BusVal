//
//  StopDetailsStore.swift
//  BusVal
//
//  Created by Pablo on 28/12/21.
//

import MapKit
import SwiftUI

class StopDetailsStore: ObservableObject {
    @Published var stopDetails = StopDetails(
        title: "", name: "", code: "", coordinateX: 0.0, coordinateY: 0.0, corr: "", desc: "", lang: ""
    )
    @Published var checkpoints = [Checkpoint]()
    @Published var error: Wrapper.APIError?

    func fetch(stop: String) {
        if self.checkpoints.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getStopDetails(stop) { stopDetailsResponse in
                    switch stopDetailsResponse {
                    case .success(let data):
                        self.stopDetails = data
                        self.checkpoints.append(
                            Checkpoint(
                                title: data.name,
                                subtitle: "",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: data.coordinateY,
                                    longitude: data.coordinateX
                                ),
                                stop: nil
                            )
                        )
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
}
