//
//  LineDetailsContainer.swift
//  BusVal
//
//  Created by Pablo on 27/12/21.
//

import MapKit
import SwiftUI

class LineDetailsStore: ObservableObject {
    @Published var lineDetails = [LineDetails]()
    @Published var lineReturnDetails = [LineDetails]()
    @Published var checkpoints = [Checkpoint]()
    @Published var error: Wrapper.APIError?

    func fetch(line: String, rebound _: Bool = false) {
        if lineDetails.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getLineReturnDetails(line) { lineReturnDetailsResponse in
                    switch lineReturnDetailsResponse {
                    case let .success(data):
                        self.lineReturnDetails = data
                        for item in data {
                            self.checkpoints.append(
                                Checkpoint(
                                    title: "Parada \(item.code): \(item.stop)",
                                    subtitle: nil,
                                    coordinate: CLLocationCoordinate2D(
                                        latitude: item.coordinateY,
                                        longitude: item.coordinateX
                                    ),
                                    stopCode: item.code
                                )
                            )
                        }
                    case let .failure(error):
                        self.error = error
                    }
                }
                Wrapper.getLineDetails(line) { lineDetailsResponse in
                    switch lineDetailsResponse {
                    case let .success(data):
                        self.lineDetails = data
                        for item in data {
                            self.checkpoints.append(
                                Checkpoint(
                                    title: "Parada \(item.code): \(item.stop)",
                                    subtitle: nil,
                                    coordinate: CLLocationCoordinate2D(
                                        latitude: item.coordinateY,
                                        longitude: item.coordinateX
                                    ),
                                    stopCode: item.code
                                )
                            )
                        }
                    case let .failure(error):
                        self.error = error
                    }
                }
            }
        }
    }
}
