//
//  BusStopDetails.swift
//  BusVal
//
//  Created by Pablo on 07/03/2020.
//

import Foundation

struct StopDetails: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let name: String
    let code: String
    let coordinateX: Double
    let coordinateY: Double
    let corr: String?
    let desc: String
    let lang: String
}
