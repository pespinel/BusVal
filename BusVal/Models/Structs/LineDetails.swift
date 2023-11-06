//
//  LineDetails.swift
//  BusVal
//
//  Created by Pablo on 07/03/2021.
//

import Foundation

struct LineDetails: Hashable, Identifiable {
    let id = UUID()
    let order: String
    let line: String
    let orderJourney: String
    let orderStop: String
    let stop: String
    let corr: String
    let ext: String
    let code: String
    let coordinateX: Double
    let coordinateY: Double
    let pos: String
}
