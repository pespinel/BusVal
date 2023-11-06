//
//  Line.swift
//  BusVal
//
//  Created by Pablo on 01/03/2020.
//

import Foundation

struct Line: Hashable, Identifiable {
    let id = UUID()
    let line: String
    let name: String
    let friendlyName: String
    let startJourney: String?
    let returnJourney: String?
    let type: String
}
