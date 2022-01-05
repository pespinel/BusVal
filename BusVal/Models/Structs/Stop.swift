//
//  BusStop.swift
//  BusVal
//
//  Created by Pablo on 06/03/2021.
//

import Foundation

struct Stop: Hashable, Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let friendlyName: String
    let coordinateX: Double
    let coordinateY: Double
    let corr: String?
}
