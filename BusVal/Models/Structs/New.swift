//
//  New.swift
//  BusVal
//
//  Created by Pablo on 03/03/2020.
//

import Foundation

struct New: Hashable, Identifiable {
    let id = UUID()
    let title: String?
    let date: String?
    let description: String?
    let link: String?
    let image: String?
}
