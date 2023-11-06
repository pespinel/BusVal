//
//  StopTime.swift
//  BusVal
//
//  Created by Pablo on 21/05/2021.
//

import Foundation

struct StopTime: Hashable, Identifiable {
    let id = UUID()
    let code: String
    let destination: String
    let time: String
}
