//
//  StopTimesStore.swift
//  BusVal
//
//  Created by Pablo on 28/12/21.
//

import MapKit
import SwiftUI

class StopTimesStore: ObservableObject {
    @Published var stopTimes = [[String]]()
    @Published var error: Wrapper.APIError?

    func fetch(stop: String, force: Bool = false) {
        if force {
            stopTimes.removeAll()
        }
        if stopTimes.isEmpty {
            DispatchQueue.main.async {
                Wrapper.getStopTime(stop) { stopTimeResponse in
                    switch stopTimeResponse {
                    case let .success(data):
                        self.stopTimes = data
                    case let .failure(error):
                        self.error = error
                    }
                }
            }
        }
    }
}
