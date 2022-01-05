//
//  LineSchedule.swift
//  BusVal
//
//  Created by Pablo on 14/03/2020.
//

import Foundation

struct LineSchedule: Hashable, Identifiable {
    let id = UUID()
    let line: String
    let weekdays: String
    let saturdays: String
    let festive: String
    let note: String?
}
